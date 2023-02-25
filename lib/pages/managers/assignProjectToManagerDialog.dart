import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../services/projects/project_bloc.dart';
import '../../services/projects/project_model.dart';

class AssignProjectToManagerDialog extends ConsumerStatefulWidget {
  final String managerId;

  const AssignProjectToManagerDialog({
    Key? key,
    required this.managerId,
  }) : super(key: key);

  @override
  AssignProjectToManagerDialogState createState() =>
      AssignProjectToManagerDialogState();
}

class AssignProjectToManagerDialogState
    extends ConsumerState<AssignProjectToManagerDialog> {
  late ProjectBloc _projectBloc;
  late String selectProjectName;
  late String selectedProjectId;

  @override
  void initState() {
    super.initState();
    _projectBloc = ref.read(projectBlocProvider)
      ..projectsToAssign(widget.managerId);
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
                  'assign project to manager...',
                  style: TextStyle(fontSize: 28.0),
                ),
              ),
            ),
            StreamBuilder<List<Project>>(
                stream: _projectBloc.projectsListView$,
                initialData: const [],
                builder: (context, AsyncSnapshot<List<Project>> snapshot) {
                  final items = snapshot.hasData ? snapshot.data! : <Project>[];
                  if (!snapshot.hasData || items.isEmpty) {
                    return const CircularProgressIndicator();
                  }

                  var names = items.map((e) => e.name).toList();

                  selectProjectName = names.first;

                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 5.0),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 5.0),
                    child: DropdownButton(
                      isExpanded: true,
                      value: selectProjectName,
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
                          selectProjectName = newValue!;
                          selectedProjectId = items
                              .firstWhere((element) => element.name == newValue)
                              .id;
                        });
                      },
                      hint: const Text(
                        'select project name.',
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
                  _projectBloc
                      .assignManager(
                    AssignManagerDto(
                      projectId: selectedProjectId,
                      managerIds: [
                        widget.managerId,
                      ],
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
