import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:website/components/base_layout.dart';

class NotFound extends StatelessWidget {
  const NotFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      quote: "",
      child: Image.asset("assets/idol-sketch.png"),
      heading: "Diese Seite existiert nicht",
      subHeading:
          "Bert konnte trotz allen Mühen, Schweiß, Blut und Tränen die Seite, die Sie angefordert haben nicht finden.",
      headingIcon: TablerIcons.eyeglass,
    );
  }
}
