import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:website/pages/home.dart';

class BaseLayout extends StatelessWidget {
  const BaseLayout({
    Key? key,
    required this.child,
    required this.heading,
    required this.subHeading,
    required this.headingIcon,
  }) : super(key: key);

  final String heading;
  final String subHeading;
  final IconData headingIcon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          const Positioned(
            bottom: 20,
            left: 20,
            child: Text(
              "Trusted by many people.",
              style: TextStyle(fontSize: 16),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 242,
                padding: const EdgeInsets.only(left: 40),
                child: Column(
                  children: [
                    Image.asset(
                      "assets/WaterbyteLogo.png",
                      height: 150,
                      width: 200,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        children: [
                          buildNavigationListTile(
                            context: context,
                            title: "Blog",
                            icon: TablerIcons.file_text,
                            route: "/blog",
                          ),
                          buildNavigationListTile(
                            context: context,
                            title: "Projects",
                            icon: TablerIcons.ambulance,
                            route: "/projects",
                          ),
                          buildNavigationListTile(
                            context: context,
                            title: "Team",
                            icon: TablerIcons.alien,
                            route: "/team",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(headingIcon),
                          Text(heading),
                        ],
                      ),
                      Text(subHeading),
                      child
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
