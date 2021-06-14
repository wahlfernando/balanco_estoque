import 'dart:async';
import 'package:balanco_app/models/dados_acesso.dart';
import 'package:balanco_app/screens/home/componentes/acesso_cnpj.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';



class TelaInicialCnpj extends StatefulWidget {

  @override
  _TelaInicialCnpjState createState() => _TelaInicialCnpjState();
}

class _TelaInicialCnpjState extends State<TelaInicialCnpj> {

  String _connectionStatus = 'Rede Desconhecida';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Balanço Mobile'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.green,
                Colors.blueGrey,
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
                      'Seja bem-vindo',
                      style: TextStyle(
                        fontSize: 48,
                        //fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 30,
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
                      height: 20,
                    ),
                    Text(
                      'Balanço Mobile 2.0',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TelaAcessoCnpj(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
                      child: Text('Conexão Ativa  --->  ${_connectionStatus}', style: TextStyle(fontSize: 16),) ,
                    )

                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {

      if (result == ConnectivityResult.mobile) {
        _connectionStatus = "3G/4G";
        context.read<DadosAcesso>().resultConect = true;
      } else if (result == ConnectivityResult.wifi) {
        _connectionStatus ="Wi-Fi";
        context.read<DadosAcesso>().resultConect = true;
      }else{
        _connectionStatus ="Não Conectado!";
        context.read<DadosAcesso>().resultConect = false;
      }
    }
    );
  }
}

