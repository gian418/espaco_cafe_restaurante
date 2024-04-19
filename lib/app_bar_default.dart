import 'package:flutter/material.dart';

class AppBarDefault {

  static AppBar build() {
    return AppBar(
      title: Image.asset("images/logo_appbar.png"),
      backgroundColor: const Color(0xffD6B9AC),
    );
  }
}