// ignore_for_file: prefer_const_constructors

import 'package:store_hive/views/components/search/search_page.dart';
import 'package:flutter/material.dart';

import '../../utils/constant.dart';

class SearchBox extends StatefulWidget {
  const SearchBox({
    super.key,
  });

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final TextEditingController _searchController = TextEditingController();

  void performSearch(String query, BuildContext context) {
    debugPrint("Performing search for $query");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return SearchPage(search: query);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextFormField(
        controller: _searchController,
        onEditingComplete: () {
          String query = _searchController.text.trim();
          performSearch(query, context);
        },
        // style: TextStyle(color: Colors.blac),
        textInputAction: TextInputAction.search,

        decoration: InputDecoration(
          filled: true,
          fillColor: bodyBg,
          hintText: "Search...",
          hintStyle: TextStyle(
            color: Colors.blue.shade400,
          ),
          prefixIcon: Icon(Icons.search, color: Colors.blue.shade400),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent.shade700),
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent.shade700),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
