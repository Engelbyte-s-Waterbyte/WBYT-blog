import 'package:website/resources/resource.dart';

class TeamMember extends Resource {
  final String name;
  final String position;
  final String pic;
  final String description;
  final bool founder;

  const TeamMember({
    this.name = '',
    this.position = '',
    this.pic = '',
    this.description = '',
    this.founder = false,
  });

  @override
  Resource fromJson(Map<String, dynamic> json) {
    return TeamMember(
      name: json["name"],
      position: json["position"],
      pic: json["pic"],
      description: json["description"],
      founder: json.containsKey("founder"),
    );
  }
}
