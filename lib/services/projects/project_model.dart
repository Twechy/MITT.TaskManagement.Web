import 'dart:convert';


class OperationResult {
  OperationResult({
    required this.type,
    required this.messages,
    required this.traceId,
  });

  final int type;
  final List<String> messages;
  final String traceId;

  factory OperationResult.fromJson(Map<String, dynamic> json) =>
      OperationResult(
        type: json["type"],
        messages: List<String>.from(json["messages"].map((x) => x)),
        traceId: json["traceId"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "messages": List<dynamic>.from(messages.map((x) => x)),
        "traceId": traceId,
      };
}

class OperationResultWithData<T> {
  OperationResultWithData({
    required this.type,
    required this.messages,
    required this.traceId,
    required this.content,
  });

  final int type;
  final List<String> messages;
  final String traceId;
  final T content;

  factory OperationResultWithData.fromJson(Map<String, dynamic> json, T type) =>
      OperationResultWithData(
        type: json["type"],
        messages: List<String>.from(json["messages"].map((x) => x)),
        traceId: json["traceId"],
        content: type,
      );
}

class Project {
  Project({
    required this.id,
    required this.name,
    required this.description,
    required this.projectType,
    required this.managers,
  });

  final String id;
  final String name;
  final String description;
  final ProjectType projectType;
  final List<Manager> managers;

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        projectType: parseToProjectType(json["projectType"]),
        managers: List<Manager>.from(json["managers"] == null
            ? []
            : json["managers"].map((x) => Manager.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "projectType": parseProjectType(projectType),
        "managers": List<Manager>.from(managers.map((x) => x.toJson())),
      };

  static int parseProjectType(ProjectType projectType) {
    switch (projectType) {
      case ProjectType.mobile:
        return 0;
      case ProjectType.payment:
        return 1;
      case ProjectType.web:
        return 2;
      case ProjectType.other:
        return 3;
      default:
        return 3;
    }
  }

  @override
  String toString() {
    return "id: $id name: $name description: $description type: $projectType managerCount: ${managers.length}";
  }

  static ProjectType parseToProjectType(projectType) {
    switch (projectType) {
      case 0:
        return ProjectType.mobile;
      case 1:
        return ProjectType.payment;
      case 2:
        return ProjectType.web;
      case 3:
        return ProjectType.other;
      default:
        return ProjectType.none;
    }
  }
}

class Manager {
  Manager({
    required this.id,
    required this.fullName,
    required this.nickName,
    required this.email,
    required this.phone,
    required this.activeState,
    required this.activeTasks,
  });

  final String? id;
  final String fullName;
  final String nickName;
  final String email;
  final String phone;
  final int activeState;
  final int activeTasks;

  factory Manager.fromJson(Map<String, dynamic> json) => Manager(
        id: json["id"],
        fullName: json["fullName"],
        nickName: json["nickName"],
        email: json["email"],
        phone: json["phone"],
        activeState: json["activeState"],
        activeTasks: json["activeTasks"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullName": fullName,
        "nickName": nickName,
        "email": email,
        "phone": phone,
        "activeState": activeState,
        "activeTasks": activeTasks,
      };
}

enum ProjectType { none, mobile, payment, web, other }

class AssignManagerDto {
  AssignManagerDto({
    required this.projectId,
    required this.managerIds,
  });

  final String projectId;
  final List<String> managerIds;

  factory AssignManagerDto.fromRawJson(String str) =>
      AssignManagerDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AssignManagerDto.fromJson(Map<String, dynamic> json) =>
      AssignManagerDto(
        projectId: json["projectId"],
        managerIds: List<String>.from(json["managerIds"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "projectId": projectId,
        "managerIds": List<dynamic>.from(managerIds.map((x) => x)),
      };
}

class ManagerByProjectVm {
  ManagerByProjectVm({
    required this.assignedManagers,
    required this.freeManagers,
  });

  final List<Manager> assignedManagers;
  final List<Manager> freeManagers;

  factory ManagerByProjectVm.fromJson(Map<String, dynamic> json) =>
      ManagerByProjectVm(
        assignedManagers: List<Manager>.from(
            json["assignedManagers"].map((x) => Manager.fromJson(x))),
        freeManagers: List<Manager>.from(
            json["freeManagers"].map((x) => Manager.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "assignedManagers":
            List<dynamic>.from(assignedManagers.map((x) => x.toJson())),
        "freeManagers": List<dynamic>.from(freeManagers.map((x) => x.toJson())),
      };
}
