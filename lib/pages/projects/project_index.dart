import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taskmanagement/services/projects/project_model.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../services/projects/project_bloc.dart';
import 'add_project_dialog.dart';
import 'project_list_item.dart';

class ProjectIndex extends ConsumerStatefulWidget {
  const ProjectIndex({Key? key}) : super(key: key);

  @override
  ProjectListViewState createState() => ProjectListViewState();
}

class ProjectListViewState extends ConsumerState<ProjectIndex> {
  late ProjectBloc _projectBloc;
  final List<String> _projectTypes = const [
    'all',
    'Mobile',
    'Payment',
    'Web',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _projectBloc = ref.read(projectBlocProvider)..filterProjects(_projectTypes.first);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 15.0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: IconButton(
                          tooltip: 'add new project.',
                          icon: const Icon(
                            FontAwesomeIcons.buildingColumns,
                          ),
                          onPressed: () async {
                            await showDialog(
                                context: context,
                                useSafeArea: true,
                                builder: (BuildContext context) {
                                  return const SizedBox(
                                    width: 250,
                                    height: 350,
                                    child: AddOrUpdateProject(),
                                  );
                                });

                            await _projectBloc.projects();
                          },
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
                          labels: _projectTypes,
                          customTextStyles: const [
                            TextStyle(fontSize: 12),
                          ],
                          onToggle: (index) async {
                            setState(() async {
                              await _projectBloc
                                  .filterProjects(_projectTypes[index!]);
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder<List<Project>>(
                  stream: _projectBloc.projectsListView$,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Project>> snapshot) {
                    if (snapshot.hasData) {
                      var projects = snapshot.data ?? [];

                      return ListView.builder(
                        itemCount: projects.length,
                        scrollDirection: Axis.vertical,
                        padding: const EdgeInsets.all(8.0),
                        shrinkWrap: true,
                        itemBuilder: (context, index) =>
                            ProjectListItem(project: projects[index]),
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
