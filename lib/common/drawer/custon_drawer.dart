import 'dart:io';
import 'package:balanco_app/componentes/api/conexao/endpoints_api.dart';
import 'package:balanco_app/componentes/api/produtos/busca_critica.dart';
import 'package:balanco_app/componentes/api/produtos/produto.dart';
import 'package:balanco_app/componentes/utils/show_dialog.dart';
import 'package:balanco_app/models/dados_acesso.dart';
import 'package:balanco_app/screens/produtos/tela_products.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_foreground_plugin/flutter_foreground_plugin.dart';
import 'package:json_string/json_string.dart';
import 'custon_drawer_header.dart';
import 'package:balanco_app/helpers/database_helper.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';


class CustonDrawer extends StatefulWidget {
  bool prod = false;
  CustonDrawer({this.prod});

  @override
  _CustonDrawerState createState() => _CustonDrawerState();
}

class _CustonDrawerState extends State<CustonDrawer> {
  DatabaseHelper db = DatabaseHelper();
  TelaProdutos telaProdutos;
  Dio dio = new Dio();
  Response response;
  String cnpjInicial;
  String usuario;
  String codAcesso;
  List<Produto> listProdEnvio = List();
  List<BuscaCritica> listCriticaEnvio = List();


  resgataDados() async {
    List linhas = await db.getDsDados();
    for (var linha in linhas) {
      cnpjInicial = linha['cnpjInicial'].toString();
      usuario = linha['usuario'].toString();
      codAcesso = linha['codAcesso'].toString();
    }

    print('$cnpjInicial, $usuario, $codAcesso');
  }


  void execEndPointSincronizacao() async {
    List produtos = await db.getAllProdutosQtdeMaiorZero();
    List<Produto> listaProduto;
    await resgataDados();

    print(produtos.length);

    listProdEnvio.clear();

    produtos.forEach((element) {
      listProdEnvio.add(Produto(
            codproduto: element['codproduto'],
            quantidade: element["quantidade"],
            localizacao1: element['localizacao1'],
            localizacao2: element["localizacao2"],
            localizacao3: element['localizacao3'],
          ));
    });

    listaProduto = listProdEnvio;

    response = await dio.post(
      "http://balanco.gestaoparts.com.br:7008/v2/app/balanco/chave/produto/sincronizar",
      data: {
        "cnpj": cnpjInicial,
        "chave": codAcesso,
        "user": usuario,
        "token": varFixas.tokenPost,
        "produtos": produtos,
      },
      onSendProgress: (received, total) {
        if (total != -1) {
          print((received / total * 100).toStringAsFixed(0) + "%");
        }
      },
    );


    String result = await response.toString();
    final txtConv = JsonString.orNull(result);
    final credentials = txtConv.decodedValue;
    String service = credentials['service'];

    if (response.statusCode == 200) {
      if (service == "Solicitação não encontrada ou houve alguma falha no processamento") {
        // final showDialog = ShowDialog(context, 'Sincronização...',
        //     'Solicitação não encontrada ou houve alguma falha no processamento.');
        // showDialog.showMyDialog();
        EasyLoading.showInfo('Solicitação não encontrada ou houve alguma falha no processamento.');
      } else {
        EasyLoading.showInfo('Os dados foram sincronizados com o servidor!');
        // final showDialog = ShowDialog(context, 'Sincronização...',
        //     'Os dados foram sincronizados com o servidor.!');
        // showDialog.showMyDialog();
      }
    } else {
      EasyLoading.showInfo('Não foi possível sincronizar os dados com o servidor.');
      // final showDialog = ShowDialog(context, 'Sincronização...',
      //     'Não foi possível sincronizar os dados com o servidor.');
      // showDialog.showMyDialog();
    }

  }

  void execEndPointCritica() async {
    List criticas = await db.getAllCriticaBusca();
    await resgataDados();

    listCriticaEnvio.clear();

    criticas.forEach((element) {
      listCriticaEnvio.add(BuscaCritica(
            referencia: element['referencia'],
            data: element["data"],
            hora: element['hora'],
          ));
    });


    response = await dio.post(
      "http://balanco.gestaoparts.com.br:7008/v2/app/balanco/chave/produto/naoencontrado/sincronizar",
      data: {
        "cnpj": cnpjInicial,
        "chave": codAcesso,
        "user": usuario,
        "token": varFixas.tokenPost,
        "busca": criticas,
      },
      onSendProgress: (received, total) {
        if (total != -1) {
          print((received / total * 100).toStringAsFixed(0) + "%");
        }
      },
    );

    if (response.statusCode == 200) {
      // final showDialog = ShowDialog(context, 'Sincronização...',
      //     'Os dados foram sincronizados com o servidor. \nServidor: ${response.data['service'].toString()}!');
      // showDialog.showMyDialog();
      print('Funcionou...');
    } else {
      final showDialog = ShowDialog(context, 'Sincronização...',
          'Não foi possível sincronizar os dados dos produtos não encontrados com o servidor. \nServidor: ${response.data['service'].toString()}!');
      showDialog.showMyDialog();
    }
  }

  void mudaStatusSincronismo() {
    var data_hora = DateTime.now();
    try {
      db.updateProduto('UPDATE produto SET '
          'sincronizado = "${data_hora}" where (quantidade <> "0" or quantidade <> "" or quantidade <> null) ');
    } catch (e) {
      print('Erro ao atualizar DataHora no produto');
    }
  }


  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Drawer(
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[100], Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          ListView(
            children: [
              CustonDrawerHeader(),
              const Divider(),
              _drawerItem(
                  color: primaryColor,
                  icon: Icons.settings,
                  text: 'Configurações',
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed('/configuracoes');
                  }),
              _drawerItem(
                  color: primaryColor,
                  icon: Icons.grid_on,
                  text: 'Lista de Produtos',
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TelaProdutos()));
                  }),
              _drawerItem(
                  color: primaryColor,
                  icon: Icons.sync,
                  text: 'Sincronizar',
                  onTap: () async {

                    if (!context.read<DadosAcesso>().resultConect) {
                      final showDialog = ShowDialog(context, 'Conexão Internet.',
                          '\nFavor Verifique sua conexão com a internet, não é possivel sincronizar os dados sem internet ativa.');
                      showDialog.showMyDialog();
                    } else {
                      EasyLoading.showSuccess('Sincronizando Produtos....');
                      resgataDados();
                      execEndPointCritica();
                      execEndPointSincronizacao();
                      context.read<DadosAcesso>().sinc = true;
                      mudaStatusSincronismo();
                      Navigator.pop(context);
                    }

                  }),

              _drawerItem(
                  color: primaryColor,
                  icon: Icons.exit_to_app,
                  text: 'Sair do App',
                  onTap: () async {
                    FlutterForegroundPlugin.stopForegroundService();
                    Future.delayed(const Duration(milliseconds: 1000), () {
                      exit(0);
                    });
                  }),
              Divider(
                height: 150,
              ),
              LayoutBuilder(
                //return LayoutBuilder
                builder: (context, constraints) {
                  return OrientationBuilder(
                    //return OrientationBuilder
                    builder: (context, orientation) {
                      //initialize SizerUtil()
                      SizerUtil().init(
                          constraints, orientation); //initialize SizerUtil
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16,0,0,0),
                            child: Text(
                              'Chave de Acesso:',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: primaryColor,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16,0,0,0),
                            child: Text(
                              context.read<DadosAcesso>().codAcesso == null
                                  ? ''
                                  : context.read<DadosAcesso>().codAcesso,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: primaryColor,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16,8,0,0),
                            child: Text(
                              context.read<DadosAcesso>().pagTotais == null
                                  ? ''
                                  : 'Total de Produtos: ${context.read<DadosAcesso>().pagTotais}',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: primaryColor,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.fromLTRB(16,16,0,0),
                            child: Text('Versão: 2.0',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: primaryColor,
                                  fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }



  Widget _drawerItem(
      {IconData icon, String text, GestureTapCallback onTap, Color color}) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 60,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Icon(
                icon,
                size: 32,
                color: color,
              ),
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
