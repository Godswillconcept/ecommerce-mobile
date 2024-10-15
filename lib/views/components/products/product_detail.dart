// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:store_hive/controllers/cart_notifier.dart';
import 'package:store_hive/models/product.dart';
import 'package:store_hive/models/review.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../../../models/user.dart';
import '../../../services/request.dart';

class ProductDetail extends StatefulWidget {
  final Product product;
  const ProductDetail({super.key, required this.product});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final TextEditingController _commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final userInfo = Hive.box<User>("userBox");
    final userDetail = userInfo.values.elementAt(0);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.product.name,
          overflow: TextOverflow.fade,
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(
            width: double.maxFinite,
            height: size.height * 0.4,
            child: Image.network(
              baseUrl + widget.product.image!,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: ListView(
                children: [
                  Text(
                    widget.product.name,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Brand: ${widget.product.brand!}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${widget.product.price}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        (widget.product.stocks) == null
                            ? 'Out of stock'
                            : '${widget.product.stocks} in stock',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    widget.product.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Rate this product",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Tell others what you think",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  RatingBar.builder(
                    initialRating: 0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      reviewDialog(context, userDetail, rating, widget.product);
                    },
                  ),
                  Text(
                    "Write a review",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Colors.lightBlue,
        child: Row(
          children: [
            Expanded(
              child: Consumer<CartNotifier>(
                builder: (context, cartNotifier, child) {
                  final product = widget.product;
                  return OutlinedButton.icon(
                    icon: Icon(Icons.shopping_cart_outlined),
                    onPressed: () {
                      cartNotifier.addToCart(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.name} added to cart'),
                          duration: Duration(seconds: 1),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      minimumSize: (Size(double.infinity, 50)),
                      side: BorderSide(
                        width: 2,
                        color: Colors.white,
                      ),
                    ),
                    label: Text("Add to cart"),
                  );
                },
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: ElevatedButton.icon(
                icon: Icon(Icons.favorite),
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent.shade700,
                  minimumSize: (Size(double.infinity, 50)),
                ),
                label: Text("Add to wishlist"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> reviewDialog(
      BuildContext context, User userDetail, rating, product) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(baseUrl + userDetail.image!),
                ),
                SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(userDetail.name, style: TextStyle(fontSize: 20)),
                    SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: 200,
                      child: Text(
                        "Reviews are public and include your account and device information",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(rating.toString()),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _commentController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: "Describe your experience",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              _saveReview(userDetail, rating);
              Navigator.pop(context);
            },
            child: Text('Post'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _saveReview(userDetail, rating) {
    final comment = _commentController.text.trim();
    final userId = userDetail.id;
    final productId = widget.product.id;
    final review = Review(
      productId: productId!,
      userId: userId!,
      rating: rating.toString(),
      comment: comment,
    );
    saveReview(review, context);
  }

  Future<void> saveReview(Review review, BuildContext context) async {
    try {
      // Show a loading indicator while saving a supply
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );
      //request to the server
      final response = await post('review', review.toMap());
      if (response.data['success'] != null) {
        Navigator.pop(context);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Review Failed'),
            content: Text(
                'Oh no! It seems like there was an error while trying to submit your review for the product.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Handle network or server error
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Error'),
          content: Text(
              'An error occurred. Please check your internet connection and try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
