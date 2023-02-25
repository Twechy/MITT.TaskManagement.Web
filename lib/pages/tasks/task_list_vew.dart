import 'package:flutter/material.dart';
import 'package:taskmanagement/widgets/helpers.dart';

import 'task_index.dart';

class TaskListView extends StatelessWidget {
  static const String route = '/projectDetails';
  final String projectId;
  final String developerId;

  const TaskListView({
    super.key,
     this.projectId = '',
     this.developerId = '',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: textView('Tasks', color: Colors.white),
        centerTitle: true,
      ),
      body: TaskDetail(
        projectId: projectId,
        developerId: developerId,
      ),
    );
  }
}
