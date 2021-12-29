package main

import (
	"bytes"
	"errors"
	"flag"
	"fmt"
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
	ServerURL = "http://waterbyte.bplaced.net"
)

type blogPost struct {
	Title         string
	Preview       string
	Post          string
	ThumbnailPath string
}

func main() {
	processBlogPost(nil)
}

func main2() {
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

	processBlogPost(&newBlogPost)

	// publishBlogPost(newBlogPost)
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

func processBlogPost(post *blogPost) error {
	match, _ := regexp.MatchString("(?<alt>!\\[[^\\]]*\\])\\((?<filename>.*?)(?=\"|\\))\\)", "![kek](kek)")
	fmt.Print(match)
	return nil
}

func publishBlogPost(post blogPost, username, password string) error {
	var params url.Values
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
