import 'package:balanco_app/componentes/api/produtos/busca_critica.dart';
import 'package:balanco_app/componentes/api/produtos/produto.dart';
import 'package:flutter/material.dart';

class DadosAcesso extends ChangeNotifier{

  DadosAcesso({cnpjInicial, usuario, codAcesso, configAcesPlanilha1, configAcesPlanilha2,
    rede_ativa, listProd, qtde, listProdEnvio, listCriticaEnvio});

  String _cnpjInicial;
  String _usuario;
  String _codAcesso;
  String _configAcesPlanilha1;
  String _configAcesPlanilha2;
  String _rede_ativa;
  String _codBarra;
  List<Produto> _listProd = List();
  List<Produto> _listProdEnvio = List();
  List<BuscaCritica> _listCriticaEnvio = List();
  List<Produto> _listaProdSincCircular = List();
  String _qtde;
  String _pagTotais;
  bool _search;
  bool _sinc;
  bool _atualiza;
  Color _color = Colors.black;
  bool _sincronizando = false;
  bool _sincronizado = false;
  bool _pesquisando = false;
  int _valorJ = 0;
  int _valorI = 0;
  bool _resultConect = true;
  bool _erroEndpoint = false;



  //Getters
  String get cnpjInicial => _cnpjInicial;
  String get usuario => _usuario;
  String get codAcesso => _codAcesso;
  String get configAcesPlanilha1 => _configAcesPlanilha1;
  String get configAcesPlanilha2 => _configAcesPlanilha2;
  String get codBarra => _codBarra;
  String get rede_ativa => _rede_ativa;
  List<Produto> get listProd => _listProd;
  List<Produto> get listProdEnvio => _listProdEnvio;
  List<Produto> get listaProdSincCircular => _listaProdSincCircular;
  List<BuscaCritica> get listCriticaEnvio => _listCriticaEnvio;
  String get qtde => _qtde;
  String get pagTotais => _pagTotais;
  Color get color => _color;
  bool get search => _search;
  bool get sinc => _sinc;
  bool get atualiza => _atualiza;
  bool get sincronizando => _sincronizando;
  bool get sincronizado => _sincronizado;
  bool get pesquisando => _pesquisando;
  int get valorJ => _valorJ;
  int get valorI => _valorI;
  bool get resultConect => _resultConect;
  bool get erroEndpoint => _erroEndpoint;



  //Setter
  set cnpjInicial(String value) {_cnpjInicial = value;}
  set usuario(String value) {_usuario = value;}
  set codAcesso(String value) {_codAcesso = value;}
  set configAcesPlanilha1(String value) {_configAcesPlanilha1 = value;}
  set configAcesPlanilha2(String value) {_configAcesPlanilha2 = value;}
  set codBarra(String value) {_codBarra = value;}
  set rede_ativa(String value) {_rede_ativa = value; notifyListeners();}
  set listProd(List<Produto> value) {_listProd = value;notifyListeners();}
  set listProdEnvio(List<Produto> value) {_listProdEnvio = value; notifyListeners();}
  set listCriticaEnvio(List<BuscaCritica> value) {_listCriticaEnvio = value; notifyListeners();}
  set listaProdSincCircular(List<Produto> value) {_listaProdSincCircular = value; notifyListeners();}
  set qtde(String value) {_qtde = value;}
  set pagTotais(String value) {_pagTotais = value;}
  set color(Color value) {_color = value;}
  set search(bool value) {_search = value;}
  set sinc(bool value) {_sinc = value; notifyListeners();}
  set atualiza(bool value) {_atualiza = value;}
  set sincronizando(bool value) {_sincronizando = value;}
  set sincronizado(bool value) {_sincronizado = value;}
  set pesquisando(bool value) {_pesquisando = value;}
  set valorJ(int value) {_valorJ = value;notifyListeners();}
  set valorI(int value) {_valorI = value;notifyListeners();}
  set resultConect(bool value) {_resultConect = value;}
  set erroEndpoint(bool value) {_erroEndpoint = value;}


  factory DadosAcesso.fromJson(Map<String, dynamic> json) => new DadosAcesso(
    cnpjInicial: json["cnpjInicial"],
    usuario: json["usuario"],
    codAcesso: json["codAcesso"],
    configAcesPlanilha1: json["configAcesPlanilha1"],
    configAcesPlanilha2: json["configAcesPlanilha2"],
    rede_ativa: json["rede_ativa"],
    listProd: json["listProd"],
    listProdEnvio: json["listProdEnvio"],
    listCriticaEnvio: json["listCriticaEnvio"],
  );

  Map<String, dynamic> toMap() {
    return {
      'cnpjInicial': cnpjInicial,
      'usuario': usuario,
      'codAcesso': codAcesso,
      'configAcesPlanilha1': configAcesPlanilha1,
      'configAcesPlanilha2': configAcesPlanilha2,
      'rede_ativa': rede_ativa,
      'listProd': listProd,
      'listProdEnvio': listProdEnvio,
      'listCriticaEnvio': listCriticaEnvio,

    };
  }

  DadosAcesso.fromMap(Map<String, dynamic> map) {
    cnpjInicial = map['cnpjInicial'];
    usuario = map['usuario'];
    codAcesso = map['codAcesso'];
    configAcesPlanilha1 = map['configAcesPlanilha1'];
    configAcesPlanilha2 = map['configAcesPlanilha2'];
    rede_ativa = map['rede_ativa'];
    listProd: map["listProd"];
    listProdEnvio: map["listProdEnvio"];

  }



}

