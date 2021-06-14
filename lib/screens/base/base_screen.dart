import 'package:balanco_app/models/page_manager.dart';
import 'package:balanco_app/screens/produtos/tela_products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatefulWidget {
  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final PageController pagecontroller = PageController();

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => PageManager(pagecontroller),
      child: PageView(
          controller: pagecontroller,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            //lista de paginas
            //HomeScreen(),  // tela inicial
            //AcessoPlanilha(), // tela de acesso a planilha, multopli escolha para dois topoicos
            TelaProdutos(), // tela que tem a lista dos produtos que vem da api
          ]),
    );
  }
}
