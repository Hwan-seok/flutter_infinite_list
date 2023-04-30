import 'package:flutter/material.dart';

import '../models/alarm.dart';

class AlarmWidget extends StatelessWidget {
  final Alarm alarm;
  const AlarmWidget({super.key, required this.alarm});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Text("alarm: ${alarm.id} ${alarm.description}"),
      ),
    );
  }
}
