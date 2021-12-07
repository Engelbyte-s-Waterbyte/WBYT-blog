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
      backgroundColor: Colors.white,
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
              const SizedBox(width: 100),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60),
                      Row(
                        children: [
                          Icon(headingIcon, size: 55),
                          const SizedBox(width: 20),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              heading,
                              style: const TextStyle(
                                fontSize: 58,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        subHeading,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      child,
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
