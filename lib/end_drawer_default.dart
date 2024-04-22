import 'package:espaco_cafe_restaurante/route_generator.dart';
import 'package:flutter/material.dart';

class EndDrawerDefault {

  static Widget _construirTextMenu(String titulo) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        titulo,
        style: const TextStyle(
          color: Color(0xffEA8C2F),
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }

  static Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.83,
      child: Drawer(
        elevation: 16,
        child: ListView(
          padding: EdgeInsets.all(25),
          children: <Widget>[
            const Padding(padding: EdgeInsets.only(top: 40)),
            ListTile(
              title:  _construirTextMenu("Produtos"),
              trailing: const Icon(Icons.qr_code_2, color: Color(0xffEA8C2F)),
              onTap: () {
                Navigator.pushNamed(context, RouteGenerator.PRODUTOS);
              },
            ),
            ListTile(
              title:  _construirTextMenu("Fornecedores"),
              trailing: const Icon(Icons.people_outline, color: Color(0xffEA8C2F)),
              onTap: () {
                Navigator.pushNamed(context, RouteGenerator.FORNECEDORES);
              },
            ),
            ListTile(
              title:  _construirTextMenu("Usuários"),
              trailing: const Icon(Icons.person_2_outlined, color: Color(0xffEA8C2F)),
              onTap: () {

              },
            ),
          ],
        ),
      ),
    );
  }

}