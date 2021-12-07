import 'package:flutter/material.dart';

class BlogPost {
  final String title;
  final String post;
  final String creator;
  final String thumbnailURL;

  const BlogPost({
    required this.title,
    required this.post,
    required this.creator,
    required this.thumbnailURL,
  });

  BlogPost.fromJson(Map<String, dynamic> json)
      : title = json["title"],
        post = json["post"],
        creator = json["creator"],
        thumbnailURL = json["thumbnail"];

  ImageProvider get thumbnail {
    return NetworkImage(thumbnailURL);
  }
}
