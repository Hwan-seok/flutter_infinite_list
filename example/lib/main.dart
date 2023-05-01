import 'package:example/bloc/default_infinite_list_bloc/screen/default_infinite_list_bloc_alarm_page.dart';
import 'package:example/bloc/infinite_list_bloc/screen/infinite_list_bloc_alarm_page.dart';
import 'package:example/cubit/default_infinite_list_cubit/screen/infinite_cubit_alarm_page.dart';
import 'package:example/cubit/infinite_list_cubit/screen/infinite_cubit_alarm_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AlarmPage(),
    );
  }
}

class AlarmPage extends StatelessWidget {
  const AlarmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Tile(
              exampleName: 'default_infinite_list_cubit',
              page: DefaultInfiniteCubitAlarmPage(),
            ),
            Tile(
              exampleName: 'infinite_list_cubit',
              page: InfiniteCubitAlarmPage(),
            ),
            Tile(
              exampleName: 'default_infinite_list_bloc',
              page: DefaultInfiniteBlocAlarmPage(),
            ),
            Tile(
              exampleName: 'infinite_list_bloc',
              page: InfiniteBlocAlarmPage(),
            ),
          ],
        ),
      ),
    );
  }
}

class Tile extends StatelessWidget {
  final String exampleName;
  final Widget page;
  const Tile({super.key, required this.exampleName, required this.page});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => page,
        ),
      ),
      child: Text(
        exampleName,
        style: const TextStyle(fontSize: 26),
      ),
    );
  }
}
