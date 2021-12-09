import 'package:flutter/material.dart';

class TeamMember {
  final String memberName;
  final String memberPosition;
  final String memberPic;
  final String memberDescription;
  final bool founder;

  const TeamMember(
    required this.memberName,
    required this.memberPosition,
    required this.memberPic,
    required this.memberDescription,
    required this.founder
  );

  TeamMember.fromJson(Map<String, dynamic> json)
      : memberName = json["title"],
        memberPosition = json["post"],
        memberPic = json["creator"],
        memberDescription = json["thumbnail"];

  ImageProvider get thumbnail {
    return NetworkImage(thumbnailURL);
  }
}
