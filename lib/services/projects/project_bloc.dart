import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taskmanagement/services/projects/add_project.dart';
import 'package:taskmanagement/services/projects/project_client.dart';
import 'package:rxdart/rxdart.dart';
import 'package:taskmanagement/services/projects/project_model.dart';

final projectBlocProvider = Provider.autoDispose<ProjectBloc>((ref) {
  ref.maintainState = true;
  var tartelBloc = ProjectBloc();

  return tartelBloc;
});

class ProjectBloc {
  final ProjectClient _projectClient = ProjectClient();
  final CompositeSubscription _subscription = CompositeSubscription();

  Future projects() async {
    try {
      final subscription =
          Stream.fromFuture(_projectClient.projects()).listen((event) {
        _projectListView.add(event);
      });
      _subscription.add(subscription);
    } catch (e) {
      _projectListView.addError(e);
    }
  }

  Future filterProjects(String projectType) async {
    try {
      var type = getProjectType(projectType);
      final subscription =
          Stream.fromFuture(_projectClient.projects()).listen((event) {
        final list = <Project>[];
        for (final project in event) {
          if (type == null) list.add(project);
          if (type == project.projectType) list.add(project);
        }

        _projectListView.add(list);
      });
      _subscription.add(subscription);
    } catch (e) {
      _projectListView.addError(e);
    }
  }

  ProjectType? getProjectType(String projectType) {
    switch (projectType) {
      case 'Mobile':
        return ProjectType.mobile;
      case 'Payment':
        return ProjectType.payment;
      case 'Web':
        return ProjectType.web;
      case 'Other':
        return ProjectType.other;

      default:
        return null;
    }
  }

  Future projectsToAssign(String managerId) async {
    try {
      final subscription =
          Stream.fromFuture(_projectClient.projectsToAssign(managerId))
              .listen((event) {
        _projectListView.add(event);
      });
      _subscription.add(subscription);
    } catch (e) {
      _projectListView.addError(e);
    }
  }

  Future<OperationResult> addProject(AddProjectDto addProjectDto) async {
    try {
      return await _projectClient.addProject(addProjectDto);
    } catch (e) {
      return OperationResult(
        type: 2,
        messages: [e.toString()],
        traceId: '',
      );
    }
  }

  Future managers(String projectType) async {
    try {
      final subscription =
          Stream.fromFuture(_projectClient.manager(projectType)).listen((event) {
        _managersListView.add(event);
      });
      _subscription.add(subscription);
    } catch (e) {
      _managersListView.addError(e);
    }
  }

  Future managersByProject(String projectId) async {
    try {
      final subscription =
          Stream.fromFuture(_projectClient.managersByProject(projectId))
              .listen((event) {
        _managersByProjectListView.add(event);
      });
      _subscription.add(subscription);
    } catch (e) {
      _managersByProjectListView.addError(e);
    }
  }

  Future<OperationResult> addManager(Manager managerDto) async {
    try {
      return await _projectClient.addManager(managerDto);
    } catch (e) {
      return OperationResult(
        type: 2,
        messages: [],
        traceId: '',
      );
    }
  }

  Future<OperationResult> assignManager(
      AssignManagerDto assignManagerDto) async {
    try {
      return await _projectClient.assignManagerToProject(assignManagerDto);
    } catch (e) {
      return OperationResult(
        type: 2,
        messages: [],
        traceId: '',
      );
    }
  }

  Future<OperationResult> changeManagerState(String managerId) async {
    try {
      return await _projectClient.changeManagerState(managerId);
    } catch (e) {
      return OperationResult(
        type: 2,
        messages: [],
        traceId: '',
      );
    }
  }

  final _projectSelectedFilter =
      BehaviorSubject<ProjectType>.seeded(ProjectType.none);

  Stream<ProjectType> get selectedProjectFilter =>
      _projectSelectedFilter.stream;

  final _projectListView = BehaviorSubject<List<Project>>.seeded([]);

  Stream<List<Project>> get projectsListView$ => _projectListView.stream;

  final _managersListView = BehaviorSubject<List<Manager>>.seeded([]);

  Stream<List<Manager>> get managerslListView$ => _managersListView.stream;

  final _managersByProjectListView = BehaviorSubject<ManagerByProjectVm>();

  Stream<ManagerByProjectVm> get managersByProjectListView$ =>
      _managersByProjectListView.stream;
}
