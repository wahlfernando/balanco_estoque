import 'dart:async';
import 'package:balanco_app/componentes/api/conexao/endpoints_api.dart';
import 'package:balanco_app/componentes/utils/show_dialog.dart';
import 'package:balanco_app/componentes/utils/show_snackBar.dart';
import 'package:balanco_app/helpers/database_helper.dart';
import 'package:balanco_app/models/dados_acesso.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardOutrasConfiguracoes extends StatefulWidget {
  @override
  _CardOutrasConfiguracoesState createState() =>
      _CardOutrasConfiguracoesState();
}

class _CardOutrasConfiguracoesState extends State<CardOutrasConfiguracoes> {
  DatabaseHelper db = DatabaseHelper();
  Endpoints endpoints = Endpoints();
  String sCnpj;
  String sUser;
  String sChave;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: ExpansionTile(
        title: Text('Outras Configurações',
            style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.grey.withAlpha(100),
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: SizedBox(
              height: 44,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                onPressed: () {
                  if (!context.read<DadosAcesso>().resultConect) {
                    final showDialog = ShowDialog(context, 'Conexão Internet.',
                        '\nFavor Verifique sua conexão com a internet, se zerar a contegem não terá como baixar os dados dos produtos novamente.');
                    showDialog.showMyDialog();
                  } else {
                    context.read<DadosAcesso>().sincronizando = false;
                    return showDialog<void>(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Zerar a Contagem?'),
                            content: const Text(
                                'Ao confirmar será zerado toda a contagem, \ não poderá ser desfeito.'),
                            actions: [
                              FlatButton(
                                onPressed: () {
                                  onZerarContagem();
                                },
                                child: Text(' Confirma? '),
                                textColor: Colors.green,
                              ),
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancelar'),
                                textColor: Colors.blueAccent,
                              ),
                            ],
                          );
                        });
                  }
                },
                color: Colors.white,
                textColor: Theme.of(context).primaryColor,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Zerar Contagem  ',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Icon(
                      Icons.scatter_plot_outlined,
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: SizedBox(
              height: 44,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                onPressed: () {
                  return showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Deletar dados?'),
                          content: const Text(
                              'Essa ação não poderá ser desfeita! \ Todos os dados serão perdidos.'),
                          actions: [
                            FlatButton(
                              onPressed: () {
                                onRsetaDados();
                                Timer(Duration(seconds: 2), () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context)
                                      .pushNamed('/tela_inicial');
                                });
                              },
                              child: Text('Confirma?'),
                              textColor: Colors.red,
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancelar'),
                              textColor: Colors.blueAccent,
                            ),
                          ],
                        );
                      });
                },
                color: Colors.white,
                textColor: Theme.of(context).primaryColor,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Resetar Dados  ',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Icon(
                      Icons.system_update_alt,
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  onZerarContagem() {
    try {
      db.deleteAllCritica();
    } catch (e) {
      debugPrint('Erro ao deletar critica...');
    }

    try {
      db.deletarDsBalanco('DELETE FROM produto');
      final snackbarZera =
          ShowSnackBar(context, 'Contagem Zerada...', Colors.lightGreen);
      snackbarZera.showMySnackBar();
      context.read<DadosAcesso>().valorJ = 1;
      context.read<DadosAcesso>().valorI = 0;
      Navigator.of(context).pushNamed('/produtos');
    } catch (e) {
      debugPrint('Erro ao deletar critica...');
    }
  }

  onRsetaDados() async {
    try {
      try {
        await db.deletarDsBalanco('DELETE FROM dados');
      } catch (e) {
        debugPrint('Erro ao deletar dados...');
      }

      try {
        await db.deletarDsBalanco('DELETE FROM produto');
      } catch (e) {
        debugPrint('Erro ao deletar produtos...');
      }

      try {
        await db.deletarDsBalanco('DELETE FROM detalhe');
      } catch (e) {
        debugPrint('Erro ao deletar detalhe...');
      }

      final snackbar =
          ShowSnackBar(context, 'Dados Deletados...', Colors.lightGreen);
      snackbar.showMySnackBar();
    } catch (e) {
      final snackbarErro =
          ShowSnackBar(context, 'Falha ao resetar dados! : $e', Colors.red);
      snackbarErro.showMySnackBar();
    }
  }

  resgataDados() async {
    List linhas = await db.getDsDados();
    for (var linha in linhas) {
      sCnpj = linha['cnpjInicial'].toString();
      sUser = linha['usuario'].toString();
      sChave = linha['codAcesso'].toString();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
