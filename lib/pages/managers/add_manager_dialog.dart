import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taskmanagement/services/projects/project_model.dart';

import '../../services/projects/project_bloc.dart';

class AddOrUpdateManager extends ConsumerStatefulWidget {
  const AddOrUpdateManager({
    Key? key,
  }) : super(key: key);

  @override
  AddOrUpdateManagerState createState() => AddOrUpdateManagerState();
}

class AddOrUpdateManagerState extends ConsumerState<AddOrUpdateManager> {
  late String _nickNameController;
  late String _nameController;
  late String _emailController;
  late String _phoneController;
  late ProjectBloc _projectBloc;

  @override
  void initState() {
    super.initState();
    _projectBloc = ref.read(projectBlocProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 460.0, vertical: 120.0),
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
                  'add new manager',
                  style: TextStyle(
                    fontSize: 28.0,
                  ),
                ),
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 45.0, vertical: 5.0),
              child: CupertinoTextField(
                padding: const EdgeInsets.all(8),
                prefix: const Icon(FontAwesomeIcons.diagramProject),
                placeholder: "nick name",
                style: const TextStyle(color: Colors.white),
                onChanged: (text) {
                  _nickNameController = text;
                },
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 45.0, vertical: 5.0),
              child: CupertinoTextField(
                padding: const EdgeInsets.all(8),
                prefix: const Icon(FontAwesomeIcons.diagramProject),
                placeholder: "name",
                style: const TextStyle(color: Colors.white),
                onChanged: (text) {
                  _nameController = text;
                },
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 45.0, vertical: 5.0),
              child: CupertinoTextField(
                padding: const EdgeInsets.all(8),
                prefix: const Icon(Icons.description),
                placeholder: "email",
                style: const TextStyle(color: Colors.white),
                onChanged: (text) {
                  _emailController = text;
                },
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 45.0, vertical: 5.0),
              child: CupertinoTextField(
                padding: const EdgeInsets.all(8),
                prefix: const Icon(FontAwesomeIcons.code),
                placeholder: "phone",
                style: const TextStyle(color: Colors.white),
                onChanged: (text) {
                  _phoneController = text;
                },
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              margin:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: MaterialButton(
                color: Theme.of(context).colorScheme.secondary,
                minWidth: 120.0,
                height: 60.0,
                child: const Text('add manager'),
                onPressed: () {
                  _projectBloc
                      .addManager(
                    Manager(
                      id: null,
                      fullName: _nameController,
                      nickName: _nickNameController,
                      email: _emailController,
                      phone: _phoneController,
                      activeState: 0,
                      activeTasks: 0,
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
