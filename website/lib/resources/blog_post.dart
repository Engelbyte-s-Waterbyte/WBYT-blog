import 'package:flutter/material.dart';
import 'package:website/resources/resource.dart';

class BlogPost extends Resource {
  final int id;
  final String title;
  final String preview;
  final String post;
  final String creator;
  final String thumbnailURL;

  const BlogPost({
    this.id = 0,
    this.title = '',
    this.preview = '',
    this.post = '',
    this.creator = '',
    this.thumbnailURL = '',
  });

  ImageProvider get thumbnail {
    return NetworkImage(thumbnailURL);
  }

  @override
  BlogPost fromJson(Map<String, dynamic> json) {
    return BlogPost(
      id: json["id"],
      title: json["title"],
      preview: json["preview"],
      post: json["post"],
      creator: json["creator"],
      thumbnailURL: json["thumbnail"],
    );
  }
}
