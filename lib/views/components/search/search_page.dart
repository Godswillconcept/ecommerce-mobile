// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/product_notifier.dart';
import '../../utils/constant.dart';
import '../deal/product_card.dart';
import '../products/product_detail.dart';

class SearchPage extends StatefulWidget {
  final String search;
  const SearchPage({super.key, required this.search});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Page"),
        backgroundColor: appBarBg,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.topCenter,
              child: Text(
                "Showing the search results of \"${widget.search}\"",
                style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              ),
            ),
            Consumer<ProductNotifier>(
              builder: (context, productNotifier, child) {
                final searchWord = widget.search.toLowerCase();
                final productList = productNotifier.productList;
                final filterList = productList
                    .where((product) =>
                        product.name.toLowerCase().contains(searchWord))
                    .toList();
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GridView.builder(
                    itemCount: filterList.length,
                    itemBuilder: (BuildContext context, int i) {
                      return Consumer<ProductNotifier>(
                        builder: (context, productNotifier, child) {
                          final product = filterList[i];
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
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20.0,
                      crossAxisSpacing: 20.0,
                      childAspectRatio: 3 / 4,
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
