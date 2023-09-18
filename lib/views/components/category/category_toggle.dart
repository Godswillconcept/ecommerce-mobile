import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/category_notifier.dart';
import '../../../services/request.dart';
import 'category_detail.dart';

class CategoryToggle extends StatelessWidget {
  const CategoryToggle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryNotifier>(
      builder: (context, categoryNotifier, child) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              categoryNotifier.categoryList.length,
              (index) {
                final category = categoryNotifier.categoryList[index];
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
      },
    );
  }
}
