
class Project {
  final String name;
  final String pic;
  final String description;
  final String link;
  final String slogan;

  const Project({
    required this.name,
    required this.pic,
    required this.description,
    required this.link,
    required this.slogan
  });

  Project.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        pic = json["pic"],
        description = json["description"],
        link = json["link"],
        slogan = json["slogan"];
}
