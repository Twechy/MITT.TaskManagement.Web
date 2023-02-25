class AddProjectDto {
  AddProjectDto({
    required this.id,
    required this.name,
    required this.description,
    required this.projectType,
  });

  final String? id;
  final String name;
  final String description;
  final int projectType;

  factory AddProjectDto.fromJson(Map<String, dynamic> json) => AddProjectDto(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        projectType: json["projectType"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "projectType": projectType,
      };
}
