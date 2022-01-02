import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:website/components/base_layout.dart';
import 'package:website/pages/blog.dart';
import 'package:website/pages/not_found.dart';
import 'package:website/resources/blog_post.dart' as resources;
import 'package:website/resources/resource.dart';

class BlogPost extends StatefulWidget {
  const BlogPost({Key? key, required this.postId}) : super(key: key);
  final int postId;

  @override
  State<BlogPost> createState() => _BlogPostState();
}

class _BlogPostState extends State<BlogPost> {
  resources.BlogPost? blogPost;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadBlogPost();
  }

  @override
  Widget build(BuildContext context) {
    if (!loading && blogPost == null) {
      return const NotFound();
    }
    return BaseLayout(
      heading: blogPost?.title ?? "",
      subHeading:
          blogPost?.creator == null ? "" : "Ersteller: " + blogPost!.creator,
      headingIcon: TablerIcons.file_text,
      quote: '',
      child: Column(
        children: [
          blogPost == null
              ? const CircularProgressIndicator()
              : MarkdownWidget(
                  data: blogPost!.post,
                  loadingWidget: const CircularProgressIndicator(),
                  shrinkWrap: true,
                ),
        ],
      ),
    );
  }

  void loadBlogPost() async {
    setState(() => loading = true);
    final posts = await fetchResource(
      resource: const resources.BlogPost(),
      path: "blog-posts.json",
      mainKey: "blog-posts",
    );
    setState(() {
      // ignore: unnecessary_cast
      blogPost = posts.cast<resources.BlogPost?>().firstWhere(
            (blogPost) => blogPost!.id == widget.postId,
            orElse: () => null,
          ) as resources.BlogPost?;
      loading = false;
    });
  }
}
