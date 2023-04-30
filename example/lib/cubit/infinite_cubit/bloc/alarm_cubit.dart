import 'package:bloc_infinite_list/bloc_infinite_list.dart';
import 'package:example/cubit/infinite_cubit/repositories/alarm_repository.dart';
import 'package:example/common/models/alarm.dart';

class AlarmInfiniteCubit extends DefaultInfiniteListCubit<Alarm> {
  AlarmInfiniteCubit({
    required AlarmRepository alarmRepository,
  }) : super(
          fetch: (page, size, state, cancelToken) async =>
              alarmRepository.getAlarms(page: page, size: size),
          initialState: DefaultInfiniteListState.empty(),
        );
}
