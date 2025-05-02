// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, library_private_types_in_public_api, unused_local_variable

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:store_hive/models/user.dart';
import 'package:store_hive/services/request.dart';
import 'package:store_hive/views/utils/constant.dart';
import 'package:store_hive/views/utils/numeric_helper.dart'; // Import the numeric helper

import '../../controllers/order_notifier.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> with TickerProviderStateMixin {
  String _activeButton = "all_orders";
  final _userBox = Hive.box<User>("userBox");
  late TabController _tabController;
  bool _isLoading = true;
  final currencyFormatter =
      NumberFormat.currency(locale: 'en_US', symbol: '\$');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        switch (_tabController.index) {
          case 0:
            _activeButton = "all_orders";
            break;
          case 1:
            _activeButton = "pending";
            break;
          case 2:
            _activeButton = "processing";
            break;
          case 3:
            _activeButton = "delivered";
            break;
        }
      });
    });

    // Simulate loading orders
    Future.delayed(Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = _userBox.get(0); // Get the authenticated user
    final orders = Provider.of<OrderNotifier>(context, listen: false).orderList;

    // Filter orders for the current authenticated user
    final userOrders = currentUser != null
        ? orders.where((order) => order.userId == currentUser.id).toList()
        : [];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(currentUser),
            _buildTabBar(),
            Expanded(
              child: _isLoading
                  ? _buildLoadingIndicator()
                  : userOrders.isEmpty
                      ? _buildEmptyState()
                      : _buildOrderList(userOrders),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(User? user) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: Offset(0, 2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "My Orders",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: appBarBg,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    user != null
                        ? "Welcome back, ${user.name}"
                        : "Hello, Guest",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              CircleAvatar(
                backgroundColor: appBarBg.withOpacity(0.1),
                radius: 24,
                child: user != null && user.image != null
                    ? CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(
                          baseUrl + user.image!,
                        ),
                      )
                    : Image.asset(
                        "images/profile.png",
                        width: 36,
                        height: 36,
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: appBarBg,
        unselectedLabelColor: Colors.grey,
        indicatorColor: appBarBg,
        indicatorWeight: 3,
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        tabs: [
          Tab(text: "All"),
          Tab(text: "Pending"),
          Tab(text: "Processing"),
          Tab(text: "Delivered"),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(appBarBg),
          ),
          SizedBox(height: 20),
          Text(
            "Loading your orders...",
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            "No orders found",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Start shopping to see your orders here",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Navigate to shop/products page
              Navigator.pushNamed(context, '/shop');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: appBarBg,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "Browse Products",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList(List userOrders) {
    // Select the filtered orders based on the active tab
    var filteredOrders = userOrders;

    switch (_activeButton) {
      case "pending":
        filteredOrders =
            userOrders.where((x) => x.status == "Pending").toList();
        break;
      case "processing":
        filteredOrders =
            userOrders.where((x) => x.status == "Processing").toList();
        break;
      case "delivered":
        filteredOrders =
            userOrders.where((x) => x.status == "Delivered").toList();
        break;
      default:
        // all_orders - keep the original list
        break;
    }

    if (filteredOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/empty_order.png', // Make sure to add this asset
              width: 120,
              height: 120,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.receipt_long,
                size: 80,
                color: Colors.grey[300],
              ),
            ),
            SizedBox(height: 16),
            Text(
              _getEmptyStateTitle(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Check other categories or place new orders",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        final order = filteredOrders[index];
        return _buildOrderCard(order);
      },
    );
  }

  String _getEmptyStateTitle() {
    switch (_activeButton) {
      case "pending":
        return "No pending orders";
      case "processing":
        return "No processing orders";
      case "delivered":
        return "No delivered orders";
      default:
        return "No orders found";
    }
  }

  Widget _buildOrderCard(dynamic order) {
    // Calculate total items
    int totalItems = order.detail.length;

    // Format order date
    String formattedDate = "N/A";
    if (order.orderDate != null) {
      try {
        DateTime orderDate = order.orderDate;
        formattedDate = DateFormat('MMM dd, yyyy').format(orderDate);
      } catch (e) {
        formattedDate = "Date unavailable";
      }
    }

    // Status color
    Color statusColor;
    switch (order.status) {
      case "Pending":
        statusColor = Colors.orange;
        break;
      case "Processing":
        statusColor = Colors.blue;
        break;
      case "Delivered":
        statusColor = Colors.green;
        break;
      default:
        statusColor = Colors.grey;
    }

    // Safely get the total using numeric helper
    final orderTotal = toDouble(order.total);

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to order details
          // Navigator.pushNamed(context, '/order-details', arguments: order);
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order #${order.id}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      order.status ?? "Unknown",
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildOrderContent(order),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "$totalItems ${totalItems > 1 ? 'items' : 'item'}",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      // Use formatCurrency helper instead of direct formatting
                      Text(
                        formatCurrency(order.total),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: appBarBg,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(height: 1),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      // Show order details
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: appBarBg),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Details",
                      style: TextStyle(
                        color: appBarBg,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  if (order.status == "Delivered")
                    ElevatedButton(
                      onPressed: () {
                        // Reorder functionality
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appBarBg,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text("Reorder"),
                    ),
                  if (order.status == "Pending")
                    ElevatedButton(
                      onPressed: () {
                        // Track order functionality
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appBarBg,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text("Track"),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderContent(dynamic order) {
    // Limit to first 3 products
    final displayedItems =
        order.detail.length > 3 ? order.detail.sublist(0, 3) : order.detail;
    final remainingItems = order.detail.length - displayedItems.length;

    return Column(
      children: [
        ...displayedItems.map((detail) => _buildProductItem(detail)).toList(),
        if (remainingItems > 0)
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              "+ $remainingItems more ${remainingItems > 1 ? 'items' : 'item'}",
              style: TextStyle(
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProductItem(dynamic detail) {
    // Safely get price using numeric helper
    final productPrice = toDouble(detail.product.price);
    final quantity = toDouble(detail.quantity);

    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
              image: detail.product.image != null
                  ? DecorationImage(
                      image: NetworkImage(baseUrl + detail.product.image),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: detail.product.image == null
                ? Icon(Icons.image_not_supported, color: Colors.grey)
                : null,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detail.product.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  "Qty: ${detail.quantity} × ${formatCurrency(detail.product.price)}",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
