import 'package:balanco_app/componentes/api/produtos/produto.dart';
import 'package:flutter/cupertino.dart';

class VarFixas extends ChangeNotifier {
  String chaveEncontrada = 'Chave encontrada';
  String chaveNaoEncontrada = 'Chave não encontrada !';
  String token = '5cc22848-0bc0-47c2-a580-68dea641f77a';
  String tokenPost = "453831a1-cdc1-4e00-8ac6-75054e72f4a5";


  int _entradaTela;
  get entradaTela => _entradaTela;
  set entradaTela(int value) {
    _entradaTela = value;
    notifyListeners();
  }


  int _nrPaginaEndpoint;
  get nrPaginaEndpoint => _nrPaginaEndpoint;
  set nrPaginaEndpoint(int value) {
    _nrPaginaEndpoint = value;
    notifyListeners();
  }

  bool _loading = false;
  get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool _loadingbd = false;
  get loadingbd => _loadingbd;
  set loadingbd(bool value) {
    _loadingbd = value;
    notifyListeners();
  }

  bool _passou;
  get passouget => _passou;
  set passouset(bool value) {
    _passou = value;
    notifyListeners();
  }

  bool _verificaCahave;
  get verificaCahave => _verificaCahave;
  set verificaCahave(bool value) {
    _verificaCahave = value;
    notifyListeners();
  }
}

enum OpcaoRaio { BE, CC, GM, CL, AC } //0, 1, 2, 3, 4
