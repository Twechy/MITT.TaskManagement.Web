class Developer {
  Developer({
    required this.id,
    required this.fullName,
    required this.nickName,
    required this.type,
    required this.email,
    required this.phone,
    required this.activeState,
    required this.tasks,
  });

  final String id;
  final String fullName;
  final String nickName;
  final int type;
  final String email;
  final String phone;
  final int activeState;
  final List<Task> tasks;

  factory Developer.fromJson(Map<String, dynamic> json) => Developer(
        id: json["id"],
        fullName: json["fullName"],
        nickName: json["nickName"],
        type: json["type"],
        email: json["email"],
        phone: json["phone"],
        activeState: json["activeState"],
        tasks: json["tasks"] != null
            ? List<Task>.from(json["tasks"]?.map((x) => Task.fromJson(x)))
            : List<Task>.empty(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullName": fullName,
        "nickName": nickName,
        "type": type,
        "email": email,
        "phone": phone,
        "activeState": activeState,
        "tasks": List<dynamic>.from(tasks.map((x) => x.toJson())),
      };
}

class Task {
  Task({
    required this.name,
    required this.description,
    this.requirements,
    required this.assignedManagerName,
    required this.assignedManagerId,
    required this.implementationType,
    required this.taskState,
    required this.progress,
    this.completionMessage,
    required this.startDate,
    required this.endDate,
  });

  final String name;
  final String description;
  final List<String>? requirements;
  final String assignedManagerName;
  final String assignedManagerId;
  final int implementationType;
  final int taskState;
  final int progress;
  final String? completionMessage;
  final DateTime startDate;
  final DateTime endDate;

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        name: json["name"],
        description: json["description"],
        requirements: json["requirements"] == null
            ? null
            : List<String>.from(json["requirements"].map((x) => x)),
        assignedManagerName: json["assignedManagerName"],
        assignedManagerId: json["assignedManagerId"],
        implementationType: json["implementationType"],
        taskState: json["taskState"],
        progress: json["progress"],
        completionMessage: json["completionMessage"],
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "requirements": List<dynamic>.from(requirements!.map((x) => x)),
        "assignedManagerName": assignedManagerName,
        "assignedManagerId": assignedManagerId,
        "implementationType": implementationType,
        "taskState": taskState,
        "progress": progress,
        "completionMessage": completionMessage,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
      };
}
