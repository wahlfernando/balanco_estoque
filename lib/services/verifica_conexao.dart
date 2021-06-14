
import 'dart:async';
import 'package:balanco_app/models/dados_acesso.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class VerificaConexao extends ChangeNotifier{

  DadosAcesso dadosAcesso = DadosAcesso();
  //String status;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  String _status;
  get status => _status;
  set status(String value) {
    _status = value;
    notifyListeners();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return updateConnectionStatus(result);
  }

  Future<void> updateConnectionStatus(ConnectivityResult result) async {
      if (result == ConnectivityResult.mobile) {
        status = "3G/4G";
      } else if (result == ConnectivityResult.wifi) {
        status ="Wi-Fi";
      }else{
        status ="Não Conectado!";
      }
      notifyListeners();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }




}