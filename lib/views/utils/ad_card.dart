// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';

class AdCard extends StatefulWidget {
  AdCard({
    super.key,
  });

  @override
  State<AdCard> createState() => _AdCardState();
}

class _AdCardState extends State<AdCard> {
  int _current = 0;

  final List<String> _images = [
    "images/banners/01.jpg",
    "images/banners/02.jpg",
    "images/banners/03.jpg",
    "images/banners/06.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: <Widget>[
          // CarouselSlider(
          //   items: _images.map((image) {
          //     return Container(
          //       margin: EdgeInsets.all(5.0),
          //       child: ClipRRect(
          //         borderRadius: BorderRadius.all(Radius.circular(5.0)),
          //         child: Image.asset(
          //           image,
          //           fit: BoxFit.cover,
          //           width: double.maxFinite,
          //         ),
          //       ),
          //     );
          //   }).toList(),
          //   options: CarouselOptions(
          //     autoPlay: true,
          //     enlargeCenterPage: true,
          //     aspectRatio: 495 / 171,
          //     onPageChanged: (index, reason) {
          //       setState(() {
          //         _current = index;
          //       });
          //     },
          //   ),
          // ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _images.map((image) {
              int index = _images.indexOf(image);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index
                      ? Colors.blue
                      : Colors.grey.withOpacity(0.5),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
