import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taskmanagement/services/developers/add_developer.dart';
import 'package:taskmanagement/services/developers/developer_client.dart';
import 'package:taskmanagement/services/developers/developer_vm.dart';
import 'package:rxdart/rxdart.dart';
import 'package:taskmanagement/services/projects/project_model.dart';

final developerBlocProvider = Provider.autoDispose<DeveloperBloc>((ref) {
  ref.maintainState = true;
  return DeveloperBloc();
});

class DeveloperBloc {
  final DeveloperClient _developerClient = DeveloperClient();
  final CompositeSubscription _subscription = CompositeSubscription();

  Future developers() async {
    try {
      final subscription =
          Stream.fromFuture(_developerClient.developers()).listen((event) {
        _developerListView.add(event);
      });
      _subscription.add(subscription);
    } catch (e) {
      _developerListView.addError(e);
    }
  }

  Future filterDevelopers(String? developerType) async {
    try {
      var type = getDeveloperType(developerType);

      final subscription =
          Stream.fromFuture(_developerClient.developers()).listen((event) {
        final list = <Developer>[];
        for (final developer in event) {
          if (type == null) list.add(developer);
          if (type == developer.type) list.add(developer);
        }

        _developerListView.add(list);
      });
      _subscription.add(subscription);
    } catch (e) {
      _developerListView.addError(e);
    }
  }

  int? getDeveloperType(String? projectType) {
    switch (projectType) {
      case 'backend':
        return 1;
      case 'qa':
        return 2;
      case 'reviewers':
        return 4;

      case null:
        return null;

      default:
        return null;
    }
  }

  Future developersByTask(String taskId) async {
    try {
      final subscription =
          Stream.fromFuture(_developerClient.developersByTask(taskId))
              .listen((event) {
        _developersByTaskListView.add(event);
      });
      _subscription.add(subscription);
    } catch (e) {
      _developersByTaskListView.addError(e);
    }
  }

  Future<OperationResult> addDeveloper(DeveloperDto developerDto) async {
    try {
      return await _developerClient.addDevelopers(developerDto);
    } catch (e) {
      return OperationResult(
        type: 2,
        messages: [],
        traceId: '',
      );
    }
  }

  Future<OperationResult> changeDeveloperState(String developerId) async {
    try {
      return await _developerClient.changeDeveloperState(developerId);
    } catch (e) {
      return OperationResult(
        type: 2,
        messages: [],
        traceId: '',
      );
    }
  }

  final _developerListView = BehaviorSubject<List<Developer>>.seeded([]);

  Stream<List<Developer>> get developersListView$ => _developerListView.stream;

  final _developersByTaskListView = BehaviorSubject<List<Developer>>.seeded([]);

  Stream<List<Developer>> get developersByTaskListView$ =>
      _developersByTaskListView.stream;
}
