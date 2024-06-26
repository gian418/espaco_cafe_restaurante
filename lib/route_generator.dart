import 'package:espaco_cafe_restaurante/cadastro_lista_compra.dart';
import 'package:espaco_cafe_restaurante/fornecedores.dart';
import 'package:espaco_cafe_restaurante/lista_compras.dart';
import 'package:espaco_cafe_restaurante/login.dart';
import 'package:espaco_cafe_restaurante/model/listas_compra.dart';
import 'package:espaco_cafe_restaurante/produtos.dart';
import 'package:flutter/material.dart';

class RouteGenerator {

  static const RAIZ = "/";
  static const LOGIN = "/login";
  static const LISTA_COMRPAS = "/listaCompras";
  static const PRODUTOS = "/produtos";
  static const FORNECEDORES = "/fornecedores";
  static const CADASTRO_LISTA_COMPRA = "/cadastroListaCompra";

  static Route<dynamic> generateRoute(RouteSettings settings) {

    final args = settings.arguments;

    switch(settings.name) {
      case RAIZ:
        return MaterialPageRoute(builder: (_) => const Login());
      case LOGIN:
        return MaterialPageRoute(builder: (_) => const Login());
      case LISTA_COMRPAS:
        return MaterialPageRoute(builder: (_) => const ListaCompras());
      case PRODUTOS:
        return MaterialPageRoute(builder: (_) => const Produtos());
      case FORNECEDORES:
        return MaterialPageRoute(builder: (_) => const Fornecedores());
      case CADASTRO_LISTA_COMPRA:
        return MaterialPageRoute(builder: (_) => CadastroListaCompra(lista: args as ListasCompra?));
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