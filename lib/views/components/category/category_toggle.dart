import 'package:ecommerce/models/category.dart';
import 'package:flutter/material.dart';
import '../../../services/request.dart';
import 'category_detail.dart';

class CategoryToggle extends StatefulWidget {
  const CategoryToggle({
    super.key,
  });

  @override
  State<CategoryToggle> createState() => _CategoryToggleState();
}

class _CategoryToggleState extends State<CategoryToggle> {
  List categoryList = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    get('parent-categories').then((categoryResponse) {
      setState(() {
        categoryList =
            categoryResponse.data.map((e) => Category.fromMap(e)).toList();
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          categoryList.length,
          (index) {
            final category = categoryList[index];
            return Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return CategoryDetail(category: category);
                      },
                    ),
                  );
                },
                child: Chip(
                  label: Text(
                    category.name,
                    style: TextStyle(
                      color: Colors.blue.shade400,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  avatar: CircleAvatar(
                    backgroundImage: NetworkImage(baseUrl + category.icon!),
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
