
import 'package:flutter/cupertino.dart';

class ChaveAcesso extends ChangeNotifier {
  String _chave;
  String _cnpj;
  String _dataenvio;
  int _eliminada;
  String _empresa;
  int _encerrada;
  String _info;
  String _service;
  int _usada;

  ChaveAcesso({chave, cnpj, dataenvio, eliminada, empresa, encerrada, info, service, usada});

  String get chave => _chave;
  String get cnpj => _cnpj;
  String get dataenvio => _dataenvio;
  int get eliminada => _eliminada;
  String get empresa => _empresa;
  int get encerrada => _encerrada;
  String get info => _info;
  String get service => _service;
  int get usada => _usada;

  set chave(String value) {_chave = value; notifyListeners();}
  set cnpj(String value) {_cnpj = value; notifyListeners();}
  set dataenvio(String value) {_dataenvio = value; notifyListeners();}
  set eliminada(int value) {_eliminada = value; notifyListeners();}
  set empresa(String value) {_empresa = value; notifyListeners();}
  set encerrada(int value) {_encerrada = value; notifyListeners();}
  set info(String value) {_info = value; notifyListeners();}
  set service(String value) {_service = value; notifyListeners();}
  set usada(int value) {_usada = value; notifyListeners();}

  factory ChaveAcesso.fromJson(Map<String, dynamic> json) =>
      new ChaveAcesso(
        chave: json['chave'],
        cnpj: json['cnpj'],
        dataenvio: json['dataenvio'],
        eliminada: json['eliminada'],
        empresa: json['empresa'],
        encerrada: json['encerrada'],
        info: json['info'],
        service: json['service'],
        usada: json['usada'],
      );


  Map<String, dynamic> toMap() {
    return {
      'chave': chave,
      'cnpj': cnpj,
      'dataenvio': dataenvio,
      'eliminada': eliminada,
      'empresa': empresa,
      'encerrada': encerrada,
      'info': info,
      'service': service,
      'usada': usada,
    };
  }

  ChaveAcesso.fromMap(Map<String, dynamic> map) {
    chave = map['chave'];
    cnpj = map['cnpj'];
    dataenvio = map['dataenvio'];
    eliminada = map['eliminada'];
    empresa = map['empresa'];
    encerrada = map['encerrada'];
    info = map['info'];
    service = map['service'];
    usada = map['usada'];

  }
}