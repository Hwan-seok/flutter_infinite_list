import 'package:bloc_infinite_list/src/bloc/infinite_list_bloc.dart';
import 'package:bloc_infinite_list/src/bloc/infinite_list_event.dart';
import 'package:bloc_infinite_list/src/bloc/infinite_list_state.dart';
import 'package:bloc_infinite_list/src/cubit/infinite_list_cubit.dart';
import 'package:bloc_infinite_list/src/model/slice.dart';
import 'package:dio/dio.dart';

typedef PagedSliceFetcher<T, S> = Future<Slice<T>> Function(
  int page,
  int size,
  CancelToken? cancelToken,
  S state,
);

typedef DefaultInfiniteListCubit<T>
    = InfiniteListCubit<T, DefaultInfiniteListState<T>>;

typedef DefaultInfiniteListBloc<T> = InfiniteListBloc<
    T,
    InfiniteListEvent<T, DefaultInfiniteListState<T>>,
    DefaultInfiniteListState<T>>;
