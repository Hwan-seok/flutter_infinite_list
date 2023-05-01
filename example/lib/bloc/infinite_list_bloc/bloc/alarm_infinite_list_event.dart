import 'package:bloc_infinite_list/bloc_infinite_list.dart';
import 'package:example/bloc/infinite_list_bloc/bloc/alarm_infinite_list_state.dart';
import 'package:example/common/models/alarm.dart';

abstract class AlarmInfiniteListEvent
    extends InfiniteListEvent<Alarm, AlarmInfiniteListState> {}

class AnotherEvent extends AlarmInfiniteListEvent {}
