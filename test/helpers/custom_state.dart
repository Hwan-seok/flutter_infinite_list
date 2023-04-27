import 'package:bloc_infinite_list/bloc_infinite_list.dart';

class CustomState extends InfiniteListState<int, CustomState> {
  final String value;

  CustomState({
    required super.infList,
    required this.value,
  });

  CustomState.list(List<int> list)
      : value = '0',
        super(
          infList: InfiniteList.fromSlice(
            slice: Slice(items: list, didFetchedAll: false),
          ),
        );

  @override
  CustomState copyWith({
    InfiniteList<int>? infList,
    String? value,
  }) =>
      CustomState(
        infList: infList ?? this.infList,
        value: value ?? this.value,
      );

  @override
  List<Object?> get props => [infList, value];
}
