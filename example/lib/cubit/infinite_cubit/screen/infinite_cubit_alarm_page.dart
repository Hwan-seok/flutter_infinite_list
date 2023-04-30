import 'package:example/common/widgets/scroll_end_notifier.dart';
import 'package:example/cubit/infinite_cubit/bloc/alarm_cubit.dart';
import 'package:example/cubit/infinite_cubit/repositories/alarm_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/widgets/alarm.dart';

class InfiniteCubitAlarmPage extends StatelessWidget {
  const InfiniteCubitAlarmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AlarmInfiniteCubit(
        alarmRepository: AlarmRepositoryImpl(),
      )..fetchNext(),
      child: const _InfiniteCubitAlarmView(),
    );
  }
}

class _InfiniteCubitAlarmView extends StatelessWidget {
  const _InfiniteCubitAlarmView();

  @override
  Widget build(BuildContext context) {
    final alarms = context.select(
      (AlarmInfiniteCubit cubit) => cubit.state.items,
    );
    final isLoading = context.select(
      (AlarmInfiniteCubit cubit) => cubit.state.isLoading,
    );

    return Scaffold(
      body: ScrollEndNotifier(
        onScrollEnd: () => context.read<AlarmInfiniteCubit>().fetchNext(),
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
