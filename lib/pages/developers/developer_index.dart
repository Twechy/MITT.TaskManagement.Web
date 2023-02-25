import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taskmanagement/widgets/helpers.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../services/developers/developer_bloc.dart';
import '../../services/developers/developer_vm.dart';
import '../../widgets/badges.dart';
import '../tasks/task_list_vew.dart';
import 'add_developer_dialog.dart';
import 'assignTaskToDeveloperDialog.dart';

class DeveloperIndex extends ConsumerStatefulWidget {
  const DeveloperIndex({Key? key}) : super(key: key);

  @override
  DeveloperListViewState createState() => DeveloperListViewState();
}

class DeveloperListViewState extends ConsumerState<DeveloperIndex> {
  late DeveloperBloc _developerBloc;
  final List<String> _developerTypes = const [
    'all',
    'backend',
    'qa',
    'reviewers',
  ];

  late String _developerType;

  @override
  void initState() {
    super.initState();
    _developerType = _developerTypes.first;
    _developerBloc = ref.read(developerBlocProvider)
      ..filterDevelopers(_developerType);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _developerBloc = ref.read(developerBlocProvider)
      ..filterDevelopers(_developerType);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(children: [
        Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
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
                                  child: AddOrUpdateDeveloper(),
                                );
                              });

                          await _developerBloc.developers();
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
                        minWidth: 80.0,
                        initialLabelIndex: 0,
                        totalSwitches: 4,
                        labels: _developerTypes,
                        customTextStyles: const [
                          TextStyle(fontSize: 12),
                        ],
                        onToggle: (index) async {
                          _developerType = _developerTypes[index!];
                          await _developerBloc.filterDevelopers(_developerType);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder<List<Developer>>(
                stream: _developerBloc.developersListView$,
                builder: (context, AsyncSnapshot<List<Developer>> snapshot) {
                  if (snapshot.hasData) {
                    var developers = snapshot.data ?? [];

                    return ListView.builder(
                      itemCount: developers.length,
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.all(6.0),
                      shrinkWrap: true,
                      itemBuilder: (context, index) => DeveloperListItem(
                        developer: developers[index],
                        filterType: _developerType,
                      ),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                }),
          ],
        )
      ]),
    );
  }
}

class DeveloperListItem extends ConsumerStatefulWidget {
  const DeveloperListItem({
    Key? key,
    required this.developer,
    required this.filterType,
  }) : super(key: key);

  final Developer developer;
  final String filterType;

  @override
  DeveloperListItemState createState() => DeveloperListItemState();
}

class DeveloperListItemState extends ConsumerState<DeveloperListItem> {
  late DeveloperBloc _developerBloc;

  @override
  void initState() {
    super.initState();
    _developerBloc = ref.read(developerBlocProvider)..developers();
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
              if (widget.developer.tasks.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskListView(
                      developerId: widget.developer.id,
                      projectId: 'devId',
                    ),
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
              children: [
                Expanded(
                  flex: 1,
                  child: DeveloperTypeBadge(
                    developerType: widget.developer.type,
                    iconSize: 18,
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
                            widget.developer.fullName,
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
                              widget.developer.phone,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: labelView(
                              context,
                              ActiveTaskDisplay.h,
                              'email: ',
                              widget.developer.email,
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
                        tooltip: 'assign new task...',
                        onPressed: () async {
                          if (widget.developer.type == 1 ||
                              widget.developer.type == 2) {
                            await showDialog(
                                context: context,
                                useSafeArea: true,
                                builder: (BuildContext context) {
                                  return AssignTaskToDevDialog(
                                    developerId: widget.developer.id,
                                    developerType: widget.developer.type,
                                  );
                                });
                          } else {
                            await showDialog(
                                context: context,
                                useSafeArea: true,
                                builder: (BuildContext context) {
                                  return const Center(
                                    child: Text(
                                        'only be and qa can e assign tasks to!'),
                                  );
                                });
                          }
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
                          var response = await _developerBloc
                              .changeDeveloperState(widget.developer.id);

                          if (response.type == 2) {
                            await _developerBloc
                                .filterDevelopers(widget.filterType);
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => const Center(
                                  child: Text('invalid operation!')),
                            );
                          }

                          setState(() {});
                        },
                        icon: Icon(
                          widget.developer.activeState == 1
                              ? FontAwesomeIcons.pause
                              : FontAwesomeIcons.play,
                          color: widget.developer.activeState == 1
                              ? Colors.red
                              : Colors.green,
                        ),
                        tooltip: widget.developer.activeState == 1
                            ? 'deactivate developer state.'
                            : 'activate developer state.',
                      ),
                      const SizedBox(
                        width: 15.0,
                        height: 35.0,
                        child: VerticalDivider(),
                      ),
                      IconButton(
                        tooltip: 'update a developer.',
                        onPressed: () async {},
                        icon: const Icon(
                          FontAwesomeIcons.penToSquare,
                          color: Colors.blueGrey,
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 4.0,
                      right: 4.0,
                    ),
                    child: activeTasks(context, widget.developer.tasks.length),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
