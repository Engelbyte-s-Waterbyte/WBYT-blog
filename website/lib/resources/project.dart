import 'package:website/resources/resource.dart';

class Project extends Resource {
  final String name;
  final String pic;
  final String description;
  final String link;
  final String slogan;

  const Project({
    this.name = '',
    this.pic = '',
    this.description = '',
    this.link = '',
    this.slogan = '',
  });

  @override
  Resource fromJson(Map<String, dynamic> json) {
    return Project(
      name: json["name"],
      pic: json["pic"],
      description: json["description"],
      link: json["link"],
      slogan: json["slogan"],
    );
  }
}
