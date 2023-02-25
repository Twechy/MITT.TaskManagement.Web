import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taskmanagement/services/tasks/add_task.dart';
import 'package:taskmanagement/services/tasks/task_vm.dart';

import '../../services/tasks/task_bloc.dart';

class AssignTaskToDevDialog extends ConsumerStatefulWidget {
  final String developerId;
  final int developerType;

  const AssignTaskToDevDialog({
    Key? key,
    required this.developerId,
    required this.developerType,
  }) : super(key: key);

  @override
  AssignTaskToDevDialogState createState() => AssignTaskToDevDialogState();
}

class AssignTaskToDevDialogState extends ConsumerState<AssignTaskToDevDialog> {
  late TaskBloc _taskBloc;
  late String selectTaskName;
  late String selectedTaskId;

  @override
  void initState() {
    super.initState();
    _taskBloc = ref.read(taskBlocProvider)..taskNames();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 400.0, vertical: 120.0),
      child: Dialog(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.white70, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        child: Column(
          children: [
            const DrawerHeader(
              child: Center(
                child: Text(
                  'assign new task...',
                  style: TextStyle(fontSize: 28.0),
                ),
              ),
            ),
            StreamBuilder<List<TaskNameVm>>(
                stream: _taskBloc.taskNamesListView$,
                initialData: const [],
                builder: (context, AsyncSnapshot<List<TaskNameVm>> snapshot) {
                  final items =
                      snapshot.hasData ? snapshot.data! : <TaskNameVm>[];
                  if (!snapshot.hasData || items.isEmpty) {
                    return const CircularProgressIndicator();
                  }

                  var names = items.map((e) => e.name).toList();

                  selectTaskName = names.first;

                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 5.0),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 5.0),
                    child: DropdownButton(
                      isExpanded: true,
                      value: selectTaskName,
                      // Down Arrow Icon
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: names.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectTaskName = newValue!;
                          selectedTaskId = items
                              .firstWhere((element) => element.name == newValue)
                              .id;
                        });
                      },
                      hint: const Text(
                        'select project type.',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }),
            const SizedBox(height: 10.0),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              margin:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: MaterialButton(
                color: Theme.of(context).colorScheme.secondary,
                minWidth: 120.0,
                height: 60.0,
                child: const Text('assign task'),
                onPressed: () {
                  _taskBloc
                      .assignTask(
                    AssignTaskDto(
                      assignDevType: widget.developerType,
                      taskId: selectedTaskId,
                      developerIds: [widget.developerId],
                    ),
                  )
                      .then((response) {
                    if (response.type == 2) {
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            const Center(child: Text('invalid operation!')),
                      );
                    }
                  });
                },
              ),
            ),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
