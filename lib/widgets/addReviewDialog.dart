import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddReviewDialog extends ConsumerStatefulWidget {
  const AddReviewDialog({
    Key? key,
  }) : super(key: key);

  @override
  AddReviewState createState() => AddReviewState();
}

class AddReviewState extends ConsumerState<AddReviewDialog> {
  final _projectNameEditingController = TextEditingController();
  final _projectDescriptionEditingController = TextEditingController();
  final _projectTypeEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var dialog = Dialog(
      insetPadding: const EdgeInsets.all(20),
      key: widget.key,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.white70, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Theme.of(context).primaryColorLight,
      child: Column(
        children: [
          const DrawerHeader(child: Text('drawer header')),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: CupertinoTextField(
              controller: _projectNameEditingController,
              padding: const EdgeInsets.all(8),
              prefix: const Icon(FontAwesomeIcons.diagramProject),
              placeholder: "project name",
              onChanged: (text) {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: CupertinoTextField(
              controller: _projectDescriptionEditingController,
              padding: const EdgeInsets.all(8),
              prefix: const Icon(Icons.description),
              placeholder: "project description",
              onChanged: (text) {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: CupertinoTextField(
              controller: _projectTypeEditingController,
              padding: const EdgeInsets.all(8),
              prefix: const Icon(FontAwesomeIcons.code),
              placeholder: "project type",
              onChanged: (text) {},
            ),
          ),
          MaterialButton(
            onPressed: () {},
            color: Theme.of(context).primaryColor,
            child: const Text('add'),
          )
        ],
      ),
    );

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SizedBox(
      height: height - 400,
      width: width - 400,
      child: dialog,
    );
  }
}
