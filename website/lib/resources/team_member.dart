
class TeamMember {
  final String name;
  final String position;
  final String pic;
  final String description;
  final bool founder;

  const TeamMember({
    required this.name,
    required this.position,
    required this.pic,
    required this.description,
    required this.founder,
  });

  TeamMember.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        position = json["position"],
        pic = json["pic"],
        description = json["description"],
        founder = json.containsKey("founder");
}
