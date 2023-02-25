import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

enum ActiveTaskDisplay { v, h }

Widget activeTasks(BuildContext context, int taskCount) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      textView('tasks', textFontSize: 12),
      const SizedBox(height: 4),
      Badge(
        badgeContent: textView(taskCount.toString(), textFontSize: 8),
        animationType: BadgeAnimationType.slide,
        badgeColor: taskCount >= 1 ? Colors.red : Colors.grey,
        child: const Icon(FontAwesomeIcons.listCheck, size: 24),
      ),
    ],
  );
}

Widget labelView(
  BuildContext context,
  ActiveTaskDisplay taskDisplay,
  String labelValue,
  String textValue, {
  MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center,
  Color? color,
  double textFontSize = 14.0,
  double labelFontSize = 12.0,
  TextAlign textAlign = TextAlign.center,
  double dividerSize = 5.0,
}) {
  var list = [
    textView(labelValue,
        textFontSize: textFontSize, color: Theme.of(context).colorScheme.error),
    if (taskDisplay == ActiveTaskDisplay.v) SizedBox(height: dividerSize),
    if (taskDisplay == ActiveTaskDisplay.h) SizedBox(width: dividerSize),
    textView(
      textValue,
      textFontSize: textFontSize,
    ),
  ];
  return taskDisplay == ActiveTaskDisplay.v
      ? Column(
          mainAxisAlignment: mainAxisAlignment,
          children: list,
        )
      : Row(
          mainAxisAlignment: mainAxisAlignment,
          children: list,
        );
}

Widget textView(
  String value, {
  Color? color,
  double textFontSize = 16.0,
  TextAlign textAlign = TextAlign.center,
}) {
  return Text(
    value,
    textAlign: textAlign,
    style: GoogleFonts.cairo(
      fontSize: textFontSize,
      color: color,
    ),
  );
}
