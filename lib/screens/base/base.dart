import 'package:balanco_app/models/page_manager.dart';
import 'package:balanco_app/screens/cards/acesso_planilha.dart';
import 'package:balanco_app/screens/cards/card_contLivre_acessoChave.dart';
import 'package:balanco_app/screens/configuracoes/tela_configuracoes.dart';
import 'package:balanco_app/screens/home/tela_inicial.dart';
import 'package:balanco_app/screens/produtos/tela_products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseTelas extends StatefulWidget {
  @override
  _BaseTelasState createState() => _BaseTelasState();
}

class _BaseTelasState extends State<BaseTelas> {

  final PageController pagecontroller = PageController();

  @override
  Widget build(BuildContext context) {
    return Provider<PageManager>(
      create: (_) => PageManager(pagecontroller),
      child: PageView(
        controller: pagecontroller,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          TelaInicialCnpj(),
          AcessoPlanilha(),
          ContLivreAcessoChave(),
          TelaProdutos(),
          TelaConfiguracoes(),
        ],
      ),
    );
  }
}
