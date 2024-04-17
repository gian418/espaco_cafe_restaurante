import 'package:espaco_cafe_restaurante/firebase_options.dart';
import 'package:espaco_cafe_restaurante/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {

  //Inicializa o Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      initialRoute: "/",
    )
  );
}
