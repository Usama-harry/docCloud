// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Document _$DocumentFromJson(Map<String, dynamic> json) => Document(
      id: json['id'] as String,
      catId: json['catId'] as String,
      title: json['title'] as String,
      url: json['url'] as String,
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$DocumentToJson(Document instance) => <String, dynamic>{
      'id': instance.id,
      'catId': instance.catId,
      'title': instance.title,
      'url': instance.url,
      'date': instance.date.toIso8601String(),
    };
