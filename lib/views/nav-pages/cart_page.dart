// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api, use_build_context_synchronously, avoid_print, unused_element

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lottie/lottie.dart';

import '../../controllers/cart_notifier.dart';
import '../../controllers/order_notifier.dart';
import '../../models/cart.dart';
import '../../models/order.dart';
import '../../models/user.dart';
import '../../services/request.dart';
import '../components/cart/cart_card.dart';
import '../components/cart/check_out_screen.dart';
import '../components/cart/empty_cart.dart';
import '../utils/constant.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

// Custom Widgets for Cart Page

class EmptyCartView extends StatelessWidget {
  const EmptyCartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
              width: 200,
              child: Lottie.network(
                'https://assets1.lottiefiles.com/packages/lf20_qh5z2fdq.json',
                repeat: true,
              ),
            ),
            Text(
              'Your Cart is Empty',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Looks like you haven\'t added any items to your cart yet.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: appBarBg,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/home");
              },
              child: Text(
                'Start Shopping',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedCartItem extends StatefulWidget {
  final dynamic product;
  final Function onDelete;
  final Function(int) onQuantityChanged;

  const AnimatedCartItem({
    super.key,
    required this.product,
    required this.onDelete,
    required this.onQuantityChanged,
  });

  @override
  State<AnimatedCartItem> createState() => _AnimatedCartItemState();
}

class _AnimatedCartItemState extends State<AnimatedCartItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8, left: 16, right: 16),
      child: Slidable(
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => widget.onDelete(),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Product Image
              ClipRRect(
                borderRadius:
                    BorderRadius.horizontal(left: Radius.circular(12)),
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[200],
                  child: widget.product.image != null
                      ? Image.network(
                          widget.product.image!,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, obj, stack) => Center(
                            child:
                                Icon(Icons.image, size: 40, color: Colors.grey),
                          ),
                        )
                      : Center(
                          child:
                              Icon(Icons.image, size: 40, color: Colors.grey),
                        ),
                ),
              ),

              // Product Details
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.product.brand != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            widget.product.brand!,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                        ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            "₦${widget.product.price}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: appBarBg,
                            ),
                          ),
                          Spacer(),
                          // Quantity Adjustment
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                _buildQuantityButton(
                                  icon: Icons.remove,
                                  onPressed: () {
                                    if (widget.product.quantity! > 1) {
                                      widget.onQuantityChanged(
                                          widget.product.quantity! - 1);
                                    }
                                  },
                                ),
                                Container(
                                  width: 30,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${widget.product.quantity}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                _buildQuantityButton(
                                  icon: Icons.add,
                                  onPressed: () {
                                    widget.onQuantityChanged(
                                        widget.product.quantity! + 1);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityButton(
      {required IconData icon, required Function() onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: SizedBox(
        width: 28,
        height: 28,
        child: Icon(icon, size: 18),
      ),
    );
  }
}

class CartSummary extends StatelessWidget {
  final double total;
  final int itemCount;
  final bool isProcessing;
  final VoidCallback onCheckout;
  final AnimationController controller;

  const CartSummary({
    super.key,
    required this.total,
    required this.itemCount,
    required this.isProcessing,
    required this.onCheckout,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      padding: EdgeInsets.all(20),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Order Summary
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '₦${total.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Items',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '$itemCount',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Divider(),
            SizedBox(height: 12),
            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '₦${total.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: appBarBg,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Checkout Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appBarBg,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                    ),
                    onPressed: isProcessing ? null : onCheckout,
                    child: isProcessing
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'CHECKOUT',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward),
                            ],
                          ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartPageState extends State<CartPage> with TickerProviderStateMixin {
  final _userBox = Hive.box<User>("userBox");
  bool _isProcessing = false;
  late AnimationController _checkoutButtonController;

  @override
  void initState() {
    super.initState();
    _checkoutButtonController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _checkoutButtonController.dispose();
    super.dispose();
  }

  Future _checkOutModal(context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.85,
          child: CheckOutScreen(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _userBox.getAt(0);

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F8),
      appBar: AppBar(
        backgroundColor: appBarBg,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "My Cart",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 1,
          ),
        ),
        actions: [
          Consumer<CartNotifier>(
            builder: (context, cartNotifier, _) {
              if (cartNotifier.cartProducts.isNotEmpty) {
                return IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.white),
                  onPressed: () => _confirmClearCart(context),
                );
              }
              return SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<CartNotifier>(
        builder: (context, cartNotifier, child) {
          final productList = cartNotifier.cartProducts;

          if (productList.isEmpty) {
            return EmptyCartView();
          }

          return Stack(
            children: [
              Column(
                children: [
                  // Cart Items List
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 140),
                      itemCount: productList.length,
                      itemBuilder: (context, index) {
                        final product = productList[index];
                        return AnimatedCartItem(
                          product: product,
                          onDelete: () => cartNotifier.removeProduct(product),
                          onQuantityChanged: (quantity) {
                            cartNotifier.updateQuantity(product, quantity);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),

              // Bottom Checkout Area
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: CartSummary(
                  total: cartNotifier.total,
                  itemCount: cartNotifier.cartProducts.length,
                  isProcessing: _isProcessing,
                  onCheckout: () => _saveOrder(user, cartNotifier),
                  controller: _checkoutButtonController,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _confirmClearCart(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Clear Cart'),
          content:
              Text('Are you sure you want to remove all items from your cart?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                context.read<CartNotifier>().clearCart();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Cart cleared'),
                    behavior: SnackBarBehavior.floating,
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              child: Text('CLEAR', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _saveOrder(User? user, CartNotifier cartNotifier) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    _checkoutButtonController.forward();

    try {
      final user = _userBox.values.elementAt(0);
      final cart = Cart(products: cartNotifier.cartProducts);
      final total = cart.total;
      final userId = user.id;
      final products = cart.products;
      final productIds = cart.products.map((product) => product.id).toList();
      final quantities =
          cart.products.map((product) => product.quantity).toList();
      final details = List<Detail>.generate(
        productIds.length,
        (index) => Detail(
          productId: productIds[index]!,
          quantity: quantities[index]!,
          product: products[index],
        ),
      );

      final order = Order(
        userId: userId!,
        total: total.toString(),
        detail: details,
      );

      await saveOrder(order, context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating order: $e'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isProcessing = false;
      });
      _checkoutButtonController.reverse();
    }
  }

  Future<void> saveOrder(Order order, BuildContext context) async {
    try {
      final response = await post('order', order.toMap());

      if (response.data['success'] != null) {
        // Order successful
        context.read<CartNotifier>().clearCart();
        order = Order.fromMap(response.data['success']);
        context.read<OrderNotifier>().addOrder(order);

        // Show success feedback
        _showOrderSuccess(context);
      } else {
        _showOrderError(context);
      }
    } catch (e) {
      _showOrderError(context);
    } finally {
      setState(() {
        _isProcessing = false;
      });
      _checkoutButtonController.reverse();
    }
  }

  void _showOrderSuccess(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Lottie.network(
                    'https://assets9.lottiefiles.com/packages/lf20_kc9reuv8.json',
                    repeat: false,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Order Placed!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Your order has been successfully placed.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appBarBg,
                    minimumSize: Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, "/orders");
                  },
                  child: Text('View My Orders'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showOrderError(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Order Failed'),
        content: Text(
          'Oh no! It seems like there was an error while trying to submit your order. Please try again.',
        ),
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
