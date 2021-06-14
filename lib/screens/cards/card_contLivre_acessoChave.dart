import 'package:balanco_app/componentes/api/chave_acesso.dart';
import 'package:balanco_app/componentes/api/conexao/endpoints_api.dart';
import 'package:balanco_app/componentes/utils/show_dialog.dart';
import 'package:balanco_app/componentes/utils/show_snackBar.dart';
import 'package:balanco_app/helpers/database_helper.dart';
import 'package:balanco_app/models/dados_acesso.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:balanco_app/services/constantes.dart';

class ContLivreAcessoChave extends StatefulWidget {

  @override
  _ContLivreAcessoChaveState createState() => _ContLivreAcessoChaveState();
}

class _ContLivreAcessoChaveState extends State<ContLivreAcessoChave> {

  OpcaoRaio _character = OpcaoRaio.AC; // esse é o padrão
  DatabaseHelper db = DatabaseHelper();
  ChaveAcesso chaveAcesso = ChaveAcesso();
  VarFixas varFixas = VarFixas();
  Endpoints endpoint = Endpoints();
  bool setaLivre = false;


  final _chaveAcesso = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  int qtdepaginas;


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

    String sCnpj = context.watch<DadosAcesso>().cnpjInicial;
    String sUser = context.watch<DadosAcesso>().usuario;

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
                        height: 40,
                      ),
                      Text(
                        'Identifique-se para ter acesso',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      SizedBox(
                        height: 30,
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
                                  'Contagem Livre',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                                leading: Radio(
                                  activeColor: Colors.green,
                                  value: OpcaoRaio.CL, //0
                                  groupValue: _character,
                                  onChanged: (value) {
                                    setState(() {
                                      _character = value;
                                      context.read<DadosAcesso>().configAcesPlanilha2 = '3';

                                      _chaveAcesso.text = 'LIVRE';
                                      setState(() {
                                        setaLivre = true;
                                      });
                                    });
                                  },
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  'Acesso através de Chave (Padrão)',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                                leading: Radio(
                                  activeColor: Colors.green,
                                  value: OpcaoRaio.AC, //1
                                  groupValue: _character,
                                  onChanged: (value) {
                                    setState(() {
                                      _character = value;
                                      context.read<DadosAcesso>().configAcesPlanilha2 = '4';
                                      setState(() {
                                        setaLivre = false;
                                        _chaveAcesso.text = '';
                                      });
                                    });
                                  },
                                ),
                              ),
                              SizedBox(height: 10,),

                              setaLivre
                                  ? Container()
                                  : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  textCapitalization: TextCapitalization.characters,
                                  controller: _chaveAcesso,
                                  style: TextStyle(color: Colors.blue),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(16)),
                                    labelText: 'Chave de Acesso',
                                    labelStyle: TextStyle(
                                        fontSize: 18, color: Colors.grey),
                                  ),
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
                                    onPressed: () async{

                                      if (!context.read<DadosAcesso>().resultConect) {
                                      final showDialog = ShowDialog(context, 'Conexão Internet.',
                                      '\nFavor Verifique sua conexão com a internet. Sem conexão não temos como baixar os dados dos produtos.');
                                      showDialog.showMyDialog();
                                      } else {
                                        context.read<DadosAcesso>().sincronizando = false;

                                        final showDialog = ShowDialog(context, 'Código de Acesso', 'Digite um código de acesso válido para prosseguir!');
                                        if (_chaveAcesso.text.isEmpty) {
                                          showDialog.showMyDialog();
                                        } else {
                                          final dados = (await endpoint.consulta_chave(sUser, sCnpj, _chaveAcesso.text));
                                          chaveAcesso.service = dados['service'];
                                          chaveAcesso.usada = dados['usada'];
                                          chaveAcesso.info = dados['info'];
                                          chaveAcesso.encerrada = dados['encerrada'];
                                          chaveAcesso.empresa = dados['empresa'];
                                          chaveAcesso.eliminada = dados['eliminada'];
                                          chaveAcesso.dataenvio = dados['dataenvio'];
                                          chaveAcesso.cnpj = dados['cnpj'];
                                          chaveAcesso.chave = dados['chave'];

                                          if(chaveAcesso.service.trim() == varFixas.chaveEncontrada.trim()){
                                            if(chaveAcesso.encerrada == 1){
                                              final showDialog = ShowDialog(context, 'Chave Acesso', '${chaveAcesso.info}. \n Favor usar outra chave.');
                                              showDialog.showMyDialog();
                                            } else {
                                              if(chaveAcesso.usada == 1){
                                                final showDialog = ShowDialog(context, 'Chave Acesso', '${chaveAcesso.info}. \n Favor usar outra chave.');
                                                showDialog.showMyDialog();
                                              } else {
                                                if(chaveAcesso.eliminada == 1){
                                                  final showDialog = ShowDialog(context, 'Chave Acesso', '${chaveAcesso.info}. \n Favor usar outra chave.');
                                                  showDialog.showMyDialog();
                                                } else {

                                                  context.read<DadosAcesso>().codAcesso = _chaveAcesso.text.trim();
                                                  onGravarDados();

                                                  varFixas.loading = true;
                                                  db.deleteAllProdutos();

                                                  context.read<DadosAcesso>().valorJ = 1;
                                                  context.read<DadosAcesso>().valorI = 0;

                                                  Navigator.of(context).pushNamed('/produtos');
                                                }
                                              }
                                            }
                                          } else {
                                            final showDialog = ShowDialog(context, 'Chave Acesso', '${chaveAcesso.service}');
                                            showDialog.showMyDialog();
                                          }
                                        }
                                      }
                                    },
                                    color: Colors.white,
                                    textColor: Theme.of(context).primaryColor,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Acessar',
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
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      if(varFixas.loading) CircularProgressIndicator(),
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



  Future<void> onGravarDados() async{
    try {
      await db.insereDsBalanco(
          "insert into dados(cnpjInicial, usuario, codAcesso, configAcesPlanilha1, configAcesPlanilha2) "
          "values('${context.read<DadosAcesso>().cnpjInicial}', '${context.read<DadosAcesso>().usuario}', '${context.read<DadosAcesso>().codAcesso}', "
          "'${context.read<DadosAcesso>().configAcesPlanilha1}', '${context.read<DadosAcesso>().configAcesPlanilha2}' );"
      );
    } catch (e) {
      final snackbarUpdate = ShowSnackBar(context, 'Falha ao gravar dados! : $e', Colors.red);
      snackbarUpdate.showMySnackBar();
    }
  }

  @override
  void dispose() {
    super.dispose();
    onGravarDados();
    //db.initializeDatabase();
  }
}
