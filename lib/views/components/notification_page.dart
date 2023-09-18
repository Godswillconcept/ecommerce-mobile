// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        centerTitle: true,
      ),
      body: ListView.separated(
          itemBuilder: (context, i) {
            return ListTile(
              title: Text("data"),
              subtitle: Text("data"),
              trailing: Text("data"),
            );
          },
          separatorBuilder: (context, i) {
            return Divider();
          },
          itemCount: 5),
    );
  }
}
