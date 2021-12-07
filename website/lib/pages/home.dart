import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/idol-sketch.png"),
                fit: BoxFit.fitHeight,
                alignment: Alignment.centerRight,
              ),
            ),
          ),
          Container(
            width: 242,
            padding: const EdgeInsets.only(left: 40),
            child: Column(
              children: [
                Image.asset("assets/WaterbyteLogo.png"),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    children: [
                      buildNavigationListTile(
                        context: context,
                        title: "Blog",
                        icon: TablerIcons.file_text,
                        route: "/blog",
                        active: true,
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
          const Positioned(
            bottom: 20,
            left: 20,
            child: Text(
              "Trusted by many people.",
              style: TextStyle(fontSize: 16),
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
  bool active = false,
}) {
  return InkWell(
    onTap: () => Navigator.pushNamed(context, route),
    focusColor: Colors.transparent,
    hoverColor: Colors.transparent,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.black,
            size: 32,
          ),
          const SizedBox(width: 15),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    ),
  );
}
