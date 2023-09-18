// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ecommerce/views/utils/constant.dart';

import '../products/product_detail.dart';
import '/controllers/product_notifier.dart';
import 'product_card.dart';

class HotDealView extends StatelessWidget {
  const HotDealView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        elevation: 0,
        backgroundColor: appBarBg,
        centerTitle: true,
        title: Text(
          "Hot Deals",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: GridView.builder(
            itemCount: 10,
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
                    child: ProductCard(
                      product: product,
                    ),
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
          ),
        ),
      ),
    );
  }
}
