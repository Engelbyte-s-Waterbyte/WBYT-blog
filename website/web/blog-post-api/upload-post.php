<?php

require('auth.inc.php');

$new_blog_post = array(
    'id' => uniqid(),
    'title' => $_POST["title"],
    'preview' => $_POST["preview"],
    'post' => $_POST["post"],
    'creator' => $user->username,
    'thumbnail' => $_POST["thumbnail"],
);

$blog_posts_path = '../resources/blog-posts.json';
$blog_posts = json_decode(file_get_contents($blog_posts_path), true);
array_unshift($blog_posts["blog-posts"], $new_blog_post);
file_put_contents($blog_posts_path, json_encode($blog_posts, JSON_PRETTY_PRINT));
die('success');
