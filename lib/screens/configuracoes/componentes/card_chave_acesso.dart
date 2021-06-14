import 'package:balanco_app/componentes/utils/show_dialog.dart';
import 'package:balanco_app/componentes/utils/show_snackBar.dart';
import 'package:balanco_app/helpers/database_helper.dart';
import 'package:balanco_app/models/dados_acesso.dart';
import 'package:balanco_app/screens/configuracoes/componentes/card_config_chave.dart';
import 'package:balanco_app/services/constantes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardChave extends StatefulWidget {
  @override
  _CardChaveState createState() => _CardChaveState();
}

class _CardChaveState extends State<CardChave> {
  OpcaoRaio _character = OpcaoRaio.AC; // esse é o padrão

  final _chaveAcesso = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  DatabaseHelper db = DatabaseHelper();

  CardContagem cardContagem = CardContagem();

  @override
  void initState() {
    super.initState();

    db.initializeDatabase();

    if (_character == OpcaoRaio.AC) {
      context.read<DadosAcesso>().configAcesPlanilha2 = '4';
    } else {
      context.read<DadosAcesso>().configAcesPlanilha2 = '3';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: ExpansionTile(
          title: Text('Chave de Acesso',
              style: TextStyle(fontWeight: FontWeight.w600)),
          backgroundColor: Colors.grey.withAlpha(100),
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      textCapitalization: TextCapitalization.characters,
                      controller: _chaveAcesso,
                      style: TextStyle(color: Colors.blue),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        labelText: 'Chave de Acesso',
                        labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      onEditingComplete: (){
                        _chaveAcesso.text.trim();
                      },
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
                          final showDialog = ShowDialog(
                              context,
                              'Código de Acesso',
                              'Digite um código de acesso válido para prosseguir!');
                          if (_chaveAcesso.text.isEmpty) {
                            showDialog.showMyDialog();
                          } else {
                            context.read<DadosAcesso>().codAcesso =
                                _chaveAcesso.text;
                            onUpdate();
                          }
                        },
                        color: Colors.white,
                        textColor: Theme.of(context).primaryColor,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Atualizar',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Icon(
                              Icons.check,
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  onUpdate() {
    try {
      db.updateDsBalanco(
          'UPDATE dados SET codAcesso = "${context.read<DadosAcesso>().codAcesso}"');

      final snackbarUpdate =
          ShowSnackBar(context, 'Dados Alterados!!', Colors.lightGreen);
      snackbarUpdate.showMySnackBar();
    } catch (e) {
      final snackbarUpdate =
          ShowSnackBar(context, 'Falha ao atualizar dados! : $e', Colors.red);
      snackbarUpdate.showMySnackBar();
    }
  }

@override
  void dispose() {
    super.dispose();
    onUpdate();
    db.initializeDatabase();
  }
}
