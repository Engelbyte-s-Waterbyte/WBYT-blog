import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

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
