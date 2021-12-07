import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:website/components/base_layout.dart';
import 'package:website/resources/blog_post.dart';

class Blog extends StatelessWidget {
  const Blog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseLayout(
        heading: "Engelbyte's Waterbyte’s Blog",
        subHeading:
            "... verfasst von Projektmitarbeitern sowie Leasingpersonal",
        headingIcon: TablerIcons.file_text,
        child: FutureBuilder<List<BlogPost>>(
          future: fetchBlogPosts(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            List<BlogPost> blogPosts = snapshot.data ?? [];
            return ListView.builder(
              shrinkWrap: true,
              itemCount: blogPosts.length,
              itemBuilder: (context, index) {
                BlogPost blogPost = blogPosts[index];
                return Row(
                  children: [
                    Image(
                      image: blogPost.thumbnail,
                      width: 202,
                      height: 130,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 40),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(blogPost.title),
                          Text(blogPost.post),
                          Text(blogPost.creator),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<List<BlogPost>> fetchBlogPosts() async {
    final response = await Dio().get("/resources/blog-posts.json");
    final List<BlogPost> blogPosts = [];
    for (var blogPostJson in response.data["blog-posts"]) {
      blogPosts.add(BlogPost.fromJson(blogPostJson));
    }
    return blogPosts;
  }
}
