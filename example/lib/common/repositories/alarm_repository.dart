import 'package:bloc_infinite_list/bloc_infinite_list.dart';
import 'package:example/common/models/alarm.dart';

abstract class AlarmRepository {
  Future<Slice<Alarm>> getAlarms({
    required int page,
    required int size,
  });
}
