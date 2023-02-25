import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:taskmanagement/services/tasks/task_vm.dart';

final taskManagementBlocProvider =
    Provider.autoDispose<TaskManagementBloc>((ref) => TaskManagementBloc());

class TaskManagementBloc {
  void setTaskInstance(TaskVm task) {
    _taskView.add(task);

    _beDevelopers.add(task.assignedBeDevs);
    _qaDevelopers.add(task.assignedQaDevs);
    if (task.assignedBeDevs.length == 1) selectDeveloper(task.assignedBeDevs.first);
    if (task.assignedQaDevs.length == 1) selectDeveloper(task.assignedQaDevs.first);
  }

  void selectDeveloper(AssignedDev assignedDev) {
    _selectedDeveloper.add(assignedDev);

    if (assignedDev.reviews.isEmpty) {
      _selectedReviews.add([]);
      _selectedFindings.add([]);
    }
    if (assignedDev.reviews.isNotEmpty) {
      _selectedReviews.add(assignedDev.reviews);
      if (assignedDev.reviews.length == 1) {
        selectReview(assignedDev.reviews.first);
      }
    }
  }

  void selectReview(Review review) {
    _selectedReview.add(review);
    if (review.findings.isNotEmpty) {
      _selectedFindings.add(review.findings);
    }
  }

  final _beDevelopers = BehaviorSubject<List<AssignedDev>>();

  Stream<List<AssignedDev>> get beDevelopers$ => _beDevelopers.stream;

  final _qaDevelopers = BehaviorSubject<List<AssignedDev>>();

  Stream<List<AssignedDev>> get qaDevelopers$ => _qaDevelopers.stream;

  final _selectedDeveloper = BehaviorSubject<AssignedDev>();

  Stream<AssignedDev> get selectedDeveloper$ => _selectedDeveloper.stream;

  final _selectedReviews = BehaviorSubject<List<Review>>.seeded([]);

  Stream<List<Review>> get selectedReviews$ => _selectedReviews.stream;

  final _selectedReview = BehaviorSubject<Review>();

  Stream<Review> get selectedReview$ => _selectedReview.stream;

  final _selectedFindings = BehaviorSubject<List<Finding>>();

  Stream<List<Finding>> get selectedFindings$ => _selectedFindings.stream;

  final _taskView = BehaviorSubject<TaskVm>();

  Stream<TaskVm> get taskView$ => _taskView.stream;
}
