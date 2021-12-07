import 'package:flutter/material.dart';
import 'package:website/components/base_layout.dart';

class Blog extends StatelessWidget {
  const Blog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseLayout(
        child: Container(
          child: Text("Abfahrt"),
        ),
      ),
    );
  }
}
