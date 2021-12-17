
class Project {
  final String name;
  final String pic;
  final String description;
  final String githubURL;

  const Project({
    required this.name,
    required this.pic,
    required this.description,
    required this.githubURL,
  });

  Project.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        pic = json["pic"],
        description = json["description"],
        githubURL = json["githubURL"];
}
