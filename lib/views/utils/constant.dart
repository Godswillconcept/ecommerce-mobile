// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

var appBarBg =  const Color(0xff0b63f6);
var bodyBg = const Color.fromARGB(255, 226, 239, 250);

class AppColors {
  static const Color primaryColor = Color(0xffe1f8ec);
  static const Color secondaryColor = Color(0xff46c68f);
  static const Color backgroundColor = Color(0xff13af9d);
  static const Color mainColor = Color(0xff03893a);
  static const Color auxColor = Color(0xff99c56c);
  static const Color textColor = Color(0xff1e4437);
}

class AppLargeText extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  const AppLargeText({
    super.key,
    required this.text,
    required this.color,
    this.size = 30.0,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.bold,
        fontSize: size,
      ),
    );
  }
}

class AppText extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  const AppText(
      {super.key, required this.text, required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: size,
      ),
    );
  }
}

class DynamicButton extends StatelessWidget {
  final String text;
  final double width;
  bool? isResponsive;
  final void Function()? onPressed;
  DynamicButton({
    super.key,
    required this.text,
    this.isResponsive = false,
    required this.onPressed,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Container(
        width: width,
        height: 50,
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: AppColors.mainColor,
        ),
        child: Center(
          child: AppText(
            text: text,
            color: Colors.white,
            size: 18.0,
          ),
        ),
      ),
    );
  }
}
