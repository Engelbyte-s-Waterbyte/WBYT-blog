package main

import (
	"bytes"
	"errors"
	"flag"
	"io"
	"io/ioutil"
	"log"
	"mime/multipart"
	"net/http"
	"net/url"
	"os"
	"path/filepath"
	"regexp"
	"strings"
)

const (
	ServerURL = "http://194.163.130.122"
)

type blogPost struct {
	Title         string
	Preview       string
	Post          string
	ThumbnailPath string
}

// func main() {
// 	// post := "aufstehen ![zeppe](fads) ![zeppe](asdf)"
// 	// const regexForExtractingImage = `!\[(.*?)\]\((.*?)\)`
// 	// r := regexp.MustCompile(regexForExtractingImage)
// 	// matches := r.FindAllString(post, -1)
// 	// for _, match := range matches {
// 	// 	regexForGettingImageName := `(^(!\[)|\]\(.*\))`
// 	// 	reg := regexp.MustCompile(regexForGettingImageName)
// 	// 	res := reg.ReplaceAllString(match, "")
// 	// 	newPath := "loisl"
// 	// 	post = strings.Replace(post, res, newPath, 1)
// 	// 	fmt.Printf("%s\n", post)

// 	// }
// }

func main() {
	var username string
	var password string
	var newBlogPost blogPost
	var filePath string
	var thumbnailPath string
	flag.StringVar(&username, "username", "", "Enter username")
	flag.StringVar(&password, "password", "", "Enter password")
	flag.StringVar(&filePath, "path", "", "Enter path to markdown file containing blog post content")
	flag.StringVar(&newBlogPost.Title, "title", "", "Enter blog post title")
	flag.StringVar(&newBlogPost.Preview, "preview", "", "Enter preview text")
	flag.StringVar(&thumbnailPath, "thumbnail", "", "Enter path to blog post thumbnail")
	flag.Parse()

	if username == "" || password == "" || filePath == "" || newBlogPost.Title == "" || newBlogPost.Preview == "" || thumbnailPath == "" {
		flag.Usage()
		return
	}
	var err error

	newBlogPost.ThumbnailPath, err = postImage(thumbnailPath, username, password)

	if err != nil {
		log.Fatal("Error posting thumbnail:", err)
	}
	fileContent, err := ioutil.ReadFile(filePath)
	if err != nil {
		log.Fatal("Error reading content file:", err)
	}
	newBlogPost.Post = string(fileContent)

	processBlogPost(&newBlogPost, username, password)
	publishBlogPost(newBlogPost, username, password)
}

func postImage(path, username, password string) (string, error) {
	file, err := os.Open(path)
	if err != nil {
		return "", err
	}
	body := &bytes.Buffer{}
	writer := multipart.NewWriter(body)
	part, _ := writer.CreateFormFile("file", filepath.Base(file.Name()))
	io.Copy(part, file)
	upart, _ := writer.CreateFormField("username")
	io.WriteString(upart, username)
	ppart, _ := writer.CreateFormField("password")
	io.WriteString(ppart, password)
	writer.Close()
	resp, err := http.Post(ServerURL+"/blog-post-api/upload-asset.php", writer.FormDataContentType(), body)
	if err != nil {
		return "", err
	}
	b, _ := ioutil.ReadAll(resp.Body)
	body2 := string(b)
	if !strings.HasPrefix(body2, "File:") {
		return "", errors.New(body2)
	}
	return body2[5:], err
}

func processBlogPost(post *blogPost, username string, password string) error {
	const regexForExtractingImage = `!\[(.*?)\]\((.*?)\)`
	const regexForGettingImageName = `(^(!\[)|\]\(.*\))`
	r := regexp.MustCompile(regexForExtractingImage)
	reg := regexp.MustCompile(regexForGettingImageName)

	matches := r.FindAllString(post.Post, -1)
	for _, match := range matches {
		res := reg.ReplaceAllString(match, "")
		newPath, _ := postImage(res, username, password)
		post.Post = strings.Replace(post.Post, res, newPath, 1)
	}
	return nil
}

func publishBlogPost(post blogPost, username, password string) error {
	params := url.Values{}
	params.Add("username", username)
	params.Add("password", password)
	params.Add("title", post.Title)
	params.Add("preview", post.Preview)
	params.Add("post", post.Post)
	params.Add("thumbnail", post.ThumbnailPath)

	resp, err := http.PostForm(ServerURL+"/blog-post-api/upload-post.php", params)
	if err != nil {
		return err
	}
	b, _ := ioutil.ReadAll(resp.Body)
	body := string(b)
	if body != "success" {
		return errors.New(body)
	}
	return nil
}
