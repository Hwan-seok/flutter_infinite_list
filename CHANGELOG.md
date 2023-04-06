## 0.4.0

- feat: Add convenience methods
- feat: Add ability to emit additional state in the mutable methods
- Breaking feat!: Return null when no item is found.
```dart
Methods that find index of the item are now return null if there is no finding item located in the list.

The affecting methods are:

indexOf()
lastIndexOf()
indexWhere()
lastIndexWhere()
```

## 0.3.0

- chore(deps): Bump dio version to ^5

## 0.2.1

- feat: Open mutable methods and add assertions
- test: Add tests for bloc and cubits

## 0.2.0

- test: Add test to slice mapper
- feat: Add equality to Slice and Pageable
- feat: Add map method to the Slice
- feat: Open the method named registerLimit
- docs: Write a little docs

## 0.1.0

- test: Update tests using fake_async
- feat: Mark mutable method as internal


## 0.0.6

- chore: disable sort_constructors_first from analysis
- feat: Add ability to notify complete event in the bloc
- test: Add tests for notifying bloc

## 0.0.5

- fix: RemoveAt returns abnormal list

## 0.0.4

- feat: Enable serialize/deserialize to pageable and slice.

## 0.0.3

- fix: Export all functionalities.

## 0.0.2

- chore(deps): downgrade the collection version from 1.17.1 to 1.16.0 by version compatibility with flutter.

## 0.0.1

- Initial release
