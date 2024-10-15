// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_const_literals_to_create_immutables

import 'nested_expansion_tile.dart';
import 'package:store_hive/views/utils/constant.dart';
import 'package:flutter/material.dart';

class CategoryGrid extends StatefulWidget {
  const CategoryGrid({super.key});

  @override
  State<CategoryGrid> createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appBarBg,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
          title: Text(
            "Categories",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        body: NestedExpansionTile()
        // body: Consumer<CategoryNotifier>(
        //   builder: (context, categoryNotifier, child) {
        //     final baseCategories = categoryNotifier.categoryList;
        //     return ListView.builder(
        //         itemCount: 1,
        //         itemBuilder: (BuildContext context, int i) {
        //           final childrenCategory = baseCategories[i];
        //           return ExpansionTile(
        //             leading: CircleAvatar(
        //               backgroundImage: NetworkImage(baseUrl + childrenCategory.icon!),
        //             ),
        //             title: Text(
        //               childrenCategory.name,
        //               style: TextStyle(
        //                 fontSize: 18,
        //                 fontWeight: FontWeight.bold,
        //               ),
        //             ),
        //             subtitle: Text(childrenCategory.description),
        //             children: List.generate(
        //               childrenCategory.children.length,
        //               (i) {
        //                 final child = childrenCategory.children[i];
        //                 return ListTile(
        //                   leading: CircleAvatar(
        //                     backgroundImage: NetworkImage(baseUrl + child.icon!),
        //                   ),
        //                   title: Text(
        //                     child.name,
        //                     style: TextStyle(fontWeight: FontWeight.bold),
        //                   ),
        //                   subtitle: Text(child.description),
        //                   onTap: () {
        //                     // Navigator.of(context).push(
        //                     //   MaterialPageRoute(
        //                     //     builder: (context) {
        //                     //       return CategoryDetail(category: child);
        //                     //     },
        //                     //   ),
        //                     // );
        //                   },
        //                 );
        //               },
        //             ),
        //           );
        //         });
        //   },
        // ),
        );
  }
}
