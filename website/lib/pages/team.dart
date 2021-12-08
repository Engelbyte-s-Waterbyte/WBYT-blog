// ignore: file_names

// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:website/components/base_layout.dart';

class Team extends StatelessWidget {
  const Team({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: BaseLayout(
        heading: "Engelbyte's Waterbyte’s Blog",
        subHeading:
            "... verfasst von Projektmitarbeitern sowie Leasingpersonal",
        headingIcon: TablerIcons.alien,
        child: Text("abafh"),
      ),
    );
  }
}
