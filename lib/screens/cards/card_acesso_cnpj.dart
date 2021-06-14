
import 'package:balanco_app/models/dados_acesso.dart';
import 'package:balanco_app/services/show_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class CardAcessoCnpj extends StatefulWidget {
  @override
  _CardAcessoCnpjState createState() => _CardAcessoCnpjState();
}

class _CardAcessoCnpjState extends State<CardAcessoCnpj> {
  final cnpjController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var maskFormatter = new MaskTextInputFormatter(
      mask: '##.###.###/####-##', filter: {"#": RegExp(r'[0-9]')});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
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
                          labelStyle:
                              TextStyle(fontSize: 18, color: Colors.grey),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      iconSize: 34,
                      icon: Icon(Icons.qr_code),
                      color: primaryColor,
                      onPressed: () => scanQR(),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 44,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  onPressed: () {


                    //TODO: Procedimentos de verificação para salvar e pular as telas caso esteja com cnpj salvo.

                    final showDialog = ShowDialog(context, 'Campo CNPJ', 'O campo CNPJ não pode ser vazio! Preencha com um valor válido');

                    if (cnpjController.text.isEmpty) {
                      showDialog.showMyDialog();
                    } else {
                      context.read<DadosAcesso>().cnpjInicial = cnpjController.text.replaceAll('/', '').replaceAll('-', '').replaceAll('.', '');
                      Navigator.of(context).pushNamed('/acessoplanilha');

                    }
                  },
                  color: Colors.white,
                  textColor: primaryColor,
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
                        color: primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancelar", true, ScanMode.QR);
    } on PlatformException {
      barcodeScanRes = '';
    }
    if (!mounted) return;
    setState(() {
      if (barcodeScanRes == '-1') {
        barcodeScanRes = '';
      }
      cnpjController.text = barcodeScanRes;
    });
  }

}
