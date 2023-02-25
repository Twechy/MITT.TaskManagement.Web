
class TaskDto {
  TaskDto({
    required this.id,
    required this.name,
    required this.description,
    required this.requirements,
    required this.assignedManagerId,
    required this.implementationType,
    required this.startDate,
    required this.endDate,
  });

  final String? id;
  final String name;
  final String description;
  final List<String> requirements;
  final String assignedManagerId;
  final int implementationType;
  final DateTime startDate;
  final DateTime endDate;

  factory TaskDto.fromJson(Map<String, dynamic> json) => TaskDto(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        requirements: List<String>.from(json["requirements"].map((x) => x)),
        assignedManagerId: json["assignedManagerId"],
        implementationType: json["implementationType"],
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "requirements": List<dynamic>.from(requirements.map((x) => x)),
        "assignedManagerId":
            assignedManagerId,
        "implementationType":
            implementationType,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
      };
}

class AssignTaskDto {
  AssignTaskDto({
    required this.assignDevType,
    required this.taskId,
    required this.developerIds,
  });

  final int assignDevType;
  final String taskId;
  final List<String> developerIds;

  factory AssignTaskDto.fromJson(Map<String, dynamic> json) => AssignTaskDto(
    assignDevType: json["assignDevType"],
    taskId: json["taskId"],
    developerIds: List<String>.from(json["developerIds"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "assignDevType": assignDevType,
    "taskId": taskId,
    "developerIds": List<String>.from(developerIds.map((x) => x)),
  };
}
