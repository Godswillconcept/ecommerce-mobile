// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';

import 'product.dart';

part 'cart.g.dart';

@HiveType(typeId: 1)
class Cart {
  @HiveField(0)
  int? id;
  @HiveField(1)
  final List<Product> products;
  @HiveField(2)
  double get total => products.fold<double>(
        0.0,
        (previousValue, product) {
          return previousValue +
              (double.parse(product.price) * product.quantity!);
        },
      );
      

  Cart({
    this.id,
    required this.products,
  });
}
