// ignore: file_names

// ignore_for_file: file_names

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:website/components/base_layout.dart';
import 'package:website/resources/team_member.dart';

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
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        const SizedBox(height: 40),
        const Text(
          "Die Gründer",
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        FutureBuilder<List<TeamMember>>(
            future: fetchTeamMembers(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              List<TeamMember> listmember = snapshot.data ?? [];
              return GridView.builder(
                shrinkWrap: true,
                itemCount: 3,
                itemBuilder: (context, index) {
                  final teamMember = listmember[index];
                  if (listmember[index].founder == true) {}
                  return Member(
                    memberName: teamMember.name,
                    memberPosition: teamMember.position,
                    memberPic: teamMember.pic,
                    memberDescription: teamMember.description,
                  );
                },
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 500,
                    crossAxisSpacing: 60,
                    mainAxisSpacing: 100),
              );
            }),
        SizedBox(height: 20),
        SizedBox(height: 20),
        Text(
          "Leasing",
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class Member extends StatelessWidget {
  final String memberName;
  final String? memberPosition;
  final memberPic;
  final String memberDescription;

  const Member(
      {Key? key,
      required this.memberName,
      this.memberPosition,
      required this.memberPic,
      required this.memberDescription})
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
                  memberPic,
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
                  memberName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(memberPosition??''),
                Text(memberDescription),
                const SizedBox(height: 30),
              ],
            ),
          ],
        )
      ],
    ));
  }
}

Future<List<TeamMember>> fetchTeamMembers() async {
  final response = await Dio().get("/resources/team-member.json");
  final List<TeamMember> teamMembers = [];
  for (var teamMemberJson in response.data["list-member"]) {
    teamMembers.add(TeamMember.fromJson(teamMemberJson));
  }
  return teamMembers;
}
