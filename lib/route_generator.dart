import 'package:espaco_cafe_restaurante/lista_compras.dart';
import 'package:espaco_cafe_restaurante/login.dart';
import 'package:flutter/material.dart';

class RouteGenerator {

  static const RAIZ = "/";
  static const LOGIN = "/login";
  static const LISTA_COMRPAS = "/listaCompras";

  static Route<dynamic> generateRoute(RouteSettings settings) {

    switch(settings.name) {
      case RAIZ:
        return MaterialPageRoute(builder: (_) => const Login());
      case LOGIN:
        return MaterialPageRoute(builder: (_) => const Login());
      case LISTA_COMRPAS:
        return MaterialPageRoute(builder: (_) => const ListaCompras());
      default:
        return  _erroRota();
    }
  }

  static Route<dynamic> _erroRota() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Tela não encontrada!"),
        ),
        body: const Center(
          child: Text("Tela não encontrada!"),
        ),
      );
    });
  }
}