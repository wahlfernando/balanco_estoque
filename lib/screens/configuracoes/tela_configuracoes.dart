import 'dart:async';
import 'package:balanco_app/helpers/database_helper.dart';
import 'package:balanco_app/models/dados_acesso.dart';
import 'package:balanco_app/screens/configuracoes/componentes/card_chave_acesso.dart';
import 'package:balanco_app/screens/configuracoes/componentes/card_cnpj.dart';
import 'package:balanco_app/screens/configuracoes/componentes/card_config.dart';
import 'package:balanco_app/screens/configuracoes/componentes/card_config_chave.dart';
import 'package:balanco_app/screens/configuracoes/componentes/card_outras_configuracoes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class TelaConfiguracoes extends StatefulWidget{

  @override
  _TelaConfiguracoesState createState() => _TelaConfiguracoesState();
}

class _TelaConfiguracoesState extends State<TelaConfiguracoes> {
  DatabaseHelper databaseHelper = DatabaseHelper();

   String retConfig2;

  @override
  void initState() {
    super.initState();
    retConfig2 = context.read<DadosAcesso>().configAcesPlanilha2;
    Timer(Duration(milliseconds: 500),() => setState(() {print(retConfig2);}));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Balanço Mobile - Configurações'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.green,
                Colors.blueGrey,
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            ),
          ),
          ListView(
            children: [
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    CardCnpj(),
                    SizedBox(
                      height: 20,
                    ),
                    ModuloAcesso(),
                    SizedBox(
                      height: 20,
                    ),
                    CardContagem(),
                    SizedBox(
                      height: 20,
                    ),
                    CardChave(),
                    CardOutrasConfiguracoes(),
                    Container(
                      child: Image.asset("assets/images/logotipo_small.png",
                          fit: BoxFit.fill),
                      padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),

    );
  }






}
