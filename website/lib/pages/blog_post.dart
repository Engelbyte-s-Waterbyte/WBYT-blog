import 'package:flutter/material.dart';

class BlogPost extends StatelessWidget {
  const BlogPost({Key? key, required this.postIdx}) : super(key: key);
  final int postIdx;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text(postIdx.toString()));
  }
}
