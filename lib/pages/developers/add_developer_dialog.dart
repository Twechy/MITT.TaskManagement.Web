import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taskmanagement/services/developers/add_developer.dart';

import '../../services/developers/developer_bloc.dart';

class AddOrUpdateDeveloper extends ConsumerStatefulWidget {
  const AddOrUpdateDeveloper({Key? key}) : super(key: key);

  @override
  AddOrUpdateDeveloperState createState() => AddOrUpdateDeveloperState();
}

class AddOrUpdateDeveloperState extends ConsumerState<AddOrUpdateDeveloper> {
  late DeveloperBloc _developerBloc;

  late String _nickNameController;
  late String _nameController;
  late String _developerTypeController;
  late String _emailController;
  late String _phoneController;
  late String selectedDeveloperValue;

  Map<String, int> developerType = {
    'back end': 1,
    'quality assurance': 2,
    'project manager': 3,
    'code reviewer': 4,
  };

  @override
  void initState() {
    super.initState();
    _developerBloc = ref.read(developerBlocProvider);
    selectedDeveloperValue = developerType.keys.first;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 460.0, vertical: 80.0),
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
                  'add new developer',
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
                  const EdgeInsets.symmetric(horizontal: 45.0, vertical: 5.0),
              child: DropdownButton(
                isExpanded: true,
                value: selectedDeveloperValue,
                // Down Arrow Icon
                icon: const Icon(Icons.keyboard_arrow_down),
                items: developerType.keys.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDeveloperValue = newValue!;
                    _developerTypeController =
                        developerType[selectedDeveloperValue].toString();
                  });
                },
                hint: const Text(
                  'select developer type.',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
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
                child: const Text('add project'),
                onPressed: () {
                  _developerBloc
                      .addDeveloper(
                    DeveloperDto(
                      id: null,
                      fullName: _nameController,
                      nickName: _nickNameController,
                      email: _emailController,
                      phone: _phoneController,
                      type: int.parse(_developerTypeController),
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
