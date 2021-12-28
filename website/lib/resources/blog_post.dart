import 'package:flutter/material.dart';
import 'package:website/resources/resource.dart';

class BlogPost extends Resource {
  final String title;
  final String post;
  final String creator;
  final String thumbnailURL;

  const BlogPost({
    this.title = '',
    this.post = '',
    this.creator = '',
    this.thumbnailURL = '',
  });

  BlogPost.fromJson(Map<String, dynamic> json)
      : title = json["title"],
        post = json["post"],
        creator = json["creator"],
        thumbnailURL = json["thumbnail"];

  ImageProvider get thumbnail {
    return NetworkImage(thumbnailURL);
  }

  @override
  BlogPost fromJson(Map<String, dynamic> json) {
    return BlogPost(
      title: json["title"],
      post: json["post"],
      creator: json["creator"],
      thumbnailURL: json["thumbnail"],
    );
  }
}
