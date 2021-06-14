

class Detalhe {

  Detalhe({
    this.paginas,
  });

  int paginas;

  factory Detalhe.fromJson(Map<String, dynamic> json) => Detalhe(
    paginas: json["paginas"],
  );

  Map<String, dynamic> toJson() => {
    "paginas": paginas,
  };


}
