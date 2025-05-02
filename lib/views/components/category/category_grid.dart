// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_hive/controllers/category_notifier.dart';
import 'package:store_hive/models/category.dart';
import 'package:store_hive/services/request.dart';
import 'package:store_hive/views/components/category/category_detail.dart';
import 'package:store_hive/views/utils/constant.dart';

class CategoryGrid extends StatefulWidget {
  const CategoryGrid({super.key});

  @override
  State<CategoryGrid> createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isListView = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appBarBg,
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text(
          "Categories",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(isListView ? Icons.grid_view : Icons.list),
            onPressed: () {
              setState(() {
                isListView = !isListView;
              });
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          unselectedLabelStyle: TextStyle(color: Colors.white70),
          labelStyle: TextStyle(color: Colors.white),
          indicatorWeight: 3,
          tabs: const [
            Tab(text: "All Categories"),
            Tab(text: "Parent Categories"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // All Categories Tab
          isListView ? _buildListView() : _buildGridView(),

          // Parent Categories Tab
          _buildParentCategoriesView(),
        ],
      ),
    );
  }

  Widget _buildGridView() {
    return Consumer<CategoryNotifier>(
      builder: (context, categoryNotifier, child) {
        final categories = categoryNotifier.categoryList;
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return CategoryCard(
              category: category,
              onTap: () {
                _showCategoryDetails(category);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildListView() {
    return Consumer<CategoryNotifier>(
      builder: (context, categoryNotifier, child) {
        final categories = categoryNotifier.categoryList;
        return ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return ExpansionTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(baseUrl + category.icon!),
              ),
              title: Text(
                category.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(category.description),
              children: List.generate(
                category.children.length,
                (i) {
                  final child = category.children[i];
                  return ListTile(
                    contentPadding: const EdgeInsets.only(left: 32, right: 16),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(baseUrl + child.icon!),
                    ),
                    title: Text(
                      child.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(child.description),
                    onTap: () {
                      _showCategoryDetails(child);
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildParentCategoriesView() {
    return Consumer<CategoryNotifier>(
      builder: (context, categoryNotifier, child) {
        // Filter out only parent categories
        final parentCategories = categoryNotifier.categoryList
            .where((category) => category.parentId == null)
            .toList();

        return isListView
            ? ListView.builder(
                itemCount: parentCategories.length,
                itemBuilder: (context, index) {
                  final category = parentCategories[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(baseUrl + category.icon!),
                    ),
                    title: Text(
                      category.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(category.description),
                    trailing: category.children.isNotEmpty
                        ? const Icon(Icons.arrow_forward_ios)
                        : null,
                    onTap: () {
                      _showCategoryChildren(category);
                    },
                  );
                },
              )
            : GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: parentCategories.length,
                itemBuilder: (context, index) {
                  final category = parentCategories[index];
                  return CategoryCard(
                    category: category,
                    onTap: () {
                      _showCategoryChildren(category);
                    },
                    hasChildren: category.children.isNotEmpty,
                  );
                },
              );
      },
    );
  }

  void _showCategoryDetails(Category category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CategoryDetail(category: category),
      ),
    );
  }

  void _showCategoryChildren(Category parentCategory) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        parentCategory.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: parentCategory.children.length,
                      itemBuilder: (context, index) {
                        final child = parentCategory.children[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(baseUrl + child.icon!),
                          ),
                          title: Text(
                            child.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(child.description),
                          onTap: () {
                            Navigator.pop(context);
                            _showCategoryDetails(child);
                          },
                        );
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
}

class CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;
  final bool hasChildren;

  const CategoryCard({
    Key? key,
    required this.category,
    required this.onTap,
    this.hasChildren = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      baseUrl + category.icon!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(Icons.image_not_supported, size: 40),
                          ),
                        );
                      },
                    ),
                    if (hasChildren)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.subdirectory_arrow_right,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      category.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
