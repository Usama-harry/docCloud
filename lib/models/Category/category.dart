import 'package:json_annotation/json_annotation.dart';

//Models
import '../Document/document.dart';

part 'category.g.dart';

@JsonSerializable()
class Category {
  final String id;
  final String title;
  final List<Document> documents;

  Category({
    required this.id,
    required this.title,
    required this.documents,
  });

  factory Category.frsomJson(Map<String, dynamic> map) =>
      _$CategoryFromJson(map);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
