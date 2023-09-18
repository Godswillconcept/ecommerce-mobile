// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../utils/constant.dart';

class OfferPage extends StatefulWidget {
  const OfferPage({Key? key}) : super(key: key);

  @override
  _OfferPageState createState() => _OfferPageState();
}

class _OfferPageState extends State<OfferPage> {
  List images = [
    "images/banners/16.jpg",
    "images/banners/15.jpg",
    "images/banners/17.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(color: appBarBg),
              alignment: Alignment.center,
              child: Text(
                "Offer",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
              ),
            ),
            Stack(
              children: [
                Container(
                  height: 50,
                  color: appBarBg,
                ),
                SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      color: bodyBg,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      children: List.generate(
                        images.length,
                        (index) => Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(images[index]),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
