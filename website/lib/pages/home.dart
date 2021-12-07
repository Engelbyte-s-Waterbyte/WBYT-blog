import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset("assets/WaterbyteLogo.png", width: 242),
              buildNavigationListTile(
                context: context,
                title: "Blog",
                icon: TablerIcons.file_text,
                route: "/blog",
              ),
            ],
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

  ListTile buildNavigationListTile({
    required BuildContext context,
    required String title,
    required IconData icon,
    required String route,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.black,
      ),
      onTap: () => Navigator.pushNamed(context, route),
      title: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
