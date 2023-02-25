import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taskmanagement/services/projects/project_model.dart';
import 'package:taskmanagement/widgets/helpers.dart';

class ProjectTypeBadge extends StatelessWidget {
  final ProjectType projectType;
  final double iconSize;

  const ProjectTypeBadge({
    Key? key,
    required this.projectType,
    this.iconSize = 20.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildColumn(
      context,
      children: [
        Icon(
          _getIcon(projectType),
          color: Theme.of(context).colorScheme.error,
          size: iconSize,
        ),
        const SizedBox(height: 2),
        textView(
          getProjectTypeName(projectType),
          textFontSize: 10,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  IconData _getIcon(ProjectType type) {
    switch (type) {
      case ProjectType.mobile:
        return FontAwesomeIcons.mobileScreen;
      case ProjectType.payment:
        return FontAwesomeIcons.moneyBill;
      case ProjectType.web:
        return FontAwesomeIcons.firefoxBrowser;
      case ProjectType.other:
        return FontAwesomeIcons.industry;
      default:
        return FontAwesomeIcons.mobile;
    }
  }

  String getProjectTypeName(ProjectType developerType) {
    switch (developerType) {
      case ProjectType.mobile:
        return 'mobile banking';
      case ProjectType.payment:
        return 'payment';
      case ProjectType.web:
        return 'web portal';
      case ProjectType.other:
        return 'other';
      default:
        return 'other';
    }
  }
}

class DeveloperTypeBadge extends StatelessWidget {
  final int developerType;
  final double iconSize;

  const DeveloperTypeBadge({
    Key? key,
    required this.developerType,
    this.iconSize = 20.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildColumn(context, children: [
      Icon(
        _getIcon(developerType),
        color: Theme.of(context).colorScheme.error,
        size: iconSize,
      ),
      const SizedBox(height: 2),
      textView(
        getDeveloperTypeName(developerType),
        textFontSize: 12,
        textAlign: TextAlign.center,
      ),
    ]);
  }

  IconData _getIcon(int type) {
    switch (type) {
      case 1:
        return FontAwesomeIcons.laptopCode;
      case 2:
        return FontAwesomeIcons.magnifyingGlass;
      case 3:
        return FontAwesomeIcons.userNurse;
      case 4:
        return FontAwesomeIcons.user;
      default:
        return FontAwesomeIcons.laptopCode;
    }
  }

  String getDeveloperTypeName(int developerType) {
    switch (developerType) {
      case 1:
        return 'backend';
      case 2:
        return 'qa';
      case 3:
        return 'manager';
      case 4:
        return 'reviewer';
      default:
        return 'guest';
    }
  }
}

class ImplementationTypeBadge extends StatelessWidget {
  final int implementationTypeBadgeType;
  final double iconSize;
  final bool displayLabel;
  final ViewDirection direction;

  const ImplementationTypeBadge({
    Key? key,
    required this.implementationTypeBadgeType,
    this.iconSize = 20.0,
    this.displayLabel = false,
    this.direction = ViewDirection.V,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var list = [
      Icon(
        _getIcon(),
        color: Theme.of(context).colorScheme.error,
        size: iconSize,
      ),
      const SizedBox(height: 10,width: 10),
      if (displayLabel)
        textView(
          getDeveloperTypeName(),
          textFontSize: 12,
          textAlign: TextAlign.center,
        ),
    ];
    return direction == ViewDirection.V
        ? buildColumn(context, children: list)
        : buildRow(context, children: list);
  }

  IconData _getIcon() {
    switch (implementationTypeBadgeType) {
      case 1:
        return FontAwesomeIcons.plus;
      case 2:
        return FontAwesomeIcons.arrowsUpDown;
      default:
        return FontAwesomeIcons.laptopCode;
    }
  }

  String getDeveloperTypeName() {
    switch (implementationTypeBadgeType) {
      case 1:
        return 'new';
      case 2:
        return 'enhancement';
      default:
        return 'enhancement';
    }
  }
}

enum ViewDirection { V, H }

Widget buildColumn(BuildContext context, {required List<Widget> children}) =>
    Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );

Widget buildRow(BuildContext context, {required List<Widget> children}) => Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
