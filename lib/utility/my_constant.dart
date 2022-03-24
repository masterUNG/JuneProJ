import 'package:flutter/material.dart';

class MyConstant {
  static Color darkColor = const Color(0xff6d1163);
  static Color primaryColor = const Color(0xffd173c2);
  static Color lightColor = const Color(0xfffff7ff);
  static Color textColor = const Color.fromARGB(255, 15, 7, 14);

  TextStyle h1Style() => TextStyle(
        color: textColor,
        fontSize: 30,
        fontWeight: FontWeight.bold,
      );

  TextStyle h2Style() => TextStyle(
        color: textColor,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      );

  TextStyle h3Style() => TextStyle(
        color: textColor,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      );
}
