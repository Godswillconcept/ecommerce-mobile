// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors

import 'package:store_hive/models/product.dart';
import 'package:store_hive/services/request.dart';
import 'package:flutter/material.dart';

import '../components/deal/product_card.dart';
import '../components/products/product_detail.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List productList = [];
  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get('products').then((productResponse) {
      setState(() {
        productList =
            productResponse.data.map((e) => Product.fromMap(e)).toList();
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              itemCount: productList.length,
              itemBuilder: (BuildContext context, int i) {
                final product = productList[i];
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
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20.0,
                crossAxisSpacing: 20.0,
                childAspectRatio: 3 / 4,
              ),
            ),
    );
  }
}
