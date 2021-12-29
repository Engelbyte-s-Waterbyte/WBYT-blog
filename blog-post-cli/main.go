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
	"os"
	"path/filepath"
	"strings"
)

type blogPost struct {
	Title         string
	Preview       string
	Post          string
	ThumbnailPath string
}

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

	fmt.Println("obakuma")
	if username == "" || password == "" || filePath == "" || newBlogPost.Title == "" || newBlogPost.Preview == "" || thumbnailPath == "" {
		flag.Usage()
		return
	}
	var err error

	newBlogPost.ThumbnailPath, err = postImage(thumbnailPath, username, password)

	if err != nil {
		log.Fatal("Error posting thumbnail", err)
	}
	fileContent, err := ioutil.ReadFile(filePath)
	if err != nil {
		log.Fatal("Error reading content file:", err)
	}
	newBlogPost.Post = string(fileContent)

	// TODO
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
	r, _ := http.NewRequest("POST", "http://waterbyte.bplaced.net/blog-post-api/upload-asset.php", body)
	client := http.Client{}
	resp, err := client.Do(r)
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
