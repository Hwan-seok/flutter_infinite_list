import 'package:bloc_infinite_list/src/model/slice.dart';

class Pageable<T> extends Slice<T> {
  const Pageable(
    super.content,
    super.last,
    this.totalElements,
  );

  final int totalElements;

  factory Pageable.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$PageResponseFromJson(json, fromJsonT);

  @override
  Map<String, dynamic> toJson(
    Object Function(T value) toJsonT,
  ) =>
      _$PageResponseToJson(this, toJsonT);
}

Pageable<T> _$PageResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    Pageable<T>(
      (json['content'] as List<dynamic>).map(fromJsonT).toList(),
      json['last'] as bool,
      json['totalElements'] as int,
    );

Map<String, dynamic> _$PageResponseToJson<T>(
  Pageable<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'content': instance.content.map(toJsonT).toList(),
      'last': instance.last,
      'totalElements': instance.totalElements,
    };
