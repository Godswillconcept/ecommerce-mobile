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
  final ScrollController _scrollController = ScrollController();
  bool _showLeftArrow = false;
  bool _showRightArrow = true;

  @override
  void initState() {
    super.initState();
    get('latest-products').then((productResponse) {
      setState(() {
        productList =
            productResponse.data.map((e) => Product.fromMap(e)).toList();
        loading = false;
      });
    });

    _scrollController.addListener(() {
      setState(() {
        _showLeftArrow = _scrollController.offset > 20;
        _showRightArrow = _scrollController.offset <
            _scrollController.position.maxScrollExtent - 20;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Method to scroll left
  void _scrollLeft() {
    final currentPosition = _scrollController.offset;
    final scrollAmount = 150.0; // Adjust this value as needed

    _scrollController.animateTo(
      currentPosition - scrollAmount,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Method to scroll right
  void _scrollRight() {
    final currentPosition = _scrollController.offset;
    final scrollAmount = 150.0; // Adjust this value as needed

    _scrollController.animateTo(
      currentPosition + scrollAmount,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 180,
          margin: EdgeInsets.symmetric(vertical: 10),
          child: loading
              ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                )
              : SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  child: Row(
                    children: List.generate(
                      productList.length > 5 ? 5 : productList.length,
                      (i) {
                        final product = productList[i];
                        return Padding(
                          padding: EdgeInsets.only(
                            left: i == 0 ? 16 : 8,
                            right: i == 4 ? 16 : 8,
                          ),
                          child: ProductCard(product: product),
                        );
                      },
                    ),
                  ),
                ),
        ),
        if (_showLeftArrow && !loading)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: _scrollLeft,
              child: _buildDirectionIndicator(
                  Icons.arrow_back_ios_rounded, Colors.black54),
            ),
          ),
        if (_showRightArrow && !loading)
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: _scrollRight,
              child: _buildDirectionIndicator(
                  Icons.arrow_forward_ios_rounded, Colors.black54),
            ),
          ),
      ],
    );
  }

  Widget _buildDirectionIndicator(IconData icon, Color color) {
    return Container(
      width: 30,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.8),
            Colors.white.withOpacity(0.0),
          ],
          begin: icon == Icons.arrow_back_ios_rounded
              ? Alignment.centerLeft
              : Alignment.centerRight,
          end: icon == Icons.arrow_back_ios_rounded
              ? Alignment.centerRight
              : Alignment.centerLeft,
        ),
      ),
      child: Center(
        child: Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 16,
            color: color,
          ),
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final dynamic product;

  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(product.name);
      },
      child: Container(
        width: 140,
        height: 160,
        decoration: BoxDecoration(
          color: bodyBg,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  image: DecorationImage(
                    image: NetworkImage(baseUrl + product.image!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name ?? 'Product',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    '\$${product.price ?? '0.00'}',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
