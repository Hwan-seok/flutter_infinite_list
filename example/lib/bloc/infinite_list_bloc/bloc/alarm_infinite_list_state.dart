import 'package:bloc_infinite_list/bloc_infinite_list.dart';

import '../../../common/models/alarm.dart';

class AlarmInfiniteListState extends InfiniteListState<Alarm, AlarmInfiniteListState> {
  final bool anotherField;

  const AlarmInfiniteListState({
    required super.infList,
    required this.anotherField,
  });

  @override
  AlarmInfiniteListState copyWith({InfiniteList<Alarm>? infList, bool? anotherField}) {
    return AlarmInfiniteListState(
      infList: infList ?? this.infList,
      anotherField: anotherField ?? this.anotherField,
    );
  }

  @override
  List<Object?> get props => [infList, anotherField];
}
