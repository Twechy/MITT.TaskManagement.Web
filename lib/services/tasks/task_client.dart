import 'package:taskmanagement/services/tasks/add_task.dart';
import 'package:taskmanagement/services/tasks/task_vm.dart';

import '../base_client.dart';
import '../projects/project_model.dart';

class TaskClient extends BaseClient {
  Future<List<TaskVm>> tasksWithProjectId({
    String projectId = '',
    bool activeOnly = true,
  }) async {
    var tasks = <TaskVm>[];
    var path = 'Task/Tasks?projectId=$projectId&activeOnly=$activeOnly';

    var response = await get(path);
    List taskResponse = response.data;

    if (taskResponse.isNotEmpty) {
      for (var task in taskResponse) {
        tasks.add(TaskVm.fromJson(task));
      }
    }

    return tasks;
  }

  Future<List<TaskVm>> tasksWithDeveloperId({
    String developerId = '',
    bool activeOnly = true,
  }) async {
    var tasks = <TaskVm>[];
    var path = 'Task/Tasks?developerId=$developerId&activeOnly=$activeOnly';
    var response = await get(path);
    List taskResponse = response.data;

    if (taskResponse.isNotEmpty) {
      for (var task in taskResponse) {
        tasks.add(TaskVm.fromJson(task));
      }
    }

    return tasks;
  }

  Future<List<TaskNameVm>> taskNames() async {
    var tasks = <TaskNameVm>[];

    var response = await get('Task/TaskNames');
    List taskResponse = response.data;

    if (taskResponse.isNotEmpty) {
      for (var task in taskResponse) {
        tasks.add(TaskNameVm.fromJson(task));
      }
    }

    return tasks;
  }

  Future<OperationResult> addTask(TaskDto addTaskDto) async {
    var response = await post('Task/AddOrUpdateTask', addTaskDto.toJson());

    return OperationResult.fromJson(response.data);
  }

  Future<OperationResult> assignTask(AssignTaskDto assignTaskDto) async {
    var response = await post('Task/AssignTask', assignTaskDto.toJson());

    return OperationResult.fromJson(response.data);
  }
}
