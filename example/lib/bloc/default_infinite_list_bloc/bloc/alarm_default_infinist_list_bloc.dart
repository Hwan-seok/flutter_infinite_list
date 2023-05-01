import 'package:bloc_infinite_list/bloc_infinite_list.dart';
import 'package:example/common/models/alarm.dart';
import 'package:example/common/repositories/alarm_repository.dart';

class AlarmDefaultInfiniteListBloc extends DefaultInfiniteListBloc<Alarm> {
  AlarmDefaultInfiniteListBloc({
    required AlarmRepository alarmRepository,
  }) : super(
          fetch: (page, size, state, cancelToken) async =>
              alarmRepository.getAlarms(page: page, size: size),
          initialState: const DefaultInfiniteListState(
            infList: InfiniteList(),
          ),
        );
}
