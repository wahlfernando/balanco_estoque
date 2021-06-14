import 'dart:convert';
import 'package:balanco_app/componentes/api/produtos/produto.dart';
import 'detalhes.dart';

List<ProdutosApi> produtosApiFromJson(String str) => List<ProdutosApi>.from(
    json.decode(str).map((x) => ProdutosApi.fromJson(x)));

String produtosApiToJson(List<ProdutosApi> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProdutosApi {
  ProdutosApi({
    this.chave,
    this.cnpj,
    this.detalhe,
    this.produtos,
    this.service,
  });

  String chave;
  String cnpj;
  Detalhe detalhe;
  List<Produto> produtos;
  String service;

  factory ProdutosApi.fromJson(Map<String, dynamic> json) => ProdutosApi(
        chave: json["chave"],
        cnpj: json["cnpj"],
        detalhe: Detalhe.fromJson(json["detalhe"]),
        produtos: List<Produto>.from(
            json["produtos"].map((x) => Produto.fromJson(x))),
        service: json["service"],
      );

  Map<String, dynamic> toJson() => {
        "chave": chave,
        "cnpj": cnpj,
        "detalhe": detalhe.toJson(),
        "produtos": List<dynamic>.from(produtos.map((x) => x.toJson())),
        "service": service,
      };
}
