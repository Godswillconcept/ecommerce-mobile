import 'dart:convert';
import 'package:hive/hive.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
part 'category.g.dart';

@HiveType(typeId: 3)
class Category extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int? parentId;

  @HiveField(3)
  String description;

  @HiveField(4)
  String? icon;

  @HiveField(5)
  List<Category> children;
  Category({
    this.id,
    required this.name,
    this.parentId,
    required this.description,
    this.icon,
    this.children = const [],
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'parentId': parentId,
      'description': description,
      'icon': icon,
      'children': children.map((x) => x.toMap()).toList(),
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] as String,
      parentId: map['parentId'] != null ? map['parentId'] as int : null,
      description: map['description'] as String,
      icon: map['icon'] != null ? map['icon'] as String : null,
      children: map['children'] != null 
          ? List<Category>.from(
              (map['children'] as List).map<Category>(
                (x) => Category.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source) as Map<String, dynamic>);
}
