import 'package:bloc_infinite_list/src/model/slice.dart';

typedef PagedSliceFetcher<T, S> = Future<Slice<T>> Function(
  int page,
  int size,
  S state,
  dynamic cancelToken,
);
