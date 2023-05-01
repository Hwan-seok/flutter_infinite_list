# bloc_infinite_list

# Motivation

As a `flutter_bloc` user, you may have some experience about struggling with boilerplate especially to `list`.
Various of apps are have infinite list scrolling features in their app.  Even though every applications are have different business requirements, infinite list from all of them are built by just three main points. 

1. Having a list
2. Query item(s) from the list
3. Mutate item(s) from the list

But we always build them manually from the scratch😂. This is incredibly time-consuming and wasting the time.
Also, the methods you made every day could have some bugs if you don't thoroughly test them.

To solve those annoying problems, **`bloc_infinite_list`** made a various features for you!

> Tell your **PM** that the scrolling feature would be take intensive time and have your own time drinking coffee😎.


## Examples
This repo contains basic example app in the [example](https://github.com/Hwan-seok/flutter_infinite_list/tree/main/example) folder.


## Installation

```dart
dependencies:
  bloc_infinite_list: ^0.6.0
```



# Usage

This package provides following Blocs to help you building infinite list bloc(cubit) easily.


- Cubit

1. **Default**InfiniteListCubit
2. InfiniteListCubit
3. **Multi**InfiniteListCubit

- Bloc
1. **Default**InfiniteListBloc
2. InfiniteListBloc




## Comfortable Methods
You can use this from the **Cubit only**. If you use this at Bloc, you will get `Assertion Error`.
In the bloc, instead, you should use `bloc.triggerXXX()`. It will be mentioned at the [`InfiniteListBloc` section](#InfiniteListBloc).

```dart
/// Fetches next page.
cubit.fetchNext();

/// Fetches the first page and replace it with the current list.
/// It is useful when you implement pull-to-refresh feature.
cubit.reinitialize();

/// Clears the current list.
/// After this, your list is empty.
cubit.reset();

/// Adds the [item] into the end of the list.
cubit.addItem(T item);

/// Add all [items] into the end of the list.
cubit.addItems(List<T> items);

/// Insert the [item] in the [idx] of the list.
cubit.insert(int idx, T item)

/// Remove the [item] from the list.
cubit.remove(T item)

/// Remove the item at [idx].
cubit.removeAt(int idx)

/// Replace the [before] to [after].
cubit.replace(T before, T after)

/// Replace the item at [idx] to [item]
cubit.replaceAt(int idx, T item)

/// Replace all items which passes the [test] into returned value of the [willReplacedItemGenerator].
/// The [element] will be passed to [willReplacedItemGenerator] that passed the [test] of each item in the list.
cubit.replaceWhere(
  bool Function(T) test,
  T Function(T element) willReplacedItemGenerator,
)

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
      // or you can just pass the empty default state.
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
      // or you can just pass the empty default state.
      // initialState: DefaultInfiniteListState.empty() 
    );
}
```

## InfiniteListBloc

InfiniteListBloc has some built-in events. You can use it by default without registering event handler by `on(...)`.
Those events are equivalent to the [comfortable methods](#comfortable-methods) of the `InfiniteListCubit`.

> Note: You should register handlers if you use custom events.
> That would be mentioned at later.

Each events has its own helper method that delegates adding events to the bloc.
All of them returns the `Future`, so you can ensure that the event processed successfully after awaiting it.


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
