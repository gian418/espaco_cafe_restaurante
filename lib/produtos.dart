import 'package:espaco_cafe_restaurante/app_bar_default.dart';
import 'package:flutter/material.dart';

class Produtos extends StatefulWidget {
  const Produtos({super.key});

  @override
  State<Produtos> createState() => _ProdutosState();
}

class _ProdutosState extends State<Produtos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault.build(),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Text("PRODUTOS"),
      ),
    );
  }
}
