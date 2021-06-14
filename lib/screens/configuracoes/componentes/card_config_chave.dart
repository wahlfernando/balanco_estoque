import 'package:balanco_app/componentes/utils/show_snackBar.dart';
import 'package:balanco_app/helpers/database_helper.dart';
import 'package:balanco_app/models/dados_acesso.dart';
import 'package:balanco_app/services/constantes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardContagem extends StatefulWidget {
  @override
  _CardContagemState createState() => _CardContagemState();
}



class _CardContagemState extends State<CardContagem> {

  OpcaoRaio _character = OpcaoRaio.AC;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  DatabaseHelper db = DatabaseHelper();

  @override
  void initState() {
    super.initState();

    db.initializeDatabase();

    if (_character == OpcaoRaio.AC) {
      context.read<DadosAcesso>().configAcesPlanilha2 = '4';
    } else {
      context.read<DadosAcesso>().configAcesPlanilha2 ='3';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: ExpansionTile(
        title: Text('Contagem', style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.grey.withAlpha(100),
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
            child: Column(
              children: [
                ListTile(
                  title: Text('Contagem Livre', style: TextStyle(fontSize: 14, color: Colors.black)),
                  leading: Radio(
                    activeColor: Colors.green,
                    value: OpcaoRaio.CL,
                    groupValue: _character,
                    onChanged: (value) {
                      setState(() {
                        _character = value;
                        context.read<DadosAcesso>().configAcesPlanilha2 = '3';
                      });
                    },
                  ),
                ),
                ListTile(
                  title: Text('Acesso através de Chave (Padrão)', style: TextStyle(fontSize: 14, color: Colors.black)),
                  leading: Radio(
                    activeColor: Colors.green,
                    value: OpcaoRaio.AC,
                    groupValue: _character,
                    onChanged: (value) {
                      setState(() {
                        _character = value;
                        context.read<DadosAcesso>().configAcesPlanilha2 = '4';
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
          ),
        ],
      ),
    );
  }


  onUpdate() {
    try {
      if(_character == OpcaoRaio.CL){
        db.updateDsBalanco('UPDATE dados SET configAcesPlanilha2 = ${context.read<DadosAcesso>().configAcesPlanilha2}, '
            'codAcesso = "LIVRE"');
      } else{
        db.updateDsBalanco('UPDATE dados SET configAcesPlanilha2 = ${context.read<DadosAcesso>().configAcesPlanilha2}');
      }

      final snackbarUpdate = ShowSnackBar(context, 'Dados Alterados!!', Colors.lightGreen);
      snackbarUpdate.showMySnackBar();

    } catch (e) {
      final snackbarUpdate = ShowSnackBar(context, 'Falha ao atualizar dados! : $e', Colors.red);
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



