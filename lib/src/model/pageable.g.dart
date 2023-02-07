// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pageable.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pageable<T> _$PageableFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    Pageable<T>(
      (json['content'] as List<dynamic>).map(fromJsonT).toList(),
      json['last'] as bool,
      json['totalElements'] as int,
    );

Map<String, dynamic> _$PageableToJson<T>(
  Pageable<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'content': instance.content.map(toJsonT).toList(),
      'last': instance.last,
      'totalElements': instance.totalElements,
    };
