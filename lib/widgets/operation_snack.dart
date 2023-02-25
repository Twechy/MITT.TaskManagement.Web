import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

openSnackBar(
  BuildContext context, {
  required String title,
  required String content,
  required ContentType contentType,
}) {
  var snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: Theme.of(context).backgroundColor,
    content: AwesomeSnackbarContent(
      title: title,
      message: content,
      contentType: contentType,
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
