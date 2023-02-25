import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:taskmanagement/pages/developers/developer_index.dart';
import 'package:taskmanagement/pages/managers/manager_index.dart';
import 'package:taskmanagement/pages/projects/project_index.dart';
import 'package:taskmanagement/pages/tasks/task_index.dart';

class Index extends StatefulWidget {
  const Index({super.key, required this.title});

  final String title;

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  PageController page = PageController();

  late String title;

  late List<SideMenuItem> items;

  @override
  void initState() {
    super.initState();
    items = [
      SideMenuItem(
        priority: 0,
        title: 'Projects',
        onTap: () {
          page.jumpToPage(0);
          setState(() {
            title = 'Projects';
          });
        },
        icon: const Icon(Icons.holiday_village, size: 12),
      ),
      SideMenuItem(
        priority: 1,
        title: 'Developers',
        onTap: () {
          page.jumpToPage(1);
          setState(() {
            title = 'Developers';
          });
        },
        icon: const Icon(Icons.developer_mode),
      ),
      SideMenuItem(
        priority: 2,
        title: 'Managers',
        onTap: () {
          page.jumpToPage(2);
          setState(() {
            title = 'Managers';
          });
        },
        icon: const Icon(Icons.manage_accounts_outlined),
      ),
      SideMenuItem(
        priority: 3,
        title: 'Tasks',
        onTap: () {
          page.jumpToPage(3);
          setState(() {
            title = 'Tasks';
          });
        },
        icon: const Icon(Icons.task),
        badgeContent: const Text(
          '3',
          style: TextStyle(color: Colors.white),
        ),
      ),
      SideMenuItem(
        priority: 4,
        title: 'Statistics',
        onTap: () {
          page.jumpToPage(4);
          setState(() {
            title = 'Statistics';
          });
        },
        icon: const Icon(Icons.query_stats),
      ),
    ];

    title = items.first.title ?? 'Projects';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.key,
      appBar: _buildAppBar(),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenu(
            style: SideMenuStyle(
              backgroundColor: Theme.of(context).primaryColor,
              displayMode: SideMenuDisplayMode.compact,
              hoverColor: Colors.blue[100],
              selectedColor: Colors.blue[600],
              selectedTitleTextStyle: const TextStyle(color: Colors.white),
              selectedIconColor: Colors.white,
              unselectedIconColor: Colors.white,
              unselectedTitleTextStyle: TextStyle(color: Theme.of(context).backgroundColor),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor,
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 0), // changes position of shadow
                    ),
                  ]),
              openSideMenuWidth: 180,
              compactSideMenuWidth: 58,
            ),
            controller: page,
            onDisplayModeChanged: (mode) {},
            items: items,
            showToggle: true,
          ),
          Expanded(
            child: PageView(
              controller: page,
              children: [
                const ProjectIndex(),
                const DeveloperIndex(),
                const ManagerIndex(),
                TaskDetail(key: widget.key),
                const Center(child: Text('Statistics')),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 40,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      backgroundColor: Theme.of(context).primaryColor,
      actions: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: ProfilePicture(
            name: 'Ans Jamal',
            role: 'Reviewer',
            radius: 31,
            fontsize: 22,
            tooltip: true,
            img: 'https://avatars.githubusercontent.com/u/37553901?v=4',
            count: 2,
            random: false,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.logout),
            color: Colors.white,
          ),
        )
      ],
    );
  }
}
