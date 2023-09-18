import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Category {
  int? id;
  String name;
  int? parentId;
  String description;
  String? icon;
  List<Category> children;
  Category({
    this.id,
    required this.name,
    this.parentId,
    required this.description,
    this.icon,
    required this.children,
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
      children: List<Category>.from((map['children'] as List).map<Category>((x) => Category.fromMap(x as Map<String,dynamic>),),),
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) => Category.fromMap(json.decode(source) as Map<String, dynamic>);
}
