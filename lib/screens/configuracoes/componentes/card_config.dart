import 'package:balanco_app/componentes/utils/show_dialog.dart';
import 'package:balanco_app/helpers/database_helper.dart';
import 'package:balanco_app/models/dados_acesso.dart';
import 'package:balanco_app/services/constantes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModuloAcesso extends StatefulWidget {
  @override
  _ModuloAcessoState createState() => _ModuloAcessoState();
}

class _ModuloAcessoState extends State<ModuloAcesso> {

  OpcaoRaio _character = OpcaoRaio.BE;

  DatabaseHelper db = DatabaseHelper();

  @override
  void initState() {
    super.initState();

    //Verificação ao iniciar a tela para guardar em baco os valores caso ja publicados.
    if (_character == OpcaoRaio.BE) {
      context.read<DadosAcesso>().configAcesPlanilha1 = '0';
    } else if (_character == OpcaoRaio.CC){
      context.read<DadosAcesso>().configAcesPlanilha1 = '1';
    } else if (_character == OpcaoRaio.GM) {
      context.read<DadosAcesso>().configAcesPlanilha1 = '2';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: ExpansionTile(
        title: Text('Módulo de Acesso', style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.grey.withAlpha(100),
        children: [
          ListTile(
            title: Text('Balanço de Estoque', style: TextStyle(fontSize: 14, color: Colors.black)),
            leading: Radio(
              activeColor: Colors.green,
              value: OpcaoRaio.BE, //0
              groupValue: _character,
              onChanged: (value) {
                setState(() {
                  _character = value;
                  context.read<DadosAcesso>().configAcesPlanilha1 = '0';
                });
              },
            ),
          ),

          ListTile(
            title: Text('Conferência (Entrada/Saída)', style: TextStyle(fontSize: 14, color: Colors.black)),
            leading: Radio(
              activeColor: Colors.green,
              value: OpcaoRaio.CC, //1
              groupValue: _character,
              onChanged: (value) {
                setState(() {
                  // _character = value;
                  // context.read<DadosAcesso>().configAcesPlanilha1 = '1';
                  // _character = value;
                  // context.read<DadosAcesso>().configAcesPlanilha1 = '1';

                  // Temporário:
                  final showDialog = ShowDialog(context, 'Atenção',
                      '\nA opção: "Conferência (Entrada/Saída)", será liberada na versão 2.1');
                  showDialog.showMyDialog();
                  _character = OpcaoRaio.BE;
                  context.read<DadosAcesso>().configAcesPlanilha1 = '0';
                });
              },
            ),
          ),

          ListTile(
            title: Text('Guarda Mercadoria',style: TextStyle(fontSize: 14, color: Colors.black)),
            leading: Radio(
              activeColor: Colors.green,
              value: OpcaoRaio.GM, //2
              groupValue: _character,
              onChanged: (value) {
                setState(() {
                  // _character = value;
                  // context.read<DadosAcesso>().configAcesPlanilha1 = '2';

                  // Temporário:
                  final showDialog = ShowDialog(context, 'Atenção',
                      '\nA opção: "Guarda Mercadoria", será liberada na versão 2.1');
                  showDialog.showMyDialog();
                  _character = OpcaoRaio.BE;
                  context.read<DadosAcesso>().configAcesPlanilha1 = '0';
                });
              },
            ),
          ),

          Padding(
            padding: EdgeInsets.all(8),
            child: SizedBox(
              height: 44,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(10.0)),
                ),
                onPressed: () {
                    onUpdate();
                },
                color: Colors.white,
                textColor: Theme.of(context).primaryColor,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment:
                  MainAxisAlignment.center,
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
    );
  }

  onUpdate() {
    try {
      db.updateDsBalanco('UPDATE dados SET configAcesPlanilha1 = ${context.read<DadosAcesso>().configAcesPlanilha1}');
    } catch (e) {
      final snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text('Falha ao gravar dados!\n $e'),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void dispose() {
    super.dispose();
    onUpdate();
  }
}
