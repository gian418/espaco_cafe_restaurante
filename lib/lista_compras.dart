import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:espaco_cafe_restaurante/app_bar_default.dart';
import 'package:espaco_cafe_restaurante/end_drawer_default.dart';
import 'package:espaco_cafe_restaurante/lista_status.dart';
import 'package:espaco_cafe_restaurante/model/listas_compra.dart';
import 'package:espaco_cafe_restaurante/model/produto_lista.dart';
import 'package:espaco_cafe_restaurante/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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

  SnackBar _construirSnackBar(String msg, ehErro) {
    return SnackBar(
      content: Text(
        msg,
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16),
      ),
      backgroundColor: ehErro ? Colors.red : Colors.green,
      duration: const Duration(seconds: 6),
    );
  }

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
                lista.fornecedor = doc.get("fornecedor");

                List<ProdutoLista> produtos = [];
                for(Map<String, dynamic> produto in doc.get("produtos")) {
                  ProdutoLista produtoLista = new ProdutoLista();
                  produtoLista.quantidade = produto["quantidade"];
                  produtoLista.nome = produto["nome"];
                  produtos.add(produtoLista);
                }

                lista.produtos = produtos;
                return lista;
              })
              .where((lista) => statusSelecionados.contains(lista.status))
              .toList();
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case ListaStatus.ENVIADA:
        return Colors.green;
      case ListaStatus.PENDENTE:
        return Colors.orange;
      case ListaStatus.CANCELADA:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget criarItemStreamBuilder(context, indice, ListasCompra lista) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 8),
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
        confirmDismiss: (direction) async {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {

              String titulo =  "Cancelar a Lista de Compras";
              String conteudo = "Você tem certeza que deseja cancelar a lista de compras?";
              if (direction == DismissDirection.startToEnd) {
                titulo =  "Enviar Lista para Fornecedores";
                conteudo = "Você deseja enviar a lista para os fornecedores?";
              }

              return AlertDialog(
                title: Text(
                  titulo,
                  style: const TextStyle(
                      color: Color.fromRGBO(116, 60, 41, 1),
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                content: Text(
                  conteudo,
                  style: const TextStyle(
                      color: Color.fromRGBO(116, 60, 41, 1),
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Não",
                        style:
                            TextStyle(color: Color.fromRGBO(116, 60, 41, 1))),
                  ),
                  TextButton(
                    onPressed: () {
                      if (direction == DismissDirection.startToEnd && lista.status != "Pendente") {
                        var snackBar = _construirSnackBar("Apenas uma lista de compras com status Pendente pode ser enviada", true);
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        return Navigator.of(context).pop(false);
                      }

                      if (direction == DismissDirection.endToStart &&  lista.status != "Pendente") {
                        var snackBar = _construirSnackBar("Apenas uma lista de compras com status Pendente pode ser cancelada", true);
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        return Navigator.of(context).pop(false);
                      }

                      return Navigator.of(context).pop(true);
                    },
                    child: const Text("Sim",
                        style:
                            TextStyle(color: Color.fromRGBO(116, 60, 41, 1))),
                  ),
                ],
              );
            },
          );
        },
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) {
            FirebaseFirestore firestore = FirebaseFirestore.instance;
            Map<String, dynamic> atualizarStatusLista = {"status": "Cancelada"};
            firestore
                .collection("ListasCompras")
                .doc(lista.id)
                .update(atualizarStatusLista)
                .then((_) => {
                      setState(() {
                        lista.status = "Cancelada";
                        var snackBar = _construirSnackBar("Lista de compras cancelada com sucesso", false);
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      })
                });
          }

          if (direction == DismissDirection.startToEnd) {
            _enviarMsgWhatsApp(lista).then((enviado) {
              if (enviado) {
                FirebaseFirestore firestore = FirebaseFirestore.instance;
                Map<String, dynamic> atualizarStatusLista = {"status": "Enviada"};
                firestore.collection("ListasCompras").doc(lista.id)
                    .update(atualizarStatusLista).then((_) => {
                  setState(() {
                    lista.status = "Enviada";
                    var snackBar = _construirSnackBar("Lista de compras enviada com sucesso", false);
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  })
                });
              }
            });
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
          elevation: 0,
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
            onTap: (){
              if (lista.status != ListaStatus.PENDENTE) {
                var snackBar = _construirSnackBar("Apenas listas pendentes podem ser editadas", true);
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                return;
              }

              Navigator.pushNamed(
                  context,
                  RouteGenerator.CADASTRO_LISTA_COMPRA,
                  arguments: lista
              );
            },
          ),
        ),
      ),
    );
  }/**/

  Future<bool> _enviarMsgWhatsApp(ListasCompra lista) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    return firestore.collection("Fornecedores").where("nome", isEqualTo: lista.fornecedor).limit(1).get().then((fornecedor) {
      String telefoneFornecedor = "";
      for(var fornecedor in fornecedor.docs) {
        telefoneFornecedor = fornecedor.get("telefone");
      }

      String produtosMsg = "";
      for(ProdutoLista produto in lista.produtos) {
        produtosMsg = "$produtosMsg\n>> ${produto.nome} | Qtd: ${produto.quantidade}";
      }

      String message = "Olá, tudo bem? Você poderia me passar um orçamento para a seguinte lista de produtos? $produtosMsg";
      String encodedMessage = Uri.encodeFull(message);
      String url = "https://wa.me/$telefoneFornecedor?text=$encodedMessage";
      print(message);
      return launchUrl(Uri.parse(url));
    });
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
                            return criarItemStreamBuilder(
                                context, indice, lista);
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
      floatingActionButton:  FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, RouteGenerator.CADASTRO_LISTA_COMPRA);
        },
        backgroundColor: const Color(0xffD6B9AC),
        foregroundColor: const Color(0xff743C29),
        child: const Icon(Icons.add),
      ),
    );
  }
}
