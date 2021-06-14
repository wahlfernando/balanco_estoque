import 'dart:async';
import 'package:balanco_app/common/qrcode.dart';
import 'package:balanco_app/componentes/api/conexao/endpoints_api.dart';
import 'package:balanco_app/services/constantes.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:balanco_app/componentes/utils/show_dialog.dart';
import 'package:balanco_app/models/dados_acesso.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class TelaAcessoCnpj extends StatefulWidget {
  @override
  _TelaAcessoCnpjState createState() => _TelaAcessoCnpjState();
}

class _TelaAcessoCnpjState extends State<TelaAcessoCnpj> {

  QRCode qrcode = QRCode();
  Endpoints endpoint = Endpoints();
  var maskFormatter = new MaskTextInputFormatter(mask: '##.###.###/####-##', filter: {"#": RegExp(r'[0-9]')});
  final Connectivity _connectivity = Connectivity();
  final cnpjController = TextEditingController();
  final usuController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool conexao = false;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Card(
      shape: RoundedRectangleBorder( borderRadius: BorderRadius.all(Radius.circular(10.0))),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Column(
                children: [
                  TextFormField(
                    enabled: false,
                    controller: usuController,
                    autocorrect: false,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      labelText: 'Usuário',
                      hintText: 'Digite o Usuário',
                      labelStyle: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    enabled: false,
                    controller: cnpjController,
                    inputFormatters: [maskFormatter],
                    autocorrect: false,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder( borderRadius: BorderRadius.circular(16)),
                      labelText: 'CNPJ',
                      hintText: 'Digite o CNPJ',
                      labelStyle: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                  )
                ],
              ),
              Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                        onPressed: () {
                          qrcode.scanQR(cnpjController, usuController);

                          // //TODO: temporario:
                          // cnpjController.text = "01915223000141";
                          // usuController.text = "SSS-SSSISTEMAS";

                        },
                        color: Colors.white,
                        textColor: primaryColor,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('QR Code  ',
                                style: TextStyle( fontSize: 18)),
                            Icon(
                              Icons.qr_code,
                              color: primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(0, 0, 20, 0)),
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder( borderRadius: BorderRadius.all(Radius.circular(10.0))),
                        color: Colors.white,
                        textColor: primaryColor,
                         onPressed: () async{
                          // verificação da internet:
                          Future.delayed(Duration(milliseconds: 500), () {
                            _connectivity.checkConnectivity().then((connectivityResult) {
                              updateStatus(connectivityResult);
                            });
                          });

                          if (this.conexao) {
                            if(await endpoint.verifica_conexao() == true){
                              // verificação de campos vazios
                              if (cnpjController.text.isEmpty ||usuController.text.isEmpty) {

                                final showDialog = ShowDialog(context,'Verificação de Campo', 'Campos não podem ser vazio! Preencha com um valor válido');
                                showDialog.showMyDialog();
                              } else {
                                context.read<DadosAcesso>().usuario = usuController.text;
                                context.read<DadosAcesso>().cnpjInicial = cnpjController.text.replaceAll('/', '').replaceAll('-', '').replaceAll('.', '');

                                //Verificação de endepoint (cnpj e usuario)
                                if((await endpoint.verifica_cnpj(usuController.text, cnpjController.text)) == true){
                                  Navigator.of(context).pushNamed('/acessoplanilha');
                                } else {

                                  final showDialog = ShowDialog(context, 'Verificação Cliente','Empresa não encontrada ou não habilitada para o uso do aplicativo!');
                                  showDialog.showMyDialog();
                                }
                              }
                            } else {
                              final showDialog = ShowDialog(context, 'Verificação EndPoint','Não conectou ao EndPoint! \n Verifique com o suporte.');
                              showDialog.showMyDialog();
                            }
                          } // fim conexao
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Avançar  ', style: TextStyle(fontSize: 18)),
                            Icon(Icons.forward, color: primaryColor),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateStatus(ConnectivityResult connectivityResult) async {
    if (connectivityResult != ConnectivityResult.wifi) {
      if (connectivityResult != ConnectivityResult.mobile) {
        this.conexao = false;
        final showDialog = ShowDialog(context, "-> Conexão Internet <-", "O telefone não está conectado a internet. \n Por favor, conecte na internet!");
        showDialog.showMyDialog();
      }
    } else {
      this.conexao = true;
    }
  }

}
