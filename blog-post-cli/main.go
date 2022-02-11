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

	"github.com/Engelbyte-s-Waterbyte/WBYT-blog/waterbyte"
)

const (
	ServerURL = "https://waterbyte.studio"
)

func main() {
	var username string
	var password string
	var newBlogPost waterbyte.BlogPost
	var filePath string
	var thumbnailPath string
	var deleteId string
	flag.StringVar(&username, "username", "", "Enter username")
	flag.StringVar(&password, "password", "", "Enter password")
	flag.StringVar(&filePath, "path", "", "Enter path to markdown file containing blog post content")
	flag.StringVar(&newBlogPost.Title, "title", "", "Enter blog post title")
	flag.StringVar(&newBlogPost.Preview, "preview", "", "Enter preview text")
	flag.StringVar(&thumbnailPath, "thumbnail", "", "Enter path to blog post thumbnail")
	flag.StringVar(&deleteId, "delete id", "", "Enter the id of the blog post to delete")
	flag.Parse()

	if (username == "" || password == "" || filePath == "" || newBlogPost.Title == "" || newBlogPost.Preview == "" || thumbnailPath == "") && deleteId == "" {
		flag.Usage()
		return
	}
	if deleteId == "" {
		postNewBlogPost(username, password, newBlogPost, filePath, thumbnailPath)
	} else {
		deleteBlogPost(username, password, deleteId)
	}
}

func postNewBlogPost(username, password string, newBlogPost waterbyte.BlogPost, filePath, thumbnailPath string) {
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

	err = processBlogPost(&newBlogPost, username, password)
	if err != nil {
		log.Fatal("Error processing blog post:", err)
	}
	err = publishBlogPost(newBlogPost, username, password)
	if err != nil {
		log.Fatal("Error publishing post:", err)
	}
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
	resp, err := http.Post(ServerURL+"/blog-post-api/upload-asset", writer.FormDataContentType(), body)
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

func processBlogPost(post *waterbyte.BlogPost, username string, password string) error {
	const regexForExtractingImage = `!\[(.*?)\]\((.*?)\)`
	const regexForGettingImageName = `(^(!\[.*\]\()|\))`
	r := regexp.MustCompile(regexForExtractingImage)
	reg := regexp.MustCompile(regexForGettingImageName)

	matches := r.FindAllString(post.Post, -1)
	for _, match := range matches {
		res := reg.ReplaceAllString(match, "")
		newPath, err := postImage(res, username, password)
		if err != nil {
			return err
		}
		post.Post = strings.Replace(post.Post, res, newPath, 1)
	}
	return nil
}

func publishBlogPost(post waterbyte.BlogPost, username, password string) error {
	params := url.Values{}
	params.Add("username", username)
	params.Add("password", password)
	params.Add("title", post.Title)
	params.Add("preview", post.Preview)
	params.Add("post", post.Post)
	params.Add("thumbnail", post.ThumbnailPath)

	resp, err := http.PostForm(ServerURL+"/blog-post-api/upload-post", params)
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

func deleteBlogPost(username, password, deleteId string) {
	client := &http.Client{}
	req, err := http.NewRequest("DELETE", ServerURL+"/blog-post-api/delete-post/"+deleteId, nil)
	if err != nil {
		log.Fatal("Error 1:", err)
	}
	res, err := client.Do(req)
	if err != nil {
		log.Fatal("Error 2:", err)
	}
	body, err := ioutil.ReadAll(res.Body)
	if err != nil {
		log.Fatal("Error 3:", err)
	}
	bodyStr := string(body)
	if bodyStr != "success" {
		log.Fatal("Error 4:", err)
	}
}
