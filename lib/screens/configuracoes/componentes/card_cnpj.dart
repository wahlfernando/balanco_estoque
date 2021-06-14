
import 'package:balanco_app/common/qrcode.dart';
import 'package:balanco_app/componentes/utils/show_dialog.dart';
import 'package:balanco_app/componentes/utils/show_snackBar.dart';
import 'package:balanco_app/helpers/database_helper.dart';
import 'package:balanco_app/models/dados_acesso.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class CardCnpj extends StatefulWidget {
  @override
  _CardCnpjState createState() => _CardCnpjState();
}

class _CardCnpjState extends State<CardCnpj> {

  QRCode qrcode = QRCode();

  final cnpjController = TextEditingController();
  final usuController = TextEditingController();
  var maskFormatter = new MaskTextInputFormatter(
      mask: '##.###.###/####-##', filter: {"#": RegExp(r'[0-9]')});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  DatabaseHelper db = DatabaseHelper();

  @override
  void initState() {
    super.initState();

    db.initializeDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: ExpansionTile(
        title: Text('CNPJ / Usuário', style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.grey.withAlpha(100),
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: usuController,
                    autocorrect: false,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      labelText: 'Usuário',
                      hintText: 'Digite o Usuário',
                      labelStyle: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: cnpjController,
                    inputFormatters: [maskFormatter],
                    autocorrect: false,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16)),
                      labelText: 'CNPJ',
                      hintText: 'Digite o CNPJ',
                      labelStyle: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    onPressed: () => qrcode.scanQR(cnpjController, usuController),
                    color: Colors.white,
                    textColor: Theme.of(context).primaryColor,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('QR Code  ',
                            style: TextStyle(
                                fontSize: 18)),
                        Icon(
                          Icons.qr_code,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
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
                      onPressed: () {
                        final showDialog = ShowDialog(
                            context, 'Dados de Usuário', 'Digite dados válidos para prosseguir!');
                        if (cnpjController.text.isEmpty || usuController.text.isEmpty) {
                          showDialog.showMyDialog();
                        } else {
                          context.read<DadosAcesso>().usuario = usuController.text;
                          context.read<DadosAcesso>().cnpjInicial = cnpjController.text.replaceAll('/', '').replaceAll('-', '').replaceAll('.', '');
                          onUpdate();
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  onUpdate() {
    try {
      db.updateDsBalanco('UPDATE dados SET cnpjinicial = "${context.read<DadosAcesso>().cnpjInicial}", usuario = "${context.read<DadosAcesso>().usuario}"');

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



