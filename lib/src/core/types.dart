import 'package:infinite_list_bloc/src/bloc/infinite_list_bloc.dart';
import 'package:infinite_list_bloc/src/bloc/infinite_list_event.dart';
import 'package:infinite_list_bloc/src/bloc/infinite_list_state.dart';
import 'package:infinite_list_bloc/src/cubit/infinite_list_cubit.dart';
import 'package:infinite_list_bloc/src/model/slice.dart';

typedef PagedSliceFetcher<T, S> = Future<Slice<T>> Function(
  int page,
  int size,
  dynamic cancelToken,
  S state,
);

typedef DefaultInfiniteListCubit<T>
    = InfiniteListCubit<T, DefaultInfiniteListState<T>>;

typedef DefaultInfiniteListBloc<T>
    = InfiniteListBloc<T, InfiniteListEvent<T>, DefaultInfiniteListState<T>>;
