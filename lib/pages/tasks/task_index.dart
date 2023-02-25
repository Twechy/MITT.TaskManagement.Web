import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taskmanagement/pages/tasks/task_detail.dart';
import 'package:taskmanagement/services/tasks/task_bloc.dart';
import 'package:taskmanagement/services/tasks/task_vm.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../widgets/badges.dart';
import '../../widgets/helpers.dart';
import '../../widgets/operation_snack.dart';

class TaskDetail extends ConsumerStatefulWidget {
  final String projectId;
  final String developerId;

  const TaskDetail({
    Key? key,
    this.projectId = '',
    this.developerId = '',
  }) : super(key: key);

  @override
  TaskListViewState createState() => TaskListViewState();
}

class TaskListViewState extends ConsumerState<TaskDetail> {
  late TaskBloc _taskBloc;

  @override
  void initState() {
    super.initState();
    if (widget.projectId != '' && widget.developerId == 'none') {
      _taskBloc = ref.read(taskBlocProvider)
        ..tasksWithProjectId(projectId: widget.projectId);
    } else {
      _taskBloc = ref.read(taskBlocProvider)
        ..tasksWithDeveloperId(developerId: widget.developerId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      key: widget.key,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 15.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              FontAwesomeIcons.buildingColumns,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Center(
                          child: ToggleSwitch(
                            minWidth: 80.0,
                            initialLabelIndex: 0,
                            totalSwitches: 3,
                            labels: const ['Open', 'Canceled', 'Completed'],
                            customTextStyles: const [
                              TextStyle(fontSize: 12),
                            ],
                            onToggle: (index) {},
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                StreamBuilder<List<TaskVm>>(
                    key: widget.key,
                    stream: _taskBloc.tasksListView$,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return buildSizedBox(context, snapshot.data ?? []);
                      } else if (snapshot.hasError) {
                        openSnackBar(
                          context,
                          title: 'error',
                          content: snapshot.error.toString(),
                          contentType: ContentType.failure,
                        );
                        return const CircularProgressIndicator();
                      } else {
                        return const CircularProgressIndicator();
                      }
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSizedBox(BuildContext context, List<TaskVm> tasks) {
    return ListView.builder(
      itemCount: tasks.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) => TaskListItem(
        key: widget.key,
        task: tasks[index],
      ),
    );
  }
}

class TaskListItem extends StatelessWidget {
  const TaskListItem({
    Key? key,
    required this.task,
  }) : super(key: key);

  final TaskVm task;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Theme.of(context).primaryColor,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskDetailPage(
                key: key,
                task: task,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                firstBuild(context),
                const Expanded(
                  child: VerticalDivider(color: Colors.white, width: 4.0),
                ),
                secondBuild(),
                const Expanded(
                  child: VerticalDivider(color: Colors.white, width: 4.0),
                ),
                thirdBuild(context),
                const Expanded(
                  child: VerticalDivider(color: Colors.white, width: 4.0),
                ),
                forthBuild(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Expanded firstBuild(BuildContext context) => Expanded(
        flex: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            labelView(
              context,
              ActiveTaskDisplay.h,
              'seqNo',
              task.seqNo,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 4.0),
            labelView(
              context,
              ActiveTaskDisplay.h,
              'name',
              task.assignedProjectName,
            ),
            const SizedBox(height: 2.0),
            ImplementationTypeBadge(
              implementationTypeBadgeType: task.implementationType,
            ),
          ],
        ),
      );

  Expanded secondBuild() => Expanded(
        flex: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            textView(task.name, textFontSize: 22),
            const SizedBox(height: 6),
            textView(task.description, textFontSize: 16),
          ],
        ),
      );

  Expanded thirdBuild(BuildContext context) => Expanded(
        flex: 3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                labelView(
                  context,
                  ActiveTaskDisplay.h,
                  'progress: ',
                  task.progress,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                labelView(
                  context,
                  ActiveTaskDisplay.h,
                  'start date',
                  task.startDate.toString().split(' ')[0],
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(width: 12),
                labelView(
                  context,
                  ActiveTaskDisplay.h,
                  'end date',
                  task.endDate.toString().split(' ')[0],
                  color: Theme.of(context).colorScheme.error,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                labelView(
                  context,
                  ActiveTaskDisplay.h,
                  'time left: ',
                  task.timeLeft,
                ),
              ],
            ),
          ],
        ),
      );

  Expanded forthBuild(BuildContext context) => Expanded(
        flex: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            task.assignedBeDevs.isNotEmpty
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      textView(
                        'b-e developers',
                        color: Theme.of(context).colorScheme.error,
                        textFontSize: 14,
                      ),
                      const SizedBox(width: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: task.assignedBeDevs
                            .map((e) => Padding(
                                  padding: const EdgeInsets.only(
                                    left: 4.0,
                                    right: 4.0,
                                  ),
                                  child: ProfilePicture(
                                    name: e.name,
                                    role: 'backend',
                                    radius: 16,
                                    fontsize: 13,
                                    tooltip: true,
                                    count: 2,
                                    random: false,
                                  ),
                                ))
                            .toList(),
                      )
                    ],
                  )
                : const SizedBox(child: Text('no be assigned!!')),
            const SizedBox(height: 6),
            task.assignedQaDevs.isNotEmpty
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      textView(
                        'q-a developers',
                        color: Theme.of(context).colorScheme.error,
                        textFontSize: 14,
                      ),
                      const SizedBox(width: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: task.assignedQaDevs
                            .map((e) => Padding(
                                  padding: const EdgeInsets.only(
                                    left: 4.0,
                                    right: 4.0,
                                  ),
                                  child: ProfilePicture(
                                    name: e.name,
                                    role: 'qa',
                                    radius: 16,
                                    fontsize: 13,
                                    tooltip: true,
                                    count: 2,
                                    random: false,
                                  ),
                                ))
                            .toList(),
                      )
                    ],
                  )
                : const SizedBox(child: Text('no qa assigned!!')),
          ],
        ),
      );
}
