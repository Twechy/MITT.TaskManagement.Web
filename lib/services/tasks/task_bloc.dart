import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:taskmanagement/services/projects/project_model.dart';
import 'package:taskmanagement/services/tasks/add_task.dart';
import 'package:taskmanagement/services/tasks/task_client.dart';
import 'package:taskmanagement/services/tasks/task_vm.dart';

final taskBlocProvider = Provider.autoDispose<TaskBloc>((ref) {
  ref.maintainState = false;
  return TaskBloc();
});

class TaskBloc {
  final TaskClient _taskClient = TaskClient();
  final CompositeSubscription _subscription = CompositeSubscription();

  Future tasksWithProjectId({String projectId = ''}) async {
    try {
      final subscription = Stream.fromFuture(
              _taskClient.tasksWithProjectId(projectId: projectId))
          .listen((event) {
        _taskListView.add(event);
      });
      _subscription.add(subscription);
    } catch (e) {
      _taskListView.addError(e);
    }
  }

  Future tasksWithDeveloperId({String developerId = ''}) async {
    try {
      _subscription.add(Stream.fromFuture(
              _taskClient.tasksWithDeveloperId(developerId: developerId))
          .listen((event) {
        _taskListView.add(event);
      }));
    } catch (e) {
      _taskListView.addError(e);
    }
  }

  Future taskNames() async {
    try {
      _subscription
          .add(Stream.fromFuture(_taskClient.taskNames()).listen((event) {
        _taskNamesListView.add(event);
      }));
    } catch (e) {
      _taskNamesListView.addError(e);
    }
  }

  Future<OperationResult> addTask(TaskDto addTaskDto) async {
    try {
      return await _taskClient.addTask(addTaskDto);
    } catch (e) {
      return OperationResult(type: 2, messages: [], traceId: '');
    }
  }

  Future<OperationResult> assignTask(AssignTaskDto assignTaskDto) async {
    try {
      return await _taskClient.assignTask(assignTaskDto);
    } catch (e) {
      return OperationResult(type: 2, messages: [], traceId: '');
    }
  }

  final _taskListView = BehaviorSubject<List<TaskVm>>.seeded([]);

  Stream<List<TaskVm>> get tasksListView$ => _taskListView.stream;

  final _taskNamesListView = BehaviorSubject<List<TaskNameVm>>.seeded([]);

  Stream<List<TaskNameVm>> get taskNamesListView$ => _taskNamesListView.stream;
}
