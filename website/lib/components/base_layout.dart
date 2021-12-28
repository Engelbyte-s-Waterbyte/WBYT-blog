import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:website/pages/home.dart' as $home;

class BaseLayout extends StatelessWidget {
  const BaseLayout({
    Key? key,
    required this.quote,
    required this.child,
    required this.heading,
    required this.subHeading,
    required this.headingIcon,
  }) : super(key: key);

  final String heading;
  final String subHeading;
  final IconData headingIcon;
  final Widget child;
  final String quote;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 242,
                padding: const EdgeInsets.only(left: 40),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pushNamed(context, "/"),
                      child: Image.asset(
                        "assets/WaterbyteLogo.png",
                        height: 150,
                        width: 200,
                      ),
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
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                heading,
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                                style: const TextStyle(
                                  fontSize: 58,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        subHeading,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
          Positioned(
            bottom: 20,
            left: 20,
            child: Text(
              quote,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildNavigationListTile({
  required BuildContext context,
  required String title,
  required IconData icon,
  required String route,
}) {
  final active = ModalRoute.of(context)!.settings.name == route;
  return $home.buildNavigationListTile(
    context: context,
    title: title,
    icon: icon,
    route: route,
    active: active,
  );
}
