import 'package:bloc_infinite_list/bloc_infinite_list.dart';
import 'package:example/common/models/alarm.dart';
import 'package:example/common/repositories/alarm_repository.dart';
import 'package:example/cubit/infinite_cubit/bloc/alarm_state.dart';

class AlarmInfiniteCubit extends InfiniteListCubit<Alarm, AlarmState> {
  AlarmInfiniteCubit({
    required AlarmRepository alarmRepository,
  }) : super(
          fetch: (page, size, state, cancelToken) async =>
              alarmRepository.getAlarms(page: page, size: size),
          initialState: const AlarmState(
            infList: InfiniteList(),
            anotherField: false,
          ),
        );
}
