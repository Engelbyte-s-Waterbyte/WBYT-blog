package main

import (
	"encoding/json"
	"io"
	"io/ioutil"
	"net/http"
	"path/filepath"
	"strings"
	"time"

	"github.com/Engelbyte-s-Waterbyte/WBYT-blog/waterbyte"
	"github.com/julienschmidt/httprouter"
	uuid "github.com/nu7hatch/gouuid"
)

const (
	blogPostsFile = "/var/www/waterbyte.studio/www/resources/blog-posts.json"
)

func main() {
	router := httprouter.New()

	router.GET("/rss", handleRss)
	router.POST("/blog-post-api/upload-post", parseForm(authenticate(handleBlogPostUpload)))
	router.POST("/blog-post-api/upload-asset", parseForm(authenticate(handleAssetUpload)))
	router.GET("/fetch-resource/:resource", handleFetchResource)

	http.ListenAndServe(":11047", router)
}

func handleRss(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	time.Now().Format(time.RFC3339)
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
		Creator:       r.Form.Get("creator"),
		ThumbnailPath: r.Form.Get("thumbnail"),
		PublishedAt:   time.Now(),
	}

	file, err := ioutil.ReadFile(blogPostsFile)
	if err != nil {
		io.WriteString(w, err.Error())
		return
	}
	blogPosts := make(map[string][]waterbyte.BlogPost)
	if err := json.Unmarshal(file, &blogPosts); err != nil {
		io.WriteString(w, err.Error())
		return
	}

	blogPosts["blog-posts"] = append([]waterbyte.BlogPost{newBlogPost}, blogPosts["blog-posts"]...)
	newContent, err := json.MarshalIndent(blogPosts, "", "\t")
	if err != nil {
		io.WriteString(w, err.Error())
		return
	}
	if err := ioutil.WriteFile(blogPostsFile, newContent, 0600); err != nil {
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
	if err := ioutil.WriteFile(filepath.Join("/var/www/waterbyte.studio/www/blog-post-assets/", newFileName), fileContent, 0600); err != nil {
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

func parseForm(next httprouter.Handle) httprouter.Handle {
	return func(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
		if err := r.ParseMultipartForm(5 << 20); err != nil {
			io.WriteString(w, err.Error())
			return
		}
		next(w, r, p)
	}
}

func authenticate(next httprouter.Handle) httprouter.Handle {
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
