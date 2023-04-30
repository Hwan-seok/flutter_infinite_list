import 'package:bloc_infinite_list/bloc_infinite_list.dart';
import 'package:example/common/models/alarm.dart';
import 'package:example/cubit/infinite_cubit/repositories/alarm_repository.dart';

class AlarmRepositoryImpl implements AlarmRepository {
  List<Alarm> _generateAlarms(int seed) => [
        for (var idx = 0; idx < 10; idx++)
          Alarm(id: 10 * seed + idx, description: 'Alarm ${10 * seed + idx}'),
      ];

  @override
  Future<Slice<Alarm>> getAlarms({required int page, required int size}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (page == 5) {
      return Slice(items: _generateAlarms(page), didFetchedAll: true);
    }

    return Slice(items: _generateAlarms(page), didFetchedAll: false);
  }
}
