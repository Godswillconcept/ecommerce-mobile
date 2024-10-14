// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:ecommerce/views/components/deal/product_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/product_notifier.dart';

class CategoryItem extends StatelessWidget {
  CategoryItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductNotifier>(
      builder: (context, productNotifier, child) {
        final productList = Provider.of<ProductNotifier>(context).productList;
        return GridView.builder(
          itemCount: 8,
          itemBuilder: (BuildContext context, int i) {
            final product = productList[i];
            return ProductCard(
              product: product,
            );
          },
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20.0,
            crossAxisSpacing: 20.0,
            childAspectRatio: 3 / 4,
          ),
        );
      },
    );
  }
}
