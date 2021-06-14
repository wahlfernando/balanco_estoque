import 'package:balanco_app/componentes/utils/show_dialog.dart';
import 'package:balanco_app/models/dados_acesso.dart';
import 'package:balanco_app/services/constantes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//enum OpcaoRaio { BE, CC, GM} //0, 1, 2

// CC = Conferencia, BE = Balanço de Estoque, GM = Guarda Mercadoria

class AcessoPlanilha extends StatefulWidget {
  @override
  _AcessoPlanilhaState createState() => _AcessoPlanilhaState();
}

class _AcessoPlanilhaState extends State<AcessoPlanilha> {


  OpcaoRaio _character = OpcaoRaio.BE; // esse é o padrão

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Balanço Mobile'),
      ),
      body: Form(
        key: formKey,
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.green,
                  Color.fromARGB(255, 204, 229, 255),
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              ),
            ),
            ListView(
              children: [
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Image.asset("assets/images/logotipo_small.png",
                            fit: BoxFit.fill),
                        padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        'Configurações',
                        style: TextStyle(
                          fontSize: 42,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  'Balanço de Estoque',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
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
                                title: Text(
                                  'Conferência (Entrada/Saída)',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                                leading: Radio(
                                  activeColor: Colors.green,
                                  value: OpcaoRaio.CC, //1
                                  groupValue: _character,
                                  onChanged: (value) {
                                    setState(() {
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
                                title: Text(
                                  'Guarda Mercadoria',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
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
                                            Radius.circular(10.0),
                                        ),
                                    ),
                                    onPressed: () {

                                      // Verificação de item escolhido para transição de tela

                                      if(context.read<DadosAcesso>().configAcesPlanilha1 == '0'){
                                        Navigator.of(context).pushNamed('/contlivre_acessochave');
                                      } else {
                                        Navigator.of(context).pushNamed('/produtos');
                                      }
                                      print(context.read<DadosAcesso>().configAcesPlanilha1);
                                    },
                                    color: Colors.white,
                                    textColor: Theme.of(context).primaryColor,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Avançar',
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        Icon(
                                          Icons.forward,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

}
