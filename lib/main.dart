import 'package:espaco_cafe_restaurante/login.dart';
import 'package:flutter/material.dart';

void main() {

  final ThemeData theme = ThemeData(fontFamily: 'Baloo');
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Login(),
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          primary: const Color(0xffD6B9AC),
          secondary: const Color(0xff743C29),
        ),
      ),
    )
  );
}
