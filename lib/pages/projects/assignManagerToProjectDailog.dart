import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taskmanagement/services/projects/project_model.dart';
import 'package:chips_choice/chips_choice.dart';
import '../../services/projects/project_bloc.dart';

class AssignManagerToProjectDialog extends ConsumerStatefulWidget {
  final String projectId;
  final String projectName;

  const AssignManagerToProjectDialog({
    Key? key,
    required this.projectId,
    required this.projectName,
  }) : super(key: key);

  @override
  AssignManagerToProjectDialogState createState() =>
      AssignManagerToProjectDialogState();
}

class AssignManagerToProjectDialogState
    extends ConsumerState<AssignManagerToProjectDialog> {
  late ProjectBloc _projectBloc;
  late Manager? selectedAssignedManager;

  List<String> selectedFreeManagers = [];

  @override
  void initState() {
    super.initState();
    _projectBloc = ref.read(projectBlocProvider)
      ..managersByProject(widget.projectId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 165.0, vertical: 20.0),
      child: Dialog(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.white70, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        child: StreamBuilder<ManagerByProjectVm>(
            stream: _projectBloc.managersByProjectListView$,
            builder: (context, snapshot) {
              var items = snapshot.hasData ? snapshot.data : null;

              if (items == null) return const CircularProgressIndicator();

              selectedAssignedManager = items.assignedManagers.isNotEmpty
                  ? items.assignedManagers.first
                  : null;

              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                margin:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: DrawerHeader(
                        child: Center(
                          child: Text(
                            'assign managers to ${widget.projectName}.',
                            style: const TextStyle(
                              fontSize: 28.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    const Text('free managers'),
                    const SizedBox(height: 10.0),
                    items.freeManagers.isNotEmpty
                        ? Expanded(
                            child: ChipsChoice<String>.multiple(
                              value: selectedFreeManagers,
                              onChanged: (val) =>
                                  setState(() => selectedFreeManagers = val),
                              choiceItems: C2Choice.listFrom<String, Manager>(
                                source: items.freeManagers,
                                value: (i, v) => v.id!,
                                label: (i, v) => v.fullName,
                              ),
                              placeholder:
                                  'all the available managers is assigned!',
                            ),
                          )
                        : const Expanded(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Text(
                                  'all the available managers is assigned!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 35.0,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(height: 5.0),
                    const Text('assigned managers'),
                    const SizedBox(height: 5.0),
                    items.assignedManagers.isNotEmpty
                        ? Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: ListView.builder(
                                  itemCount: items.assignedManagers.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 35.0),
                                      child: ListTile(
                                        leading: Text(
                                          'active tasks ${items.assignedManagers[index].activeTasks}',
                                          textAlign: TextAlign.center,
                                          style:
                                              const TextStyle(fontSize: 16.0),
                                        ),
                                        title: Text(
                                          items
                                              .assignedManagers[index].fullName,
                                          textAlign: TextAlign.center,
                                          style:
                                              const TextStyle(fontSize: 16.0),
                                        ),
                                        trailing: const Icon(
                                          FontAwesomeIcons.pause,
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          )
                        : const Expanded(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Text(
                                  'no managers assigned yet!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 35.0,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(height: 25.0),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: MaterialButton(
                        color: Theme.of(context).colorScheme.secondary,
                        minWidth: 120.0,
                        height: 60.0,
                        child: const Text(
                          'assign',
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          if (selectedFreeManagers.isNotEmpty) {
                            _projectBloc
                                .assignManager(
                              AssignManagerDto(
                                  projectId: widget.projectId,
                                  managerIds: selectedFreeManagers),
                            )
                                .then((response) {
                              if (response.type == 2) {
                                Navigator.of(context, rootNavigator: true)
                                    .pop('dialog');
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => const Center(
                                      child: Text('invalid operation!')),
                                );
                              }
                            });
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => const Center(
                                  child:
                                      Text('select managers to processed!!')),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 25.0),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
