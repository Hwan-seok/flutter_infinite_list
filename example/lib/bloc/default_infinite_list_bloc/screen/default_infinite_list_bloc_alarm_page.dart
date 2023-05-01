import 'package:example/bloc/default_infinite_list_bloc/bloc/alarm_default_infinist_list_bloc.dart';
import 'package:example/common/repositories/alarm_repository_impl.dart';
import 'package:example/common/widgets/scroll_end_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/widgets/alarm.dart';

class DefaultInfiniteBlocAlarmPage extends StatelessWidget {
  const DefaultInfiniteBlocAlarmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AlarmDefaultInfiniteListBloc(
        alarmRepository: AlarmRepositoryImpl(),
      )..triggerFetchNext(),
      child: const _DefaultInfiniteBlocAlarmView(),
    );
  }
}

class _DefaultInfiniteBlocAlarmView extends StatelessWidget {
  const _DefaultInfiniteBlocAlarmView();

  @override
  Widget build(BuildContext context) {
    final alarms = context.select(
      (AlarmDefaultInfiniteListBloc cubit) => cubit.state.items,
    );
    final isLoading = context.select(
      (AlarmDefaultInfiniteListBloc cubit) => cubit.state.isLoading,
    );

    return Scaffold(
      body: ScrollEndNotifier(
        onScrollEnd: () =>
            context.read<AlarmDefaultInfiniteListBloc>().triggerFetchNext(),
        scrollable: ListView.builder(
          itemCount: alarms.length + (isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == alarms.length) {
              return const SizedBox(
                width: 400,
                height: 400,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return AlarmWidget(alarm: alarms[index]);
          },
        ),
      ),
    );
  }
}
