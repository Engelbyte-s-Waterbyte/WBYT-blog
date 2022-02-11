package main

import (
	"encoding/json"
	"io"
	"io/ioutil"
	"log"
	"net/http"
	"path/filepath"
	"strings"
	"time"

	"github.com/Engelbyte-s-Waterbyte/WBYT-blog/waterbyte"
	"github.com/gorilla/feeds"
	"github.com/julienschmidt/httprouter"
	uuid "github.com/nu7hatch/gouuid"
)

const (
	blogPostsFile = "/var/www/waterbyte.studio/www/resources/blog-posts.json"
)

func main() {
	router := httprouter.New()

	router.GET("/feed/rss", handleRss)
	router.POST("/blog-post-api/upload-post", parseForm(false, phpAuthenticate(handleBlogPostUpload)))
	router.POST("/blog-post-api/upload-post.php", parseForm(false, phpAuthenticate(handleBlogPostUpload)))
	router.POST("/blog-post-api/upload-asset", parseForm(true, phpAuthenticate(handleAssetUpload)))
	router.POST("/blog-post-api/upload-asset.php", parseForm(true, phpAuthenticate(handleAssetUpload)))
	router.DELETE("/blog-post-api/delete-post/:delete-id", authenticate(handleBlogPostDelete))
	router.GET("/fetch-resource/:resource", handleFetchResource)

	http.ListenAndServe(":11047", router)
}

func handleRss(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	blogPosts, err := readBlogPosts()
	if err != nil {
		io.WriteString(w, err.Error())
		return
	}

	feed := &feeds.Feed{
		Title:       "Waterbyte Blog",
		Link:        &feeds.Link{Href: "https://waterbyte.studio"},
		Description: "Die aktuellsten Neuigkeiten aus der Waterbyte Entwicklungszentrale.",
		Author:      &feeds.Author{Name: "Waterbyte", Email: "office@waterbyte.studio"},
		Created:     time.Now(),
	}

	for _, blogPost := range blogPosts["blog-posts"] {
		authorEmail := strings.ToLower(blogPost.Creator)
		authorEmail = strings.ReplaceAll(authorEmail, " ", "-")
		authorEmail = strings.ReplaceAll(authorEmail, "(", "")
		authorEmail = strings.ReplaceAll(authorEmail, ")", "")
		authorEmail += "@waterbyte.studio"
		feed.Items = append(feed.Items, &feeds.Item{
			Title:       blogPost.Title,
			Link:        &feeds.Link{Href: "https://www.waterbyte.studio/blog/" + blogPost.ID},
			Description: blogPost.Preview,
			Author:      &feeds.Author{Name: blogPost.Creator, Email: authorEmail},
			Created:     blogPost.PublishedAt,
		})
	}

	rss, err := feed.ToRss()
	if err != nil {
		log.Println("Error generating rss feed:", err)
		return
	}

	io.WriteString(w, rss)
}

func handleBlogPostUpload(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	id, err := uuid.NewV4()
	if err != nil {
		io.WriteString(w, err.Error())
		return
	}
	newBlogPost := waterbyte.BlogPost{
		ID:            id.String(),
		Title:         r.Form.Get("title"),
		Preview:       r.Form.Get("preview"),
		Post:          r.Form.Get("post"),
		Creator:       r.Form.Get("username"),
		ThumbnailPath: r.Form.Get("thumbnail"),
		PublishedAt:   time.Now(),
	}

	blogPosts, err := readBlogPosts()
	if err != nil {
		io.WriteString(w, err.Error())
		return
	}

	blogPosts["blog-posts"] = append([]waterbyte.BlogPost{newBlogPost}, blogPosts["blog-posts"]...)
	err = saveBlogPosts(blogPosts)
	if err != nil {
		io.WriteString(w, err.Error())
		return
	}

	io.WriteString(w, "success")
}

func handleAssetUpload(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	file, handler, err := r.FormFile("file")
	if err != nil {
		io.WriteString(w, err.Error())
		return
	}
	defer file.Close()

	fileContent, err := ioutil.ReadAll(file)
	if err != nil {
		io.WriteString(w, err.Error())
		return
	}

	newId, err := uuid.NewV4()
	fileNameParts := strings.Split(handler.Filename, ".")
	newFileName := newId.String() + "." + fileNameParts[len(fileNameParts)-1]
	if err := ioutil.WriteFile(filepath.Join("/var/www/waterbyte.studio/www/blog-post-assets/", newFileName), fileContent, 0777); err != nil {
		io.WriteString(w, err.Error())
		return
	}

	io.WriteString(w, "File:/blog-post-assets/"+newFileName)
}

var allowedResources = []string{"projects.json", "blog-posts.json", "team-members.json"}

func handleFetchResource(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	resourceName := p.ByName("resource")
	var found bool
	for _, allowedResource := range allowedResources {
		if resourceName == allowedResource {
			found = true
			break
		}
	}
	if !found {
		return
	}

	w.Header().Set("Cache-Control", "private,max-age=30")
	w.Header().Set("Content-Type", "application/json")
	file, err := ioutil.ReadFile(filepath.Join("/var/www/waterbyte.studio/www/resources/", resourceName))
	if err != nil {
		io.WriteString(w, err.Error())
		return
	}
	w.Write(file)
}

func handleBlogPostDelete(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	deleteId := p.ByName("delete-id")
	blogPosts, err := readBlogPosts()
	if err != nil {
		io.WriteString(w, err.Error())
		return
	}

	blogPostIdx := -1
	for idx, post := range blogPosts["blog-posts"] {
		if post.ID == deleteId {
			blogPostIdx = idx
			break
		}
	}
	if blogPostIdx == -1 {
		io.WriteString(w, "success")
		return
	}
	blogPosts["blog-posts"] = append(blogPosts["blog-posts"][:blogPostIdx], blogPosts["blog-posts"][blogPostIdx+1:]...)
	err = saveBlogPosts(blogPosts)
	if err != nil {
		io.WriteString(w, err.Error())
		return
	}
	io.WriteString(w, "success")
}

func readBlogPosts() (map[string][]waterbyte.BlogPost, error) {
	file, err := ioutil.ReadFile(blogPostsFile)
	if err != nil {
		return map[string][]waterbyte.BlogPost{}, err
	}
	blogPosts := make(map[string][]waterbyte.BlogPost)
	if err := json.Unmarshal(file, &blogPosts); err != nil {
		return map[string][]waterbyte.BlogPost{}, err
	}
	return blogPosts, nil
}

func saveBlogPosts(blogPosts map[string][]waterbyte.BlogPost) error {
	newContent, err := json.MarshalIndent(blogPosts, "", "\t")
	if err != nil {
		return err
	}
	if err := ioutil.WriteFile(blogPostsFile, newContent, 0600); err != nil {
		return err
	}
	return nil
}

func parseForm(multiPart bool, next httprouter.Handle) httprouter.Handle {
	return func(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
		var err error
		if multiPart {
			err = r.ParseMultipartForm(5 << 20)
		} else {
			err = r.ParseForm()
		}
		if err != nil {
			io.WriteString(w, err.Error())
			return
		}
		next(w, r, p)
	}
}

func phpAuthenticate(next httprouter.Handle) httprouter.Handle {
	return func(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
		username := r.Form.Get("username")
		password := r.Form.Get("password")
		file, err := ioutil.ReadFile("/var/www/waterbyte.studio/users.json")
		if err != nil {
			io.WriteString(w, err.Error())
			return
		}
		var users []waterbyte.User
		if err := json.Unmarshal(file, &users); err != nil {
			io.WriteString(w, err.Error())
			return
		}
		var user *waterbyte.User
		for _, rUser := range users {
			if rUser.Username == username && rUser.Password == password {
				user = &rUser
				break
			}
		}
		if user == nil {
			io.WriteString(w, "Authentication Failed")
			return
		}
		if !user.Authorized {
			io.WriteString(w, "You are not authorized to post")
			return
		}
		next(w, r, p)
	}
}

func authenticate(next httprouter.Handle) httprouter.Handle {
	return func(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
		parts := strings.Split(r.Header.Get("authorization"), ",")
		username, password := parts[0], parts[1]
		file, err := ioutil.ReadFile("/var/www/waterbyte.studio/users.json")
		if err != nil {
			io.WriteString(w, err.Error())
			return
		}
		var users []waterbyte.User
		if err := json.Unmarshal(file, &users); err != nil {
			io.WriteString(w, err.Error())
			return
		}
		var user *waterbyte.User
		for _, rUser := range users {
			if rUser.Username == username && rUser.Password == password {
				user = &rUser
				break
			}
		}
		if user == nil {
			io.WriteString(w, "Authentication Failed")
			return
		}
		if !user.Authorized {
			io.WriteString(w, "You are not authorized to post")
			return
		}
		next(w, r, p)
	}
}
