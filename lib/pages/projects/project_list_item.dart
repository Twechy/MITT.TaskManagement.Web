import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taskmanagement/services/projects/project_bloc.dart';
import 'package:taskmanagement/services/projects/project_model.dart';

import '../../widgets/badges.dart';
import '../../widgets/helpers.dart';
import '../tasks/add_task_dailog.dart';
import '../tasks/task_list_vew.dart';
import 'assignManagerToProjectDailog.dart';

class ProjectListItem extends ConsumerStatefulWidget {
  const ProjectListItem({
    Key? key,
    required this.project,
  }) : super(key: key);

  final Project project;

  @override
  ProjectListItemState createState() => ProjectListItemState();
}

class ProjectListItemState extends ConsumerState<ProjectListItem> {
  late ProjectBloc _projectBloc;

  @override
  void initState() {
    super.initState();
    _projectBloc = ref.read(projectBlocProvider)..projects();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: InkWell(
          onTap: () {
            List<Manager> haveTasks = widget.project.managers
                .where((element) => element.activeTasks >= 1)
                .toList();

            if (haveTasks.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskListView(
                    projectId: widget.project.id,
                    developerId: 'none',
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 6.0,
                      right: 6.0,
                    ),
                    child: ProjectTypeBadge(
                      projectType: widget.project.projectType,
                      iconSize: 22,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15.0,
                  height: 35.0,
                  child: VerticalDivider(),
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      textView(widget.project.name, textFontSize: 18),
                      const SizedBox(height: 10),
                      textView(widget.project.description, textFontSize: 12),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        tooltip: 'new task.',
                        onPressed: () async {
                          if (widget.project.managers.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (context) => Center(
                                child: Card(
                                  child: Container(
                                    margin: const EdgeInsets.all(25.0),
                                    child: const Text(
                                      'please assign managers first!',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            await showDialog(
                                context: context,
                                useSafeArea: true,
                                builder: (BuildContext context) {
                                  return AddOrUpdateTask(
                                    projectId: widget.project.id,
                                    projectName: widget.project.name,
                                  );
                                });

                            await _projectBloc.projects();
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
                        tooltip: 'assign a managers.',
                        onPressed: () async {
                          await showDialog(
                              context: context,
                              useSafeArea: true,
                              builder: (BuildContext context) {
                                return SizedBox(
                                  width: 250,
                                  height: 350,
                                  child: AssignManagerToProjectDialog(
                                    projectId: widget.project.id,
                                    projectName: widget.project.name,
                                  ),
                                );
                              });

                          await _projectBloc.projects();
                        },
                        icon: const Icon(
                          FontAwesomeIcons.personCirclePlus,
                          color: Colors.brown,
                        ),
                      ),
                      const SizedBox(
                        width: 15.0,
                        height: 35.0,
                        child: VerticalDivider(),
                      ),
                      IconButton(
                        tooltip: 'update a project.',
                        onPressed: () async {},
                        icon: const Icon(
                          FontAwesomeIcons.penToSquare,
                          color: Colors.blueGrey,
                        ),
                      ),
                      const SizedBox(
                        width: 15.0,
                        height: 35.0,
                        child: VerticalDivider(),
                      ),
                      SizedBox(
                        child: widget.project.managers.isNotEmpty
                            ? Row(
                                mainAxisSize: MainAxisSize.max,
                                children: widget.project.managers
                                    .map((e) => Padding(
                                          padding: const EdgeInsets.only(
                                            left: 4.0,
                                            right: 4.0,
                                          ),
                                          child: ProfilePicture(
                                              name: e.fullName,
                                              role: 'Project Manager',
                                              radius: 14,
                                              fontsize: 12,
                                              tooltip: true,
                                              count: 2,
                                              random: false),
                                        ))
                                    .toList(),
                              )
                            : const Center(
                                child: Text(
                                'no managers!',
                                overflow: TextOverflow.fade,
                              )),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 4.0,
                      right: 4.0,
                    ),
                    child: activeTasks(
                      context,
                      widget.project.managers.isNotEmpty
                          ? widget.project.managers
                              .map((e) => e.activeTasks)
                              .reduce((value, element) => value + element)
                          : 0,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
