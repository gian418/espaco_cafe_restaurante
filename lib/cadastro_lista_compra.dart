import 'package:espaco_cafe_restaurante/app_bar_default.dart';
import 'package:flutter/material.dart';

class CadastroListaCompra extends StatefulWidget {
  const CadastroListaCompra({super.key});

  @override
  State<CadastroListaCompra> createState() => _CadastroListaCompraState();
}

class _CadastroListaCompraState extends State<CadastroListaCompra> {
  TextEditingController _descricaoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault.build(),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              width: double.infinity,
              color: const Color.fromRGBO(214, 185, 172, 0.41),
              child: const Text(
                "Nova Lista de Compras",
                style: TextStyle(
                    color: Color.fromRGBO(116, 60, 41, 1),
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _descricaoController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: "Nome",
                  hintText: "Digite uma descricão",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Produtos selecionados",
                    style: TextStyle(
                        color: Color.fromRGBO(116, 60, 41, 1),
                        fontSize: 16
                    ),
                  ),
                  ElevatedButton(
                      onPressed: (){},
                      child: const Icon(Icons.search, color: Color.fromRGBO(116, 60, 41, 1)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffD6B9AC),
                      surfaceTintColor: Colors.white
                    ),
                  )
                ],
              ),
            ),
            // Expanded(
            //   child: StreamBuilder<List<Produto>>(
            //     stream: _streamProdutos,
            //     builder: (context, snapshot) {
            //       switch (snapshot.connectionState) {
            //         case ConnectionState.none:
            //         case ConnectionState.waiting:
            //           return const Center(
            //             child: Column(
            //               children: [
            //                 Text("Carregando produtos"),
            //                 CircularProgressIndicator()
            //               ],
            //             ),
            //           );
            //           break;
            //         case ConnectionState.active:
            //         case ConnectionState.done:
            //           if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            //             return ListView.builder(
            //               itemCount: snapshot.data!.length,
            //               itemBuilder: (_, indice) {
            //                 List<Produto> produtos = snapshot.data!;
            //                 Produto produto = produtos[indice];
            //                 return criarItemStreamBuilder(
            //                     context, indice, produto);
            //               },
            //             );
            //           } else {
            //             return const Center(
            //               child: Text("Nenhum produto encontrado."),
            //             );
            //           }
            //           break;
            //       }
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
