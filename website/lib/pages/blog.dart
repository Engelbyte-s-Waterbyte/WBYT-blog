import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:website/components/base_layout.dart';
import 'package:website/resources/blog_post.dart';
import 'package:website/resources/resource.dart';

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
        child: FutureBuilder<List<Resource>>(
          future: fetchResource(
            resource: const BlogPost(),
            mainKey: "blog-posts",
          ),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            List<Resource> blogPosts = snapshot.data ?? [];
            return ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 569),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: blogPosts.length,
                itemBuilder: (context, index) {
                  BlogPost blogPost = blogPosts[index] as BlogPost;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image(
                        image: blogPost.thumbnail,
                        width: 202,
                        height: 130,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 40),
                      Expanded(
                        child: SizedBox(
                          height: 130,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                blogPost.title,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                blogPost.post,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  Text(
                                    "Autor: ${blogPost.creator}",
                                    style: const TextStyle(
                                        fontStyle: FontStyle.italic),
                                  ),
                                  const Spacer(),
                                  InkWell(
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    onTap: () => Navigator.pushNamed(
                                      context,
                                      "/blog/$index",
                                    ),
                                    child: const Text(
                                      "Lesen Sie mehr >>",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

Future<List<Resource>> fetchResource({
  required Resource resource,
  required String path,
  required String mainKey,
}) async {
  final response = await Dio().get("/resources/");
  final List<Resource> resources = [];
  for (var resourceJson in response.data[mainKey]) {
    resources.add(resource.fromJson(resourceJson));
  }
  return resources;
}
