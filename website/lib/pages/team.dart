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
        subHeading:
            "Unser Personal - voller Ergeiz und Motivation ",
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
      "name": "Ungabunga",
      "position": "Knecht",
      "pic": "img/1.jpg",
      "description": "loremloisl"
    },
    {
      "name": "Tops",
      "position": "Daddy",
      "pic": "img/2.jpg",
      "description": "loremloisl"
    },
    {
      "name": "Sandele Groani",
      "position": "Chiller",
      "pic": "img/3.jpg",
      "description": "loremloisl"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
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
          maxCrossAxisExtent: 200,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20),
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
      this.member_name,
      this.member_position,
      this.member_pic,
      this.member_description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Hero(
        tag: member_name,
        child: Material(
            child: InkWell(
                child: GridTile(
          child: Image.asset(member_pic),
        ))),
      ),
    );
  }
}
