import 'package:bloc_infinite_list/src/model/slice.dart';
import 'package:dio/dio.dart';

typedef PagedSliceFetcher<T, S> = Future<Slice<T>> Function(
  int page,
  int size,
  CancelToken? cancelToken,
  S state,
);
