package waterbyte

import "time"

type BlogPost struct {
	ID            string    `json:"id"`
	Title         string    `json:"title"`
	Preview       string    `json:"preview"`
	Post          string    `json:"post"`
	Creator       string    `json:"creator"`
	ThumbnailPath string    `json:"thumbnail"`
	PublishedAt   time.Time `json:"published_at"`
}

type User struct {
	Username   string `json:"username"`
	Password   string `json:"password"`
	Authorized bool   `json:"authorized"`
}
