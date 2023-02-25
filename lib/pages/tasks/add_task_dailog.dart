import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:super_tag_editor/tag_editor.dart';
import 'package:taskmanagement/services/projects/project_model.dart';
import 'package:taskmanagement/services/tasks/add_task.dart';

import '../../services/projects/project_bloc.dart';
import '../../services/tasks/task_bloc.dart';

class AddOrUpdateTask extends ConsumerStatefulWidget {
  final String projectId;
  final String projectName;

  const AddOrUpdateTask({
    Key? key,
    required this.projectId,
    required this.projectName,
  }) : super(key: key);

  @override
  AddOrUpdateTaskState createState() => AddOrUpdateTaskState();
}

class AddOrUpdateTaskState extends ConsumerState<AddOrUpdateTask> {
  late String _taskName;
  late String _description;
  final List<String> _requirement = [];
  late String _assignedManagerId;
  late String _implementationType;
  late String _startDate;
  late String _endDate;

  late TaskBloc _taskBloc;
  late ProjectBloc _projectBloc;

  late String selectedTaskType;
  Map<String, int> taskType = {'implementation': 1, 'refactoring': 2};

  late String selectedProjectType;
  Map<String, int> projectType = {'implementation': 1, 'refactoring': 2};

  String? selectedManagerName;

  @override
  void initState() {
    super.initState();
    _taskBloc = ref.read(taskBlocProvider);

    _projectBloc = ref.read(projectBlocProvider)
      ..managersByProject(widget.projectId);

    selectedTaskType = taskType.keys.first;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 360.0, vertical: 20.0),
      child: Dialog(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.white70, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        child: Column(
          children: [
            DrawerHeader(
              child: Center(
                child: Text(
                  'add new task to ${widget.projectName}.',
                  style: const TextStyle(
                    fontSize: 28.0,
                  ),
                ),
              ),
            ),
            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
              child: CupertinoTextField(
                padding: const EdgeInsets.all(8),
                prefix: const Icon(FontAwesomeIcons.diagramProject),
                placeholder: "name",
                style: const TextStyle(color: Colors.white),
                onChanged: (text) {
                  _taskName = text;
                },
              ),
            ),
            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
              child: CupertinoTextField(
                padding: const EdgeInsets.all(8),
                prefix: const Icon(FontAwesomeIcons.diagramProject),
                placeholder: "description",
                style: const TextStyle(color: Colors.white),
                onChanged: (text) {
                  _description = text;
                },
              ),
            ),
            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
              child: TagEditor(
                length: _requirement.length,
                delimiters: const [','],
                hasAddButton: true,
                backgroundColor: Theme.of(context).primaryColor,
                inputDecoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'add task requirements...',
                ),
                onTagChanged: (newValue) {
                  setState(() {
                    _requirement.add(newValue.trim());
                  });
                },
                tagBuilder: (context, index) => _Chip(
                  index: index,
                  label: _requirement[index],
                  onDeleted: (value) {
                    setState(() {
                      _requirement.removeAt(index);
                    });
                  },
                ),
                suggestionBuilder: (context, state, data) => ListTile(
                  key: ObjectKey(data),
                  title: Text(data),
                  onTap: () {
                    state.selectSuggestion(data);
                  },
                ),
                suggestionsBoxElevation: 10,
                findSuggestions: (String query) {
                  return [];
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder<ManagerByProjectVm>(
                    stream: _projectBloc.managersByProjectListView$,
                    builder:
                        (context, AsyncSnapshot<ManagerByProjectVm> snapshot) {
                      var list = snapshot.data?.assignedManagers ?? [];
                      if (!snapshot.hasData || list.isEmpty) {
                        return const CircularProgressIndicator();
                      }

                      var names = list.map((e) => e.nickName).toList();

                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 25.0,
                          vertical: 5.0,
                        ),
                        child: DropdownButton(
                          isExpanded: false,
                          value: selectedManagerName ?? names.first,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: names
                              .map(
                                (String items) => DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                ),
                              )
                              .toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedManagerName = newValue!;
                              _assignedManagerId = list
                                  .firstWhere(
                                      (element) => element.nickName == newValue)
                                  .id!;
                            });
                          },
                          hint: const Text(
                            'select a manager.',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 25.0,
                    vertical: 5.0,
                  ),
                  width: 220.0,
                  child: DropdownButton(
                    isExpanded: true,
                    value: selectedTaskType,
                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: taskType.keys.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedTaskType = newValue!;
                        _implementationType =
                            taskType[selectedTaskType].toString();
                      });
                    },
                    hint: const Text(
                      'select implementation type.',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime.now(),
                        maxTime: DateTime(2024, 1, 1), onChanged: (date) {
                      setState(() {
                        _startDate = date.toIso8601String();
                      });
                    }, onConfirm: (date) {
                      setState(() {
                        _startDate = date.toIso8601String();
                      });
                    }, currentTime: DateTime.now(), locale: LocaleType.ar);
                  },
                  child: const Text(
                    'show start date ',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime.now(),
                        maxTime: DateTime(2024, 1, 1), onChanged: (date) {
                      setState(() {
                        _endDate = date.toIso8601String();
                      });
                    }, onConfirm: (date) {
                      setState(() {
                        _endDate = date.toIso8601String();
                      });
                    }, currentTime: DateTime.now(), locale: LocaleType.ar);
                  },
                  child: const Text(
                    'show end date ',
                    style: TextStyle(color: Colors.blue),
                  ),
                )
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 10.0,
              ),
              child: MaterialButton(
                color: Theme.of(context).colorScheme.secondary,
                minWidth: 120.0,
                height: 60.0,
                child: const Text('add task'),
                onPressed: () {
                  _taskBloc
                      .addTask(
                    TaskDto(
                      id: null,
                      name: _taskName,
                      description: _description,
                      requirements: _requirement,
                      assignedManagerId: _assignedManagerId,
                      implementationType: int.parse(_implementationType),
                      startDate: DateTime.parse(_startDate),
                      endDate: DateTime.parse(_endDate),
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
            )
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.onDeleted,
    required this.index,
  });

  final String label;
  final ValueChanged<int> onDeleted;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Chip(
      labelPadding: const EdgeInsets.only(left: 8.0),
      label: Text(label),
      deleteIcon: const Icon(
        Icons.close,
        size: 18,
      ),
      onDeleted: () {
        onDeleted(index);
      },
    );
  }
}
