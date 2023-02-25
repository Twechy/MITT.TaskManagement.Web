class TaskVm {
  TaskVm({
    required this.id,
    required this.seqNo,
    required this.name,
    required this.description,
    required this.requirements,
    required this.assignedManagerId,
    required this.assignedManagerName,
    required this.assignedProjectId,
    required this.assignedProjectName,
    required this.implementationType,
    required this.taskState,
    required this.completionMessage,
    required this.startDate,
    required this.endDate,
    required this.timeLeft,
    required this.progress,
    required this.timeAllow,
    required this.assignedBeDevs,
    required this.assignedQaDevs,
  });

  final String id;
  final String seqNo;
  final String name;
  final String description;
  final List<String> requirements;
  final String assignedManagerId;
  final String assignedManagerName;
  final String assignedProjectId;
  final String assignedProjectName;
  final int implementationType;
  final int taskState;
  final String completionMessage;
  final DateTime startDate;
  final DateTime endDate;
  final String timeLeft;
  final String progress;
  final int timeAllow;
  final List<AssignedDev> assignedBeDevs;
  final List<AssignedDev> assignedQaDevs;

  factory TaskVm.fromJson(Map<String, dynamic> json) => TaskVm(
        id: json["id"],
        seqNo: json["seqNo"],
        name: json["name"],
        description: json["description"],
        requirements: List<String>.from(json["requirements"].map((x) => x)),
        assignedManagerId: json["assignedManagerId"],
        assignedManagerName: json["assignedManagerName"],
        assignedProjectId: json["assignedProjectId"],
        assignedProjectName: json["assignedProjectName"],
        implementationType: json["implementationType"],
        taskState: json["taskState"],
        completionMessage: json["completionMessage"],
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
        timeLeft: json["timeLeft"],
        progress: json["progress"],
        timeAllow: json["timeAllow"],
        assignedBeDevs: List<AssignedDev>.from(
            json["assignedBeDevs"].map((x) => AssignedDev.fromJson(x))),
        assignedQaDevs: List<AssignedDev>.from(
            json["assignedQaDevs"].map((x) => AssignedDev.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "seqNo": seqNo,
        "name": name,
        "description": description,
        "requirements": List<dynamic>.from(requirements.map((x) => x)),
        "assignedManagerId": assignedManagerId,
        "assignedManagerName": assignedManagerName,
        "assignedProjectId": assignedProjectId,
        "assignedProjectName": assignedProjectName,
        "implementationType": implementationType,
        "taskState": taskState,
        "completionMessage": completionMessage,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        "timeLeft": timeLeft,
        "progress": progress,
        "timeAllow": timeAllow,
        "assignedBeDevs":
            List<dynamic>.from(assignedBeDevs.map((x) => x.toJson())),
        "assignedQaDevs":
            List<dynamic>.from(assignedQaDevs.map((x) => x.toJson())),
      };
}

class AssignedDev {
  AssignedDev({
    required this.assignedTaskId,
    required this.devId,
    required this.name,
    required this.phone,
    required this.email,
    required this.reviews,
  });

  final String assignedTaskId;
  final String devId;
  final String name;
  final String phone;
  final String email;
  final List<Review> reviews;

  factory AssignedDev.fromJson(Map<String, dynamic> json) => AssignedDev(
        assignedTaskId: json["assignedTaskId"],
        devId: json["devId"],
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        reviews:
            List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "assignedTaskId": assignedTaskId,
        "devId": devId,
        "name": name,
        "phone": phone,
        "email": email,
        "reviews": List<Review>.from(reviews.map((x) => x.toJson())),
      };
}

class Review {
  Review({
    required this.reviewDate,
    required this.findings,
  });

  final DateTime reviewDate;
  final List<Finding> findings;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        reviewDate: DateTime.parse(json["reviewDate"]),
        findings: List<Finding>.from(
            json["findings"].map((x) => Finding.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "reviewDate": reviewDate.toIso8601String(),
        "findings": List<dynamic>.from(findings.map((x) => x.toJson())),
      };
}

class Finding {
  Finding({
    required this.location,
    required this.scope,
    required this.discription,
  });

  final String location;
  final String scope;
  final String discription;

  factory Finding.fromJson(Map<String, dynamic> json) => Finding(
        location: json["location"],
        scope: json["scope"],
        discription: json["discription"],
      );

  Map<String, dynamic> toJson() => {
        "location": location,
        "scope": scope,
        "discription": discription,
      };
}


class TaskNameVm {
  TaskNameVm({
    required this.id,
    required this.seqNo,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.projectType,
    required this.implementationType,
  });

  final String id;
  final String seqNo;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final int projectType;
  final int implementationType;

  factory TaskNameVm.fromJson(Map<String, dynamic> json) => TaskNameVm(
    id: json["id"],
    seqNo: json["seqNo"],
    name: json["name"],
    startDate: DateTime.parse(json["startDate"]),
    endDate: DateTime.parse(json["endDate"]),
    projectType: json["projectType"],
    implementationType: json["implementationType"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "seqNo": seqNo,
    "name": name,
    "startDate": startDate.toIso8601String(),
    "endDate": endDate.toIso8601String(),
    "projectType": projectType,
    "implementationType": implementationType,
  };
}

