// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../products/product_detail.dart';
import '/controllers/product_notifier.dart';
import 'product_card.dart';

class DealGrid extends StatelessWidget {
  const DealGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 4,
      itemBuilder: (BuildContext context, int i) {
        return Consumer<ProductNotifier>(
          builder: (context, productNotifier, child) {
            final product = productNotifier.productList[i];
            return InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return ProductDetail(
                        product: product,
                      );
                    },
                  ),
                );
              },
              child: ProductCard(product: product,)
            );
          },
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
  }
}
