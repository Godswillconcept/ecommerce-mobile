// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors

import 'package:store_hive/models/product.dart';
import 'package:store_hive/services/request.dart';
import 'package:flutter/material.dart';
import 'package:store_hive/views/utils/constant.dart';
import '../components/deal/product_card.dart';
import '../components/products/product_detail.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>
    with SingleTickerProviderStateMixin {
  List productList = [];
  List filteredProducts = [];
  bool loading = true;
  TabController? _tabController; // Changed from late to nullable
  String _selectedCategory = "All";
  final TextEditingController _searchController = TextEditingController();
  bool _showSearchBar = false;
  String _searchQuery = "";

  final List<String> _categories = [
    "All",
    "Electronics",
    "Clothing",
    "Home",
    "Beauty",
    "Sports",
    "Books",
  ];

  @override
  void initState() {
    super.initState();
    // Initialize the tab controller in initState
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController?.addListener(_handleTabSelection);

    _searchController.addListener(() {
      if (mounted) {
        setState(() {
          _searchQuery = _searchController.text;
          _filterProducts();
        });
      }
    });

    _fetchProducts();
  }

  void _handleTabSelection() {
    if (_tabController != null && _tabController!.indexIsChanging && mounted) {
      setState(() {
        _selectedCategory = _categories[_tabController!.index];
        _filterProducts();
      });
    }
  }

  void _filterProducts() {
    if (!mounted) return;

    setState(() {
      filteredProducts = productList.where((product) {
        // First apply category filter (if not "All")
        bool categoryMatch = _selectedCategory == "All" ||
            (product.category != null &&
                product.category.toLowerCase() ==
                    _selectedCategory.toLowerCase());

        // Then apply search filter if there's a query
        bool searchMatch = _searchQuery.isEmpty ||
            product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (product.description != null &&
                product.description
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()));

        return categoryMatch && searchMatch;
      }).toList();
    });
  }

  Future<void> _fetchProducts() async {
    try {
      final productResponse = await get('products');
      if (mounted) {
        setState(() {
          productList =
              productResponse.data.map((e) => Product.fromMap(e)).toList();
          filteredProducts = List.from(productList);
          loading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load products. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _tabController?.dispose(); // Safe disposal with null check
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Guard against tabController not being initialized
    if (_tabController == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: _showSearchBar
            ? TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white70),
                ),
                style: TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                autofocus: true,
              )
            : Text("Products", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: appBarBg,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_showSearchBar ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_showSearchBar) {
                  _searchController.clear();
                  _searchQuery = "";
                  _filterProducts();
                }
                _showSearchBar = !_showSearchBar;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog();
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorColor: Colors.white,
            unselectedLabelStyle: TextStyle(color: Colors.white70),
            labelStyle: TextStyle(color: Colors.white),
            indicatorWeight: 3,
            tabs: _categories.map((category) => Tab(text: category)).toList(),
          ),
        ),
      ),
      body: loading ? _buildLoadingView() : _buildProductGrid(),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(appBarBg),
          ),
          SizedBox(height: 16),
          Text(
            "Loading products...",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyStateView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            "No products found",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty
                ? "Try a different search term"
                : "Try selecting a different category",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            icon: Icon(Icons.refresh),
            label: Text("Refresh"),
            style: ElevatedButton.styleFrom(
              backgroundColor: appBarBg,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            onPressed: () {
              setState(() {
                loading = true;
                _searchController.clear();
                _searchQuery = "";
                _tabController?.animateTo(0);
                _selectedCategory = "All";
              });
              _fetchProducts();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    if (filteredProducts.isEmpty) {
      return _buildEmptyStateView();
    }

    return Column(
      children: [
        if (filteredProducts.isNotEmpty) _buildFeaturedProduct(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                loading = true;
              });
              await _fetchProducts();
            },
            child: GridView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (BuildContext context, int i) {
                final product = filteredProducts[i];
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
                  ),
                );
              },
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                childAspectRatio: 2 / 3,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedProduct() {
    // Check if there are any products before trying to display a featured one
    if (filteredProducts.isEmpty) return SizedBox();

    // Get a random featured product or the first product
    final featuredProduct = filteredProducts[0];

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductDetail(product: featuredProduct),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(16),
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
          image: DecorationImage(
            image: NetworkImage(baseUrl + (featuredProduct.image ?? "")),
            fit: BoxFit.cover,
            onError: (error, stackTrace) {
              // Handle image loading errors
            },
          ),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "Featured Product",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    featuredProduct.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "\$${featuredProduct.price}",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Filter Products",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Sort By",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildFilterChip("Price: Low to High", () {
                        setState(() {
                          filteredProducts.sort((a, b) {
                            double priceA =
                                double.tryParse(a.price.toString()) ?? 0.0;
                            double priceB =
                                double.tryParse(b.price.toString()) ?? 0.0;
                            return priceA.compareTo(priceB);
                          });
                        });
                        Navigator.pop(context);
                      }),
                      _buildFilterChip("Price: High to Low", () {
                        setState(() {
                          filteredProducts.sort((a, b) {
                            double priceA =
                                double.tryParse(a.price.toString()) ?? 0.0;
                            double priceB =
                                double.tryParse(b.price.toString()) ?? 0.0;
                            return priceB.compareTo(priceA);
                          });
                        });
                        Navigator.pop(context);
                      }),
                      _buildFilterChip("Alphabetical", () {
                        setState(() {
                          filteredProducts.sort((a, b) => a.name
                              .toLowerCase()
                              .compareTo(b.name.toLowerCase()));
                        });
                        Navigator.pop(context);
                      }),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Categories",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _categories
                        .map((category) => ChoiceChip(
                              label: Text(category),
                              selected: _selectedCategory == category,
                              onSelected: (selected) {
                                if (selected) {
                                  int index = _categories.indexOf(category);
                                  _tabController?.animateTo(index);
                                  Navigator.pop(context);
                                }
                              },
                            ))
                        .toList(),
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appBarBg,
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text("Apply Filters"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onTap) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
    );
  }
}
