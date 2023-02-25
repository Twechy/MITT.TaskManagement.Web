import '../base_client.dart';
import '../projects/project_model.dart';
import 'add_developer.dart';
import 'developer_vm.dart';

class DeveloperClient extends BaseClient {
  Future<List<Developer>> developers({bool activeOnly = true}) async {
    var projects = <Developer>[];
    var response = await get('Developer/Developers?activeOnly=$activeOnly');

    List developerResonse = response.data;

    if (developerResonse.isNotEmpty) {
      for (var developer in developerResonse) {
        projects.add(Developer.fromJson(developer));
      }
    }

    return projects;
  }

  Future<List<Developer>> developersByTask(String taskId) async {
    var projects = <Developer>[];
    var response = await get('Developer/DevelopersByTask?taskId=$taskId');

    List developerResonse = response.data;

    if (developerResonse.isNotEmpty) {
      for (var developer in developerResonse) {
        projects.add(Developer.fromJson(developer));
      }
    }

    return projects;
  }


  Future<OperationResult> addDevelopers(DeveloperDto addDeveloperDto) async {
    var response =
        await post('Developer/AddOrUpdateDeveloper', addDeveloperDto.toJson());

    return OperationResult.fromJson(response.data);
  }

  Future<OperationResult> changeDeveloperState(String developerId) async {
    var response = await post(
      'Developer/ChangeState',
      null,
      queryParameters: {"developerId": developerId},
    );

    return OperationResult.fromJson(response.data);
  }
}
