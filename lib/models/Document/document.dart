import 'package:json_annotation/json_annotation.dart';

part 'document.g.dart';

@JsonSerializable()
class Document {
  final String id;
  final String catId;
  final String title;
  final String url;
  final DateTime date;

  Document({
    required this.id,
    required this.catId,
    required this.title,
    required this.url,
    required this.date,
  });

  factory Document.fromJson(Map<String, dynamic> map) =>
      _$DocumentFromJson(map);

  Map<String, dynamic> toJson() => _$DocumentToJson(this);
}
