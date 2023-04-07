import 'package:bloc_infinite_list/bloc_infinite_list.dart';
import 'package:test/test.dart';

void main() {
  test('empty constructor is same as default constructor', () {
    const state1 = DefaultInfiniteListState<int>(infList: InfiniteList());
    final state2 = DefaultInfiniteListState<int>.empty();
    expect(state1, state2);
  });

  test('empty constructor is not same if T is different', () {
    final state1 = DefaultInfiniteListState<int>.empty();
    final state2 = DefaultInfiniteListState<String>.empty();

    expect(state1, isNot(state2));
  });

  test('empty constructor has initial InfiniteList', () {
    final state = DefaultInfiniteListState<int>.empty();

    expect(state.infList, const InfiniteList<int>());
  });
}
