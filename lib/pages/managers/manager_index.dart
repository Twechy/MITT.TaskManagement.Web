import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taskmanagement/services/projects/project_model.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../services/projects/project_bloc.dart';
import '../../widgets/helpers.dart';
import '../tasks/task_list_vew.dart';
import 'add_manager_dialog.dart';
import 'assignProjectToManagerDialog.dart';

class ManagerIndex extends ConsumerStatefulWidget {
  const ManagerIndex({Key? key}) : super(key: key);

  @override
  ManagerListViewState createState() => ManagerListViewState();
}

class ManagerListViewState extends ConsumerState<ManagerIndex> {
  late ProjectBloc projectBLoc;
  late String _selectedProject;
  final List<String> _selectedProjectTypes = const [
    'All',
    'Mobile',
    'Payment',
    'Web',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _selectedProject = _selectedProjectTypes.first;
    projectBLoc = ref.read(projectBlocProvider)..managers(_selectedProject);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
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
                          onPressed: () async {
                            await showDialog(
                                context: context,
                                useSafeArea: true,
                                builder: (BuildContext context) {
                                  return const SizedBox(
                                    width: 250,
                                    height: 350,
                                    child: AddOrUpdateManager(),
                                  );
                                });

                            await projectBLoc.managers(_selectedProject);
                          },
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
                          minWidth: 100.0,
                          initialLabelIndex: 0,
                          totalSwitches: 5,
                          labels: _selectedProjectTypes,
                          customTextStyles: const [
                            TextStyle(fontSize: 12),
                          ],
                          onToggle: (index) async {
                            _selectedProject = _selectedProjectTypes[index!];
                            await projectBLoc.managers(_selectedProject);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder<List<Manager>>(
                  stream: projectBLoc.managerslListView$,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Manager>> snapshot) {
                    if (snapshot.hasData) {
                      var managers = snapshot.data ?? [];

                      return ListView.builder(
                        itemCount: managers.length,
                        scrollDirection: Axis.vertical,
                        padding: const EdgeInsets.all(6.0),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => ManagerListItem(
                          manager: managers[index],
                          selectedProject: _selectedProject,
                        ),
                      );
                    }

                    return const CircularProgressIndicator();
                  }),
            ],
          )
        ],
      ),
    );
  }
}

class ManagerListItem extends ConsumerStatefulWidget {
  final Manager manager;
  final String selectedProject;

  const ManagerListItem({
    Key? key,
    required this.manager,
    required this.selectedProject,
  }) : super(key: key);

  @override
  ManagerListItemState createState() => ManagerListItemState();
}

class ManagerListItemState extends ConsumerState<ManagerListItem> {
  late ProjectBloc projectBloc;

  @override
  void initState() {
    super.initState();
    projectBloc = ref.read(projectBlocProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              if (widget.manager.activeState >= 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TaskListView(),
                  ),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) => const Center(
                    child: Text(
                      'no assigned tasks yet!',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                );
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  flex: 1,
                  child: ProfilePicture(
                    name: widget.manager.fullName,
                    role: 'Project Manager',
                    radius: 18,
                    fontsize: 16,
                    tooltip: true,
                    count: 2,
                    random: false,
                  ),
                ),
                const SizedBox(
                  width: 15.0,
                  height: 35.0,
                  child: VerticalDivider(),
                ),
                Expanded(
                  flex: 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: 120.0,
                          child: textView(
                            widget.manager.fullName,
                            textFontSize: 18,
                          ),
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: labelView(
                              context,
                              ActiveTaskDisplay.h,
                              'phone: ',
                              widget.manager.phone,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: labelView(
                              context,
                              ActiveTaskDisplay.h,
                              'email: ',
                              widget.manager.email,
                            ),
                          ),
                        ],
                      ),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      IconButton(
                        tooltip: 'assign to project...',
                        onPressed: () async {
                          await showDialog(
                              context: context,
                              useSafeArea: true,
                              builder: (BuildContext context) {
                                return AssignProjectToManagerDialog(
                                  managerId: widget.manager.id!,
                                );
                              });
                        },
                        icon: const Icon(
                          FontAwesomeIcons.plus,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(
                        width: 15.0,
                        height: 35.0,
                        child: VerticalDivider(),
                      ),
                      IconButton(
                        onPressed: () async {
                          var response = await projectBloc
                              .changeManagerState(widget.manager.id!);

                          if (response.type == 2) {
                            await projectBloc.managers(widget.selectedProject);
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => const Center(
                                  child: Text('invalid operation!')),
                            );
                          }
                        },
                        icon: Icon(
                          widget.manager.activeState == 1
                              ? FontAwesomeIcons.pause
                              : FontAwesomeIcons.play,
                          color: widget.manager.activeState == 1
                              ? Colors.red
                              : Colors.green,
                        ),
                        tooltip: widget.manager.activeState == 1
                            ? 'deactivate manager state.'
                            : 'activate manager state.',
                      ),
                      const SizedBox(
                        width: 15.0,
                        height: 35.0,
                        child: VerticalDivider(),
                      ),
                      IconButton(
                        tooltip: 'update a manager.',
                        onPressed: () async {},
                        icon: const Icon(
                          FontAwesomeIcons.penToSquare,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: activeTasks(context, widget.manager.activeTasks),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
