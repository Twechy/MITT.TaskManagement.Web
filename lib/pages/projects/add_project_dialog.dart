import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taskmanagement/services/projects/add_project.dart';

import '../../services/projects/project_bloc.dart';

class AddOrUpdateProject extends ConsumerStatefulWidget {
  const AddOrUpdateProject({
    Key? key,
  }) : super(key: key);

  @override
  AddOrUpdateProjectState createState() => AddOrUpdateProjectState();
}

class AddOrUpdateProjectState extends ConsumerState<AddOrUpdateProject> {
  late ProjectBloc _projectBloc;

  late String _projectName;
  late String _projectDescription;
  late String _projectType;
  late String dropdownvalue;

  Map<String, int> items = {
    'Mobile': 0,
    'Payment': 1,
    'Web': 2,
    'Other': 3,
  };

  @override
  void initState() {
    super.initState();
    _projectBloc = ref.read(projectBlocProvider);

    dropdownvalue = items.keys.first;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 380.0, vertical: 120.0),
      child: Dialog(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.white70, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const DrawerHeader(
                child: Center(
                  child: Text(
                    'add new project.',
                    style: TextStyle(
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
                  placeholder: "project name",
                  style: const TextStyle(color: Colors.white),
                  onChanged: (text) {
                    _projectName = text;
                  },
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
                child: CupertinoTextField(
                  padding: const EdgeInsets.all(8),
                  prefix: const Icon(Icons.description),
                  placeholder: "project description",
                  style: const TextStyle(color: Colors.white),
                  onChanged: (text) {
                    _projectDescription = text;
                  },
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                margin:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
                child: DropdownButton(
                  isExpanded: true,
                  value: dropdownvalue,
                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: items.keys.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownvalue = newValue!;
                      _projectType = items[dropdownvalue].toString();
                    });
                  },
                  hint: const Text(
                    'select project type.',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
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
                  child: const Text('add project'),
                  onPressed: () {
                    _projectBloc
                        .addProject(
                      AddProjectDto(
                        id: null,
                        name: _projectName,
                        description: _projectDescription,
                        projectType: int.parse(_projectType),
                      ),
                    )
                        .then((response) {
                      if (response.type == 1) {
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
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
      ),
    );
  }
}
