
class Produto {
  Produto({
    this.codbarras,
    this.codfabricante,
    this.codmarca,
    this.codproduto,
    this.desmarca,
    this.desproduto,
    this.localizacao,
    this.localizacao1,
    this.localizacao2,
    this.localizacao3,
    this.posicao,
    this.quantidade,
    this.codbarras2,
  });

  String codbarras;
  String codbarras2;
  String codfabricante;
  String codmarca;
  String codproduto;
  String desmarca;
  String desproduto;
  String localizacao;
  String localizacao1;
  String localizacao2;
  String localizacao3;
  int posicao;
  String quantidade;


  factory Produto.fromJson(Map<String, dynamic> json) => Produto(
    codbarras: json["codbarras"],
    codfabricante: json["codfabricante"],
    codmarca: json["codmarca"],
    codproduto: json["codproduto"],
    desmarca: json["desmarca"],
    desproduto: json["desproduto"],
    localizacao: json["localizacao"],
    localizacao1: json["localizacao1"],
    localizacao2: json["localizacao2"],
    localizacao3: json["localizacao3"],
    posicao: json["posicao"],
    quantidade: json["quantidade"],
    codbarras2: json["codbarras2"],
  );

  Map<String, dynamic> toJson() => {
    "codbarras": codbarras,
    "codfabricante": codfabricante,
    "codmarca": codmarca,
    "codproduto": codproduto,
    "desmarca": desmarca,
    "desproduto": desproduto,
    "localizacao": localizacao,
    "localizacao1": localizacao1,
    "localizacao2": localizacao2,
    "localizacao3": localizacao3,
    "posicao": posicao,
    "quantidade": quantidade,
    "codbarras2": codbarras2,
  };
}
