// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api

import 'dart:math';

import 'package:hive/hive.dart';
import 'package:store_hive/models/user.dart';
import 'package:store_hive/services/request.dart';
import 'package:store_hive/views/components/search/search_box.dart';
import 'package:flutter/material.dart';
import 'package:store_hive/views/utils/cached_image.dart';
import '../components/category/category_grid.dart';
import '../components/category/category_toggle.dart';
import '../components/deal/hot_deal_view.dart';
import '../components/deal/deal_grid.dart';
import '../utils/new_arrivals.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  // Define consistent colors for the theme
  final Color primaryColor = Color(0xff0b63f6);
  final Color secondaryColor = Color(0xff003cc5);
  final Color surfaceColor = Colors.white;
  final Color backgroundColor = Color(0xFFF5F7FA);
  final Color textPrimaryColor = Color(0xFF2A2D34);
  final Color textSecondaryColor = Color(0xFF6C757D);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: buildAppbar(context),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search container
            _buildSearchContainer(size),

            // Main content
            Expanded(
              child: _buildMainContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchContainer(Size size) {
    return Container(
      height: size.height * 0.08,
      decoration: BoxDecoration(
        color: primaryColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: _buildSearchBar(),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => SearchBox()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: textSecondaryColor,
                ),
                SizedBox(width: 12),
                Text(
                  'Search for products...',
                  style: TextStyle(
                    color: textSecondaryColor,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24),

              // Categories Section
              _buildSectionHeader(
                title: 'Categories',
                onSeeAllPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CategoryGrid()),
                  );
                },
              ),
              SizedBox(height: 16),
              _buildCategoriesSection(),

              SizedBox(height: 24),

              // Featured Banner
              _buildFeaturedBanner(),

              SizedBox(height: 24),

              // New Arrivals Section
              _buildSectionHeader(
                title: 'New Arrivals',
                onSeeAllPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => HotDealView()),
                  );
                },
              ),
              SizedBox(height: 16),
              _buildNewArrivalsSection(),

              SizedBox(height: 24),

              // Hot Deals Section
              _buildSectionHeader(
                title: 'Hot Deals',
                onSeeAllPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => HotDealView()),
                  );
                },
              ),
              SizedBox(height: 16),
              _buildHotDealsSection(),

              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required VoidCallback onSeeAllPressed,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textPrimaryColor,
          ),
        ),
        TextButton(
          onPressed: onSeeAllPressed,
          style: TextButton.styleFrom(
            foregroundColor: primaryColor,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'See All',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: CategoryToggle(),
    );
  }

  Widget _buildFeaturedBanner() {
    return BannerCachedImage(
      imageUrl: "https://picsum.photos/id/${Random().nextInt(1000)}/1080/720",
      height: 180,
      borderRadius: 16,
      overlayContent: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.7),
            ],
          ),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Summer Collection',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Discover our latest trends',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
              ),
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Shop Now',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewArrivalsSection() {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: NewArrivals(),
    );
  }

  Widget _buildHotDealsSection() {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: DealGrid(),
    );
  }
}

AppBar buildAppbar(BuildContext context) {
  final userInfo = Hive.box<User>("userBox");
  final userDetail = userInfo.values.elementAt(0);

  final Color appBarColor = Color(0xff0b63f6);

  return AppBar(
    elevation: 0,
    backgroundColor: appBarColor,
    foregroundColor: Colors.white,
    toolbarHeight: 70,
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hey ${userDetail.name.split(' ')[0]}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'What are you looking for today?',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    ),
    leading: Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, '/profile'),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: CircularCachedImage(
            imageUrl: baseUrl + userDetail.image!,
            size: 36,
            shimmerBaseColor: Colors.blue[100],
            shimmerHighlightColor: Colors.white,
          ),
        ),
      ),
    ),
    actions: [
      Stack(
        alignment: Alignment.center,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
            icon: Icon(
              Icons.notifications_outlined,
              size: 28,
            ),
            padding: EdgeInsets.all(12),
          ),
          Positioned(
            top: 14,
            right: 12,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: BoxConstraints(
                minWidth: 12,
                minHeight: 12,
              ),
              child: Text(
                '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
      SizedBox(width: 8),
    ],
  );
}
