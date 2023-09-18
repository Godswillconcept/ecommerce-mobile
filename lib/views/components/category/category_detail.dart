// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:ecommerce/views/components/deal/product_card.dart';
import 'package:flutter/material.dart';

import 'package:ecommerce/views/utils/constant.dart';

import '../../../models/category.dart';
import '../../../models/product.dart';
import '../../../services/request.dart';
import '../products/product_detail.dart';

class CategoryDetail extends StatefulWidget {
  final Category category;
  const CategoryDetail({Key? key, required this.category}) : super(key: key);

  @override
  State<CategoryDetail> createState() => _CategoryDetailState();
}

class _CategoryDetailState extends State<CategoryDetail> {
  bool loading = true;
  List<Product>? productList;

  @override
  void initState() {
    fetchProcuctByCategory(widget.category.id!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appBarBg,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        title: Text(
          widget.category.name,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 90,
                  color: appBarBg,
                ),
                loading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        padding: EdgeInsets.only(top: 15),
                        margin: EdgeInsets.only(top: 30),
                        decoration: BoxDecoration(
                          color: bodyBg,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: (() {
                          if (productList!.isEmpty) {
                            return Center(
                              child: SizedBox(
                                width: double.maxFinite,
                                height: 700,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset('images/no_data.png'),
                                    Text(
                                      "Uploading in progress!",
                                      style: TextStyle(
                                        fontSize: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Column(
                              children: [
                                GridView.count(
                                  childAspectRatio: 3 / 4,
                                  crossAxisCount: 2,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  children: List.generate(
                                    productList!.length,
                                    (i) {
                                      Product product = productList![i];
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
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            right: 10,
                                            left: 10,
                                            bottom: 10,
                                          ),
                                          child: ProductCard(
                                          product: product,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          }
                        })(),
                      )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchProcuctByCategory(int id) async {
    get('category/$id/products').then((response) {
      setState(() {
        List<dynamic> data = response.data;
        productList = data.map((e) => Product.fromMap(e)).toList();
        loading = false;
      });
    });
  }
}
