package main

import (
	"fmt"
	"log"
	"os"
	"os/exec"
	"path/filepath"

	"github.com/fsnotify/fsnotify"
)

var watcher *fsnotify.Watcher

func main() {
	var err error
	watcher, err = fsnotify.NewWatcher()
	if err != nil {
		log.Fatal(err)
	}
	defer watcher.Close()

	if err := filepath.Walk(".", watchDir); err != nil {
		fmt.Println("ERROR", err)
	}

	done := make(chan bool)
	var cmd *exec.Cmd
	go func() {
		for {
			select {
			case _, ok := <-watcher.Events:
				if !ok {
					return
				}
				fmt.Println("here")
				if cmd != nil {
					if cmd.Process != nil {
						fmt.Println("kill")
						cmd.Process.Kill()
					}
				}
				cmd = exec.Command("flutter", "build", "web")
				fmt.Println(cmd.Run(), cmd.Stderr, cmd.Stdout)
			case err, ok := <-watcher.Errors:
				if !ok {
					return
				}
				log.Println("error:", err)
			}
		}
	}()

	if err != nil {
		log.Fatal(err)
	}
	<-done
}

func watchDir(path string, fi os.FileInfo, err error) error {
	if fi.Mode().IsDir() {
		return watcher.Add(path)
	}

	return nil
}
