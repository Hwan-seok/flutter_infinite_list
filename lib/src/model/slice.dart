import 'package:json_annotation/json_annotation.dart';

part 'slice.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class Slice<T> {
  const Slice(
    this.content,
    this.last,
  );

  factory Slice.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$SliceFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(
    Object Function(T value) toJsonT,
  ) =>
      _$SliceToJson(this, toJsonT);

  final List<T> content;
  final bool last;

  bool get isEmpty => content.isEmpty;
  bool get isNotEmpty => content.isNotEmpty;
  bool get hasNext => !last;
}
