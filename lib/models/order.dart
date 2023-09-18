// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'product.dart';

class Order {
  int? id;
  int? userId;
  DateTime? orderDate;
  String? status;
  String total;
  List<Detail> detail;
  Order({
    DateTime? orderDate,
    this.id,
    this.userId,
    this.status = "Pending",
    required this.total,
    required this.detail,
  }) : orderDate = orderDate ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user_id': userId,
      'order_date': orderDate?.toIso8601String(),
      'status': status,
      'total': total,
      'detail': detail.map((x) => x.toMap()).toList(),
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] != null ? map['id'] as int : null,
      userId: map['user_id'] != null ? map['user_id'] as int : null,
      orderDate: map['order_date'] != null
          ? DateTime.parse(map['order_date'] as String)
          : null,
      status: map['status'] != null ? map['status'] as String : null,
      total: (map['total']).toString(),
      detail: List<Detail>.from(
        (map['detail'] as List).map<Detail>(
          (x) => Detail.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) =>
      Order.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Detail {
  int? id;
  int? orderId;
  int productId;
  Product product;
  int quantity;
  Detail({
    this.id,
    this.orderId,
    required this.productId,
    required this.product,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'product': product.toMap(),
      'quantity': quantity,
    };
  }

  factory Detail.fromMap(Map<String, dynamic> map) {
    return Detail(
      id: map['id'] != null ? map['id'] as int : null,
      orderId: map['order_id'] != null ? map['order_id'] as int : null,
      productId: map['product_id'] as int,
      product: Product.fromMap(map['product'] as Map<String, dynamic>),
      quantity: map['quantity'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Detail.fromJson(String source) =>
      Detail.fromMap(json.decode(source) as Map<String, dynamic>);
}


// class Order {
//   int? id;
//   int userId;
//   List<int?> productIds;
//   User user;
//   List<Product> products;
//   String total;
//   String? status;
//   DateTime? orderDate;
//   Order({
//     this.id,
//     required this.userId,
//     required this.productIds,
//     required this.user,
//     required this.products,
//     required this.total,
//     this.status = 'Pending',
//     DateTime? orderDate,
//   }) : orderDate = orderDate ?? DateTime.now();

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'id': id,
//       'user_id': userId,
//       'products': products
//           .map(
//             (product) =>
//                 {'product_id': product.id, 'quantity': product.quantity},
//           )
//           .toList(),
//       'order_date': orderDate!.toIso8601String(),
//     };
//   }

//   factory Order.fromMap(Map<String, dynamic> map) {
//     return Order(
//       id: map['id'],
//       userId: map['user_id'],
//       productIds: List<int>.from(map['product_ids']),
//       user: User.fromMap(map['user']),
//       products: List<Product>.from(
//         map['products'].map(
//           (product) => Product.fromMap(product),
//         ),
//       ),
//       total: map['total'],
//       status: map['status'],
//       orderDate: DateTime.parse(map['order_date']),
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory Order.fromJson(String source) =>
//       Order.fromMap(json.decode(source) as Map<String, dynamic>);
// }
