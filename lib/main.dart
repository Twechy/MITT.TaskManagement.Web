import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taskmanagement/pages/tasks/task_list_vew.dart';
import 'package:taskmanagement/theme.dart';

import 'pages/index.dart';

void main() {
  usePathUrlStrategy();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Management',
      debugShowCheckedModeBanner: false,
      theme: appThemeData,
      darkTheme: addDarkTheme,
      themeMode: ThemeMode.system,
      useInheritedMediaQuery: true,
      initialRoute: '/',
      routes: {
        '/': (context) => Index(
              key: key,
              title: 'Task Management',
            ),
        TaskListView.route: (context) => TaskListView(key: key),
      },
    );
  }
}
