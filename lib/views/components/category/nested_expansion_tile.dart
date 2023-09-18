// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:ecommerce/controllers/category_notifier.dart';
import 'package:provider/provider.dart';
import '../../../../services/request.dart';
import '../../../models/category.dart';
import 'package:ecommerce/views/components/category/category_detail.dart';

class NestedExpansionTile extends StatelessWidget {
  const NestedExpansionTile({super.key});


  @override
  Widget build(BuildContext context) {

    return Consumer<CategoryNotifier>(
      builder: (context, categoryNotifier, child) {
        final categories = categoryNotifier.categoryList;
        return ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return buildExpansionTiles(category, context);
          },
         
        );
      },
    );
  }
}

Widget buildExpansionTiles(Category category, BuildContext context) {
  return ExpansionTile(
    leading: CircleAvatar(
      backgroundImage: NetworkImage(baseUrl + category.icon!),
    ),
    title: Text(category.name),
    subtitle: Text(category.description),
    children: category.children.map<Widget>((child) {
      if (child.children.isNotEmpty) {
        return buildExpansionTiles(child, context);
      } else {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(baseUrl + child.icon!),
          ),
          title: Text(child.name),
          subtitle: Text(child.description),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return CategoryDetail(category: child);
                },
              ),
            );
          },
          // Add any other properties you want for the leaf nodes
        );
      }
    }).toList(),
  );
}
