import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:website/components/base_layout.dart';

class Blog extends StatelessWidget {
  const Blog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("here");
    return Scaffold(
      body: BaseLayout(
        heading: "Engelbyte's Waterbyte’s Blog",
        subHeading:
            "... verfasst von Projektmitarbeitern sowie Leasingpersonal",
        headingIcon: TablerIcons.file_text,
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                ),
                Text("fsdfd"),
              ],
            ),
          );
        }),
      ),
    );
  }
}
