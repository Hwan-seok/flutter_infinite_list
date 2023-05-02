# bloc_infinite_list

# Motivation

As a bloc user, you may have experienced struggles with boilerplate code, especially when dealing with lists. Various apps implement infinite list scrolling features. Although each app may have different business requirements, infinite lists are built using three main components:


1. Having a list
2. Querying item(s) from the list
3. Mutating item(s) in the list

However, we often build these features manually from scratch, which can be time-consuming and error-prone. To address these issues, the bloc_infinite_list package provides a range of features to streamline the process.



> Tell your PM that infinite scrolling features take time, but with this package, you'll finish quickly and sneak in coffee breaks. 😎







## Examples
This repository includes a basic example app in the [example](https://github.com/Hwan-seok/flutter_infinite_list/tree/main/example) folder.


## Installation

```dart
dependencies:
  bloc_infinite_list: ^1.0.0
```



# Usage

This package offers the following Blocs and Cubits to simplify building infinite list blocs (cubits):

- Cubit

1. **Default**InfiniteListCubit
2. InfiniteListCubit
3. **Multi**InfiniteListCubit

- Bloc

1. **Default**InfiniteListBloc
2. InfiniteListBloc




## Convenient Methods

These methods are available for **Cubit only**. Using them in Bloc will result in an Assertion Error. Instead, use bloc.triggerXXX() in Bloc, as detailed in the [`InfiniteListBloc` section](#InfiniteListBloc).

```dart
/// Fetches next page.
cubit.fetchNext();

/// Fetches the first page and replaces the current list.
/// Useful for implementing pull-to-refresh features.
cubit.reinitialize();

/// Clears the current list.
/// The list will be empty after this operation.
cubit.reset();

/// Adds all [items] to the end of the list.
cubit.addItem(T item);

/// Inserts the [item] at the specified [idx] in the list.
cubit.addItems(List<T> items);

/// Inserts the [item] at the specified [idx] in the list.
cubit.insert(int idx, T item);

/// Removes the [item] from the list.
cubit.remove(T item);

/// Removes the item at the specified [idx].
cubit.removeAt(int idx);

/// Replaces the [before] item with the [after] item.
cubit.replace(T before, T after);

/// Replaces the item at the specified [idx] with the [item].
cubit.replaceAt(int idx, T item);

/// Replaces all items that pass the [test] with the returned value of the [willReplacedItemGenerator].
/// The [element] that passed the [test] will be provided to the [willReplacedItemGenerator].
cubit.replaceWhere(
  bool Function(T) test,
  T Function(T element) willReplacedItemGenerator,
);
```


## Cubit
### DefaultInfiniteListCubit
```dart
class PlayerCubit extends DefaultInfiniteListCubit<Player> {
  PlayerCubit(
    PlayerRepository playerRepository,
  ) : super(
      fetch: (page, size, state, cancelToken) => 
        playerRepository.getAll(
          page: page,
          size: size,
          cancelToken: cancelToken
        ),
      initialState: DefaultInfiniteListState(
        infList: InfiniteList(),
      ),
      // Alternatively, pass an empty default state.
      // initialState: DefaultInfiniteListState.empty() 
    );
}
```

### Custom state
```dart
class PlayerState extends InfiniteListState<Player, PlayerState> {
  final int id;

  PlayerState({
    super.infList,
    required this.id,
  });

  ...
}

class PlayerCubit extends InfiniteListCubit<Player, PlayerState> {
  PlayerCubit(
    PlayerRepository playerRepository,
  ) : super(
      fetch: (page, size, state, cancelToken) => 
        playerRepository.getAll(
          page: page,
          size: size,
          cancelToken: cancelToken
        ),
      initialState: DefaultInfiniteListState(
        infList: InfiniteList(),
      ),
      // Alternatively, pass an empty default state.
      // initialState: DefaultInfiniteListState.empty() 
    );
}
```
## InfiniteListBloc

InfiniteListBloc includes built-in events that can be used by default without registering event handlers using `on(...)`. These events correspond to the [convenient methods](#convenient-methods) of `InfiniteListCubit`.

> Note: You should register handlers if you use custom events. This will be explained later.

### Shortcuts

Each event has a helper method that delegates event addition to the bloc.

```dart
bloc.add(InfiniteListEvent.fetchNext());
= bloc.triggerFetchNext();

bloc.add(InfiniteListEvent.reinitialize());
= bloc.triggerReinitialize();

bloc.add(InfiniteListEvent.reset());
= bloc.triggerReset();

bloc.add(InfiniteListEvent.addItem(Food(id:5) /* T item */));
= bloc.triggerAddItem(...);

bloc.add(
  InfiniteListEvent.addItems(
    [Food(id:5), Food(id:6)], // List<T> items
  )
);
= bloc.triggerAddItems([...]);

bloc.add(
  InfiniteListEvent.insert(
    1, // int idx, 
    Food(id:2, "insertedFood"), // T item
  )
);
= bloc.triggerInsert(...);

bloc.add(InfiniteListEvent.remove(Food(id:1, name: "yourFood") /* T item */));
= bloc.triggerRemove(...);

bloc.add(InfiniteListEvent.removeAt(1 /* int idx*/));
= bloc.triggerRemoveAt(...);

bloc.add(
  InfiniteListEvent.replace(
    Food(id: 1, name: "myFood") // T before, 
    Food(id: 1, name: "ourFood") // T after,
  )
);
= bloc.triggerReplace(...);

bloc.add(
  InfiniteListEvent.replaceAt(
    3, // int idx
    Food(id: 1, name: "myFood"), // T item
  )
);
= bloc.triggerReplaceAt(...);

bloc.add(
  InfiniteListEvent.replaceWhere(
    (T item) => item.id == 1, // bool Function(T) test
    (T item) => item.name == "newName", // T Function(T element) willReplacedItemGenerator,
  )
);
= bloc.triggerReplaceWhere(...);

```

### Default event & state

```dart
class FoodBloc extends DefaultInfiniteListBloc<Food> {
    ...same as cubit
}

```

### Custom event & state

```dart

abstract class FoodEvent extends InfiniteListEvent<Food> {
  const FoodEvent();
}

abstract class FoodEventHadForLaunch extends InfiniteListEvent<Food> {
  const FoodEventHadForLaunch();
}

---

class FoodBloc extends InfiniteListBloc<Food, FoodEvent, FoodState> {
  FoodBloc(){
    ... other default events are automatically registered by library.
    on<FoodEventHadForLaunch>(_onHadForLaunch)
  }

  _onHadForLaunch(event, emit);
}

add(InfiniteListEvent.fetchNext());
add(FoodEventHadForLaunch());
```



---
## Additional Features

### Querying Items from the List

There are several query methods for InfiniteList, similar to `List`. You can find them [here](https://github.com/Hwan-seok/flutter_infinite_list/blob/main/lib/src/bloc_base/queryable.dart).

### Change the Fetching Size

By default, the `fetch` size argument is 10. You can change this behavior by passing the `limit` when creating either `InfiniteListBloc` or `InfiniteListCubit`:

```dart
class MyBloc extends InfiniteListBloc<...> {
  MyBloc() : super(limit: 30, ...);
}
```
Additionally, you can change the fetching size dynamically using `registerLimit(int size)` in your bloc:
```dart

class MyBloc extends InfiniteListBloc<...> {
  ...
  Future<void> myFetchNext() async {
    await fetchNext();
    if(state.itemCount > 30) {
      registerLimit(100);
    }
  }
}

```

### Awaiting Bloc Event Completion

In some situations, you may need to ensure that an event is completed, but this can be somewhat tricky. Fortunately, all [default methods for bloc](#comfortable-methods) return a `Future`, so you can ensure that the event is processed successfully after awaiting it.

```dart
bloc.triggerAddItem(1); // equivalent to `bloc.add(InfiniteListEvent.addItem(1))`
bloc.contains(1); // returns false
---
await bloc.triggerAddItem(1);
bloc.contains(1); // returns true
---
await bloc.triggerFetchNext();
bloc.items // ensures items were added
```


