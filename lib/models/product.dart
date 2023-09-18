import 'dart:convert';
import 'package:hive/hive.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first

part 'product.g.dart';

@HiveType(typeId: 2)
class Product extends HiveObject{
  @HiveField(0)
  String name;
  @HiveField(1)
  String? brand;
  @HiveField(2)
  String description;
  @HiveField(3)
  int? categoryId;
  @HiveField(4)
  int? id;
  @HiveField(5)
  String price;
  @HiveField(6)
  String? image;
  @HiveField(7)
  int? quantity;
  @HiveField(8)
  String? stocks;
  Product({
    required this.name,
    this.brand,
    required this.description,
    required this.categoryId,
    this.id,
    required this.price,
    this.image,
    this.quantity = 1,
    this.stocks,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'brand': brand,
      'description': description,
      'categoryId': categoryId,
      'id': id,
      'price': price,
      'image': image,
      'quantity': quantity,
      'stocks': stocks,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] as String,
      brand: map['brand'] != null ? map['brand'] as String : null,
      description: map['description'] as String,
      categoryId: map['categoryId'] != null ? map['categoryId'] as int : null,
      id: map['id'] != null ? map['id'] as int : null,
      price: map['price'] as String,
      image: map['image'] != null ? map['image'] as String : null,
      quantity: map['quantity'] != null ? map['quantity'] as int : null,
      stocks: map['stocks'] != null ? map['stocks'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);
}
