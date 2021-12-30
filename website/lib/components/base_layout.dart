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
    final width = MediaQuery.of(context).size.width;
    final mobileBreak = width <= 1000;
    final titleScalar = mobileBreak
        ? Scalar(
            context: context,
            widthFrom: 375,
            widthTo: 960,
            from: 30,
            to: 58,
          )
        : Scalar(
            context: context,
            widthFrom: 1000,
            widthTo: 1300,
            from: 36,
            to: 58,
          );
    final subtitleScalar = mobileBreak
        ? Scalar(
            context: context,
            widthFrom: 375,
            widthTo: 960,
            from: 16,
            to: 38,
          )
        : Scalar(
            context: context,
            widthFrom: 1000,
            widthTo: 1300,
            from: 26,
            to: 48,
          );
    final iconScalar = titleScalar;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (mobileBreak)
            Row(
              children: [
                const SizedBox(width: 20),
                InkWell(
                  onTap: () => Navigator.pushNamed(context, "/"),
                  child: Image.asset(
                    "assets/WaterbyteLogo.png",
                    width: 150,
                  ),
                ),
                const Spacer(),
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => Navigator.pushNamed(context, "/"),
                  child: const Icon(
                    TablerIcons.menu_2,
                    size: 50,
                  ),
                ),
                const SizedBox(width: 30),
              ],
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!mobileBreak)
                    Row(
                      children: [
                        SizedBox(
                          width: 242,
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
                      ],
                    ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (width > 1000) const SizedBox(height: 60),
                          Row(
                            children: [
                              Icon(
                                headingIcon,
                                size: iconScalar.doubleValue,
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    heading,
                                    style: TextStyle(
                                      fontSize: titleScalar.doubleValue,
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
                            style: TextStyle(
                              fontSize: subtitleScalar.doubleValue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 30),
                          child,
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),
                ],
              ),
            ),
          ),
          Row(
            children: [
              const Spacer(),
              Expanded(
                flex: 3,
                child: Text(
                  quote,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: Scalar(
                      context: context,
                      widthFrom: 375,
                      widthTo: 1200,
                      from: 15,
                      to: 20,
                    ).doubleValue,
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

class Scalar {
  final double from;
  final double to;
  final double widthFrom;
  final double widthTo;
  final BuildContext context;

  const Scalar({
    required this.from,
    required this.to,
    required this.context,
    required this.widthFrom,
    required this.widthTo,
  });

  double get doubleValue {
    final width = MediaQuery.of(context).size.width;
    if (width < widthFrom) {
      return from;
    }
    if (width > widthTo) {
      return to;
    }
    final unit = (to - from) / (widthTo - widthFrom);
    return from + (width - widthFrom) * unit;
  }

  int get intValue => doubleValue as int;

  Scalar inherit({required double from, required double to}) => Scalar(
        context: context,
        from: from,
        to: to,
        widthFrom: widthFrom,
        widthTo: widthTo,
      );
}
