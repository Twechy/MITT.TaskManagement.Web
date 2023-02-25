import 'package:taskmanagement/services/base_client.dart';
import 'package:taskmanagement/services/projects/add_project.dart';
import 'package:taskmanagement/services/projects/project_model.dart';

class ProjectClient extends BaseClient {
  Future<List<Project>> projects({bool haveTasksOnly = true}) async {
    var projects = <Project>[];
    var response = await get('Projects/Projects?haveTasksOnly=$haveTasksOnly');

    List projectResonse = response.data;

    if (projectResonse.isNotEmpty) {
      for (var project in projectResonse) {
        projects.add(Project.fromJson(project));
      }
    }

    return projects;
  }

  Future<OperationResult> addProject(AddProjectDto addProjectDto) async {
    var response =
        await post('Projects/AddOrUpdateProject', addProjectDto.toJson());

    return OperationResult.fromJson(response.data);
  }

  Future<List<Manager>> manager(String projectType) async {
    var projects = <Manager>[];
    int type = _convertProjectType(projectType);
    var response = await get('Projects/Managers?projectType=$type');

    List developerResponse = response.data;

    if (developerResponse.isNotEmpty) {
      for (var developer in developerResponse) {
        projects.add(Manager.fromJson(developer));
      }
    }

    return projects;
  }

  Future<OperationResult> addManager(Manager managerDto) async {
    var response =
        await post('Projects/AddOrUpdateManager', managerDto.toJson());

    return OperationResult.fromJson(response.data);
  }

  Future<ManagerByProjectVm> managersByProject(String projectId) async {
    var response = await get('Projects/ManagersByProject?projectId=$projectId');

    return ManagerByProjectVm.fromJson(response.data);
  }

  Future<OperationResult> assignManagerToProject(
      AssignManagerDto assignManagerDto) async {
    var response = await post(
        'Projects/AssignManagersToProject', assignManagerDto.toJson());

    return OperationResult.fromJson(response.data);
  }

  Future<OperationResult> changeManagerState(String managerId) async {
    var response = await post(
      'Projects/ChangeState',
      null,
      queryParameters: {'managerId': managerId},
    );

    return OperationResult.fromJson(response.data);
  }

  Future<List<Project>> projectsToAssign(String managerId) async {
    var projects = <Project>[];
    var response = await get('Projects/ProjectsToAssign?managerId=$managerId');

    List projectResponse = response.data;

    if (projectResponse.isNotEmpty) {
      for (var project in projectResponse) {
        projects.add(Project.fromJson(project));
      }
    }

    return projects;
  }

  int _convertProjectType(String projectType) {
    switch (projectType) {
      case 'Mobile':
        return 1;
      case 'Payment':
        return 2;
      case 'Web':
        return 3;
      case 'Other':
        return 4;
      case 'All':
        return 5;

      default:
        return 5;
    }
  }
}
