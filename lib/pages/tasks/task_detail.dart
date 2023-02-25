import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taskmanagement/services/tasks/task_vm.dart';
import 'package:taskmanagement/widgets/helpers.dart';

import '../../services/tasks/task_manager_bloc.dart';
import '../../widgets/badges.dart';

class TaskDetailPage extends ConsumerStatefulWidget {
  final TaskVm task;

  const TaskDetailPage({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  TaskDetailPageState createState() => TaskDetailPageState();
}

class TaskDetailPageState extends ConsumerState<TaskDetailPage>
    with TickerProviderStateMixin {
  late TaskManagementBloc _taskManagementBloc;

  @override
  void initState() {
    super.initState();
    _taskManagementBloc = ref.read(taskManagementBlocProvider)
      ..setTaskInstance(widget.task);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.key,
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title:
            textView(widget.task.name, textFontSize: 18, color: Colors.white),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: IconButton(
              icon: const Icon(FontAwesomeIcons.plus, color: Colors.white),
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      insetPadding: const EdgeInsets.all(10),
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.lightBlue),
                            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                            child: const Text(
                              "You can make cool stuff!",
                              style: TextStyle(fontSize: 24),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
      body: card(
        context,
        child: buildPageContainer(context),
      ),
    );
  }

  Widget buildPageContainer(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: _buildHeader(context),
          ),
          Expanded(
            flex: 5,
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final startDate = widget.task.startDate.toString().split(' ')[0];
    final endDate = widget.task.endDate.toString().split(' ')[0];

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 15),
          Expanded(
            flex: 1,
            child: card(
              context,
              labelColors: Colors.red,
              cardName: 'info',
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  labelView(
                    context,
                    ActiveTaskDisplay.h,
                    'seqNo',
                    widget.task.seqNo,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  labelView(
                    context,
                    ActiveTaskDisplay.h,
                    'project',
                    widget.task.assignedProjectName,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  labelView(
                    context,
                    ActiveTaskDisplay.h,
                    'manager',
                    widget.task.assignedManagerName,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 30),
          Expanded(
            flex: 1,
            child: card(
              context,
              labelColors: Colors.red,
              // cardColor: Theme.of(context).primaryColorDark,
              cardName: 'timeline',
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ImplementationTypeBadge(
                    implementationTypeBadgeType: widget.task.implementationType,
                    displayLabel: false,
                  ),
                  labelView(
                    context,
                    ActiveTaskDisplay.h,
                    'start-date',
                    startDate,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  labelView(
                    context,
                    ActiveTaskDisplay.h,
                    'end-date',
                    endDate,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  labelView(
                    context,
                    ActiveTaskDisplay.h,
                    'time-left',
                    widget.task.timeLeft,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 30),
          Expanded(
            flex: 3,
            child: card(
              context,
              cardName: 'requirements',
              labelColors: Colors.red,
              // cardColor: Theme.of(context).primaryColorDark,
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: ListView.separated(
                  itemCount: widget.task.requirements.length,
                  shrinkWrap: true,
                  separatorBuilder: (BuildContext context, int index) =>
                      listDivider(),
                  itemBuilder: (context, index) {
                    var req = widget.task.requirements[index];
                    return textView(req, textAlign: TextAlign.center);
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: card(
              context,
              cardName: 'developers',
              labelColors: Colors.red,
              direction: TextDirection.rtl,
              child: DefaultTabController(
                length: 2,
                child: Scaffold(
                    appBar: AppBar(
                      leading: const SizedBox(),
                      bottom: const TabBar(
                        tabs: [
                          Tab(icon: Icon(FontAwesomeIcons.laptopCode)),
                          Tab(icon: Icon(FontAwesomeIcons.magnifyingGlass)),
                        ],
                      ),
                    ),
                    body: TabBarView(
                      children: [
                        streamBuilderBe(),
                        streamBuilderQa(),
                      ],
                    )),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: card(
              context,
              cardName: 'reviews',
              labelColors: Colors.red,
              // cardColor: Theme.of(context).primaryColorDark,
              direction: TextDirection.rtl,
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: StreamBuilder<List<Review>>(
                  stream: _taskManagementBloc.selectedReviews$,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Review>> snapshot) {
                    var reviews = snapshot.data ?? [];

                    if (reviews.isEmpty) {
                      return SizedBox(
                        child: Center(
                          child: textView('no reviews selected!!'),
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: reviews.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          listDivider(),
                      itemBuilder: (context, index) {
                        final review = reviews[index];
                        return ListTile(
                          title: textView(
                              review.reviewDate.toString().split(' ')[0]),
                          onTap: () => _taskManagementBloc.selectReview(review),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 5,
            child: card(
              context,
              cardName: 'findings',
              labelColors: Colors.red,
              // cardColor: Theme.of(context).primaryColorDark,
              direction: TextDirection.rtl,
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: StreamBuilder<List<Finding>>(
                  stream: _taskManagementBloc.selectedFindings$,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Finding>> snapshot) {
                    var findings = snapshot.data ?? [];

                    if (findings.isEmpty) {
                      return SizedBox(
                        child: Center(
                          child: textView('no findings selected!!'),
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: findings.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          listDivider(),
                      itemBuilder: (context, index) {
                        final finding = findings[index];
                        return ListTile(
                          leading: textView(finding.scope),
                          title: textView(finding.location),
                          trailing: textView(finding.discription),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  Padding streamBuilderBe() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<List<AssignedDev>>(
        stream: _taskManagementBloc.beDevelopers$,
        builder:
            (BuildContext context, AsyncSnapshot<List<AssignedDev>> snapshot) {
          var assignedDevelopers = snapshot.data ?? [];
          return ListView.separated(
            itemCount: assignedDevelopers.length,
            separatorBuilder: (BuildContext context, int index) => listDivider(),
            itemBuilder: (context, index) {
              final developer = assignedDevelopers[index];
              return ListTile(
                onTap: () => _taskManagementBloc.selectDeveloper(developer),
                title: textView(developer.name),
                trailing: developer.reviews.isNotEmpty
                    ? Icon(
                        FontAwesomeIcons.paperclip,
                        color: Theme.of(context).errorColor,
                      )
                    : const SizedBox(),
              );
            },
          );
        },
      ),
    );
  }

  Padding streamBuilderQa() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<List<AssignedDev>>(
        stream: _taskManagementBloc.qaDevelopers$,
        builder:
            (BuildContext context, AsyncSnapshot<List<AssignedDev>> snapshot) {
          var assignedDevelopers = snapshot.data ?? [];
          return ListView.separated(
            itemCount: assignedDevelopers.length,
            separatorBuilder: (BuildContext context, int index) => listDivider(),
            itemBuilder: (context, index) {
              final developer = assignedDevelopers[index];
              return ListTile(
                onTap: () => _taskManagementBloc.selectDeveloper(developer),
                title: textView(developer.name),
                trailing: developer.reviews.isNotEmpty
                    ? Icon(
                        FontAwesomeIcons.paperclip,
                        color: Theme.of(context).errorColor,
                      )
                    : const SizedBox(),
              );
            },
          );
        },
      ),
    );
  }

  Widget listDivider({double? endIndent = 80.0, Color? color = Colors.white}) =>
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: Divider(
          height: 3,
          color: Colors.white,
          endIndent: endIndent,
        ),
      );

  Widget card(BuildContext context,
      {required Widget child,
      String? cardName,
      Color? cardColor,
      Color? labelColors,
      TextDirection direction = TextDirection.ltr}) {
    return SizedBox(
      child: Directionality(
        textDirection: direction,
        child: Card(
          color: Theme.of(context).primaryColor,
          elevation: 12,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Stack(
            children: <Widget>[
              Align(
                child: child,
              ),
              Positioned(
                top: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                  decoration: BoxDecoration(
                    color: labelColors,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: cardName == null
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: textView(
                            cardName,
                            textFontSize: 11,
                          ),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
