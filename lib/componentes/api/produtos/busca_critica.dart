
class BuscaCritica {
  BuscaCritica({
    this.referencia,
    this.data,
    this.hora,

  });

  String referencia;
  String data;
  String hora;



  factory BuscaCritica.fromJson(Map<String, dynamic> json) => BuscaCritica(
    referencia: json["referencia"],
    data: json["data"],
    hora: json["hora"],

  );

  Map<String, dynamic> toJson() => {
    "referencia": referencia,
    "data": data,
    "hora": hora,

  };
}
