import 'package:bloc_infinite_list/bloc_infinite_list.dart';
import 'package:example/bloc/infinite_list_bloc/bloc/alarm_infinite_list_event.dart';
import 'package:example/bloc/infinite_list_bloc/bloc/alarm_infinite_list_state.dart';
import 'package:example/common/models/alarm.dart';
import 'package:example/common/repositories/alarm_repository.dart';

class AlarmInfiniteListBloc extends InfiniteListBloc<Alarm,
    AlarmInfiniteListEvent, AlarmInfiniteListState> {
  AlarmInfiniteListBloc({
    required AlarmRepository alarmRepository,
  }) : super(
          fetch: (page, size, state, cancelToken) async =>
              alarmRepository.getAlarms(page: page, size: size),
          initialState: const AlarmInfiniteListState(
            infList: InfiniteList(),
            anotherField: false,
          ),
        ) {
    on<AnotherEvent>(
      (event, emit) => emit(state.copyWith(anotherField: true)),
    );
  }
}
