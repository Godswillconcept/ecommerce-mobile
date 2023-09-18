// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/product_notifier.dart';
import '../components/deal/product_card.dart';
import '../components/products/product_detail.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    final productList = Provider.of<ProductNotifier>(context).productList;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: GridView.builder(
            
            itemCount: (productList.length),
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
                      ));
                },
              );
            },
            physics: BouncingScrollPhysics(),
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
