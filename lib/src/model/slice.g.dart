// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Slice<T> _$SliceFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    Slice<T>(
      (json['content'] as List<dynamic>).map(fromJsonT).toList(),
      json['last'] as bool,
    );

Map<String, dynamic> _$SliceToJson<T>(
  Slice<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'content': instance.content.map(toJsonT).toList(),
      'last': instance.last,
    };
