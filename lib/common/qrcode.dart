
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:json_string/json_string.dart';

class QRCode extends ChangeNotifier{

  Future<void> scanQR(TextEditingController cnpj, TextEditingController usu) async {
    // Pega os dados do QrCode:
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancelar", true, ScanMode.QR);
    } on PlatformException {
      barcodeScanRes = '';
    }

    if (barcodeScanRes == '-1') {
      barcodeScanRes = '';
    }

    // decodifica a string para pegar os dados de acesso.
    String decodedText = utf8.decode(base64.decode(barcodeScanRes));
    print(decodedText);

    // Colocando os dados nos campos corespondentes
    final txtConv = JsonString.orNull(decodedText);
    final credentials = txtConv.decodedValue;
    String semMasc = credentials['cnpj'];

    cnpj.text = semMasc.replaceAll('/', '').replaceAll('-', '').replaceAll('.', '');
    usu.text = credentials['usuario'];
    notifyListeners();
  }

  Future<void> scanBarcode(TextEditingController txtBusca) async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancelar", true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Falhou.';
    }

    if (barcodeScanRes == '-1') {
      barcodeScanRes = '';
    }
    txtBusca.text = barcodeScanRes;
  }



}