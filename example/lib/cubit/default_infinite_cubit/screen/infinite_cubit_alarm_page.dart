import 'package:example/common/repositories/alarm_repository_impl.dart';
import 'package:example/common/widgets/scroll_end_notifier.dart';
import 'package:example/cubit/default_infinite_cubit/bloc/alarm_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/widgets/alarm.dart';

class DefaultInfiniteCubitAlarmPage extends StatelessWidget {
  const DefaultInfiniteCubitAlarmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AlarmDefaultInfiniteCubit(
        alarmRepository: AlarmRepositoryImpl(),
      )..fetchNext(),
      child: const _DefaultInfiniteCubitAlarmView(),
    );
  }
}

class _DefaultInfiniteCubitAlarmView extends StatelessWidget {
  const _DefaultInfiniteCubitAlarmView();

  @override
  Widget build(BuildContext context) {
    final alarms = context.select(
      (AlarmDefaultInfiniteCubit cubit) => cubit.state.items,
    );
    final isLoading = context.select(
      (AlarmDefaultInfiniteCubit cubit) => cubit.state.isLoading,
    );

    return Scaffold(
      body: ScrollEndNotifier(
        onScrollEnd: () =>
            context.read<AlarmDefaultInfiniteCubit>().fetchNext(),
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
