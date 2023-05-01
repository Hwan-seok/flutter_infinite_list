import 'package:bloc_infinite_list/bloc_infinite_list.dart';

import '../../../common/models/alarm.dart';

class AlarmState extends InfiniteListState<Alarm, AlarmState> {
  final bool anotherField;

  const AlarmState({
    required super.infList,
    required this.anotherField,
  });

  @override
  AlarmState copyWith({InfiniteList<Alarm>? infList, bool? anotherField}) {
    return AlarmState(
      infList: infList ?? this.infList,
      anotherField: anotherField ?? this.anotherField,
    );
  }

  @override
  List<Object?> get props => [infList, anotherField];
}
