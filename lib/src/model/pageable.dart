import 'package:bloc_infinite_list/src/model/slice.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pageable.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class Pageable<T> extends Slice<T> {
  const Pageable(
    super.content,
    super.last,
    this.totalElements,
  );

  factory Pageable.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$PageableFromJson(json, fromJsonT);

  @override
  Map<String, dynamic> toJson(
    Object Function(T value) toJsonT,
  ) =>
      _$PageableToJson(this, toJsonT);

  final int totalElements;

  @override
  Pageable<R> map<R>(R Function(T element) mapper) => Pageable<R>(
        content.map(mapper).toList(),
        last,
        totalElements,
      );

  @override
  List<Object?> get props => [content, last, totalElements];
}
