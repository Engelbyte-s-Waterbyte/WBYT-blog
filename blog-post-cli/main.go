package main

import (
	"flag"
	"io/ioutil"
	"log"
)

type blogPost struct {
	Title         string `json:"title"`
	Post          string `json:"post"`
	Creator       string `json:"creator"`
	ThumbnailPath string `json:"thumbnail"`
}

func main() {
	var newBlogPost blogPost
	var filePath string
	flag.StringVar(&filePath, "path", "", "Enter path to markdown file containing blog post content")
	flag.StringVar(&newBlogPost.Title, "title", "", "Enter blog post title")
	flag.StringVar(&newBlogPost.Creator, "creator", "", "Enter blog post creator")
	flag.StringVar(&newBlogPost.ThumbnailPath, "thumbnail", "", "Enter path to blog post thumbnail")
	flag.Parse()

	if filePath == "" || newBlogPost.Title == "" || newBlogPost.Creator == "" || newBlogPost.ThumbnailPath == "" {
		flag.Usage()
		return
	}

	fileContent, err := ioutil.ReadFile(filePath)
	if err != nil {
		log.Fatal("Error reading content file:", err)
	}
	newBlogPost.Post = string(fileContent)

	// TODO
}
