import 'package:flutter/material.dart';

class ListaCompras extends StatefulWidget {
  const ListaCompras({super.key});

  @override
  State<ListaCompras> createState() => _ListaComprasState();
}

class _ListaComprasState extends State<ListaCompras> {

  Widget _construirTextMenu(String titulo) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("images/logo_appbar.png"),
        backgroundColor: const Color(0xffD6B9AC),
      ),
      endDrawer: Opacity(
        opacity: 0.83,
        child: Drawer(
          elevation: 16,
          child: ListView(
            padding: EdgeInsets.all(25),
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 40)),
              ListTile(
                title: _construirTextMenu("Lista de Compras"),
                trailing: Icon(Icons.checklist, color: Color(0xffEA8C2F)),
                onTap: () {

                },
              ),
              ListTile(
                title:  _construirTextMenu("Produtos"),
                trailing: Icon(Icons.qr_code_2, color: Color(0xffEA8C2F)),
                onTap: () {

                },
              ),
              ListTile(
                title:  _construirTextMenu("Fornecedores"),
                trailing: Icon(Icons.people_outline, color: Color(0xffEA8C2F)),
                onTap: () {

                },
              ),
              ListTile(
                title:  _construirTextMenu("Usuários"),
                  trailing: Icon(Icons.person_2_outlined, color: Color(0xffEA8C2F)),
                onTap: () {

                },
              ),
            ],
          ),
        ),
      ),
      body: Container(),
    );
  }
}
