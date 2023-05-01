import 'package:example/bloc/infinite_list_bloc/bloc/alarm_infinist_list_bloc.dart';
import 'package:example/bloc/infinite_list_bloc/bloc/alarm_infinite_list_event.dart';
import 'package:example/common/repositories/alarm_repository_impl.dart';
import 'package:example/common/widgets/scroll_end_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/widgets/alarm.dart';

class InfiniteBlocAlarmPage extends StatelessWidget {
  const InfiniteBlocAlarmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AlarmInfiniteListBloc(
        alarmRepository: AlarmRepositoryImpl(),
      )..triggerFetchNext(),
      child: const _InfiniteBlocAlarmView(),
    );
  }
}

class _InfiniteBlocAlarmView extends StatelessWidget {
  const _InfiniteBlocAlarmView();

  @override
  Widget build(BuildContext context) {
    final alarms = context.select(
      (AlarmInfiniteListBloc cubit) => cubit.state.items,
    );
    final isLoading = context.select(
      (AlarmInfiniteListBloc cubit) => cubit.state.isLoading,
    );
    final anotherField = context.select(
      (AlarmInfiniteListBloc cubit) => cubit.state.anotherField,
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            context.read<AlarmInfiniteListBloc>().add(AnotherEvent()),
      ),
      appBar:
          AppBar(title: Text("infinite_list_bloc anotherField: $anotherField")),
      body: ScrollEndNotifier(
        onScrollEnd: () =>
            context.read<AlarmInfiniteListBloc>().triggerFetchNext(),
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
