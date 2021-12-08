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
        heading: "Das Team",
        subHeading: "Unser Personal - voller Ehrgeiz und Motivation ",
        headingIcon: TablerIcons.alien,
        child: Members(),
      ),
    );
  }
}

class Members extends StatefulWidget {
  const Members({Key? key}) : super(key: key);

  @override
  _MembersState createState() => _MembersState();
}

class _MembersState extends State<Members> {
  final list_member = [
    {
      "name": "Miks",
      "position": "Projektleiter",
      "pic": "img/1.jpg",
      "description": "Kommunikation/Eskalation",
      "founder": true
    },
    {
      "name": "Tops",
      "position": "Projektmitarbeiter",
      "pic": "img/2.jpg",
      "description": "interne Projektmotivation",
      "founder": true
    },
    {
      "name": "Sandele Groani",
      "position": "Projektmitarbeiterstellvertreter",
      "pic": "img/3.jpg",
      "description": "Periodischer Chill, Statusbericht",
      "founder": true
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 40),
        Text(
          "Die Gründer",
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          itemCount: list_member.length,
          itemBuilder: (BuildContext context, int index) {
            if (list_member[index]['founder'] == true) {}
            return Member(
              member_name: list_member[index]['name'],
              member_position: list_member[index]['position'],
              member_pic: list_member[index]['pic'],
              member_description: list_member[index]['description'],
            );
          },
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 500,
              crossAxisSpacing: 60,
              mainAxisSpacing: 100),
        ),
        SizedBox(height: 20),
        SizedBox(height: 20),
        Text(
          "Leasing",
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          itemCount: list_member.length,
          itemBuilder: (BuildContext context, int index) {
            return Member(
              member_name: list_member[index]['name'],
              member_position: list_member[index]['position'],
              member_pic: list_member[index]['pic'],
              member_description: list_member[index]['description'],
            );
          },
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 500,
              crossAxisSpacing: 50,
              mainAxisSpacing: 20),
        ),
      ],
    );
  }
}

class Member extends StatelessWidget {
  final member_name;
  final member_position;
  final member_pic;
  final member_description;

  const Member(
      {Key? key,
      required this.member_name,
      this.member_position,
      required this.member_pic,
      required this.member_description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridTile(
          child: Container(
              height: 500,
              width: 400,
              child: AspectRatio(
                aspectRatio: 1.5,
                child: Image.asset(
                  member_pic,
                  fit: BoxFit.cover,
                ),
              )),
        ),
        Row(
          children: [
            const SizedBox(width: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Text(
                  member_name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(member_position),
                Text(member_description),
                const SizedBox(height: 30),
              ],
            ),
          ],
        )
      ],
    ));
  }
}
