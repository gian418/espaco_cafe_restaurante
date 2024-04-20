import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:espaco_cafe_restaurante/app_bar_default.dart';
import 'package:espaco_cafe_restaurante/end_drawer_default.dart';
import 'package:espaco_cafe_restaurante/model/listas_compra.dart';
import 'package:flutter/material.dart';

class ListaCompras extends StatefulWidget {
  const ListaCompras({super.key});

  @override
  State<ListaCompras> createState() => _ListaComprasState();
}

class _ListaComprasState extends State<ListaCompras> {
  final List<String> statusList = ["Enviada", "Pendente", "Cancelada"];
  List<String> statusSelecionados = ["Pendente"];
  late Stream<List<ListasCompra>> _streamListasCompras;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<ListasCompra>> _carregarListasCompras() {
    return _firestore
        .collection("ListasCompras")
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) {
            var lista = ListasCompra();
            lista.id = doc.id;
            lista.data = doc.get("dataCriacao");
            lista.descricao = doc.get("descricao");
            lista.status = doc.get("status");
            return lista;
          })
          .where((lista) => statusSelecionados.contains(lista.status))
          .toList();
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Enviada":
        return Colors.green;
      case "Pendente":
        return Colors.orange;
      case "Cancelada":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget criarItemStreamBuilder(context, indice, ListasCompra lista) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xffD6B9AC),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Dismissible(
        key: Key(DateTime.now().microsecondsSinceEpoch.toString()),
        direction: DismissDirection.horizontal,
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) {
            FirebaseFirestore firestore = FirebaseFirestore.instance;

            Map<String, dynamic> atualizarStatusLista = {
              "status" : "Cancelada"
            };

            firestore.collection("ListasCompras")
            .doc(lista.id)
            .update(atualizarStatusLista)
            .then((_) => {
              setState((){
                lista.status = "Cancelada";
              })
            });
          }

          if (direction == DismissDirection.startToEnd) {
            //Enviar para fornecedor. Se estiver cancelada ou enviada nao enviar.
          }
        },
        background: Container(
          color: Colors.green,
          padding: const EdgeInsets.all(16),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.send,
                color: Colors.white,
              ),
            ],
          ),
        ),
        secondaryBackground: Container(
          color: Colors.red,
          padding: const EdgeInsets.all(16),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.cancel_outlined,
                color: Colors.white,
              ),
            ],
          ),
        ),
        child: Card(
          color: const Color(0xffD6B9AC),
          elevation: 0, // Remove a elevação do Card para que ele não se sobreponha ao Container exterior
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  lista.data,
                  style: const TextStyle(
                      color: Color.fromRGBO(116, 60, 41, 1),
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(lista.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    lista.status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            subtitle: Text(
              lista.descricao,
              style: const TextStyle(
                color: Color.fromRGBO(116, 60, 41, 1),
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    _streamListasCompras = _carregarListasCompras();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBarDefault.build(),
      endDrawer: EndDrawerDefault.build(context),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.center,
              width: double.infinity,
              color: const Color.fromRGBO(214, 185, 172, 0.41),
              child: const Text(
                "Lista de Compras",
                style: TextStyle(
                    color: Color.fromRGBO(116, 60, 41, 1),
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: statusList
                    .map((status) => FilterChip(
                        label: Text(status),
                        selected: statusSelecionados.contains(status),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              statusSelecionados.add(status);
                            } else {
                              statusSelecionados.remove(status);
                            }
                            _streamListasCompras = _carregarListasCompras();
                          });
                        }))
                    .toList(),
              ),
            ),
            Expanded(
              child: StreamBuilder<List<ListasCompra>>(
                stream: _streamListasCompras,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return const Center(
                        child: Column(
                          children: [
                            Text("Carregando listas"),
                            CircularProgressIndicator()
                          ],
                        ),
                      );
                      break;
                    case ConnectionState.active:
                    case ConnectionState.done:
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (_, indice) {
                            List<ListasCompra> listas = snapshot.data!;
                            ListasCompra lista = listas[indice];
                            return criarItemStreamBuilder(context, indice, lista);
                          },
                        );
                      } else {
                        return const Center(
                          child: Text("Nenhuma lista encontrada."),
                        );
                      }
                      break;
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
