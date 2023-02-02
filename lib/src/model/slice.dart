class Slice<T> {
  const Slice(
    this.content,
    this.last,
  );

  final List<T> content;
  final bool last;

  bool get isEmpty => content.isEmpty;
  bool get isNotEmpty => content.isNotEmpty;
  bool get hasNext => !last;

  factory Slice.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$SliceFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(
    Object Function(T value) toJsonT,
  ) =>
      _$SliceToJson(this, toJsonT);
}

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
