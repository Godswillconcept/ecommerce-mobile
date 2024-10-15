// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:store_hive/views/utils/constant.dart';
import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../services/request.dart';

class NewArrivals extends StatefulWidget {
  const NewArrivals({
    super.key,
  });

  @override
  State<NewArrivals> createState() => _NewArrivalsState();
}

class _NewArrivalsState extends State<NewArrivals> {
  List productList = [];
  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get('latest-products').then((productResponse) {
      setState(() {
        productList =
            productResponse.data.map((e) => Product.fromMap(e)).toList();
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Row(
              children: List.generate(
                5,
                (i) {
                  final product = productList[i];
                  return InkWell(
                    onTap: (() {
                      print(product.name);
                    }),
                    child: Container(
                      margin: EdgeInsets.only(
                        bottom: 10,
                        top: 10,
                        right: 10,
                      ),
                      width: 120,
                      height: 100,
                      decoration: BoxDecoration(
                        color: bodyBg,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(baseUrl + product.image!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
