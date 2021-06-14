

class DadosBalanco {
  int id;
  String barras;
  String cnpjInicial;
  String codAcesso;


  DadosBalanco({this.id, this.barras, this.cnpjInicial, this.codAcesso});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'barras': barras,
      'cnpjInicial': cnpjInicial,
      'codAcesso': codAcesso,
    };
    return map;
  }

  DadosBalanco.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    barras = map['barras'];
    cnpjInicial = map['cnpjInicial'];
    codAcesso = map['codAcesso'];
  }


}