import 'dart:async';
import 'package:balanco_app/componentes/api/api_codAcesso.dart';
import 'package:balanco_app/services/constantes.dart';

import 'package:http/http.dart' as http;
import 'package:json_string/json_string.dart';

VarFixas varFixas = VarFixas();

Future<bool> endPointConect() async {
  var request = http.Request('GET',Uri.parse('http://balanco.gestaoparts.com.br:7008/v2/app/balanco/teste'));
  request.body = '''''';
  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    String result = await response.stream.bytesToString().timeout(Duration(seconds: 30));
    final txtConv = JsonString.orNull(result);
    final credentials = txtConv.decodedValue;
    String service = credentials['service'];

    if (service.trim() == '[PRD] - Teste Consulta Serviço Balanço V2') {
      return varFixas.passouset = true;
    } else if (service.trim() != '[PRD] - Teste Consulta Serviço Balanço V2') {
      return varFixas.passouset = false;
    }
  } else {
    print(response.reasonPhrase);
  }
}

Future endPointConsultaChave(String user, String cnpj, String chave) async {
  var headers = {'Content-Type': 'application/json'};
  var request = http.Request('GET', Uri.parse('http://balanco.gestaoparts.com.br:7008/v2/app/balanco/chave/consultar'));
  request.body = '''{\r\n\t"cnpj"    : "$cnpj", \r\n\t"chave"   : "$chave",\r\n\t"user"    : "$user",\r\n\t"token"   : "5cc22848-0bc0-47c2-a580-68dea641f77a"\r\n}''';
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    String result = await response.stream.bytesToString().timeout(Duration(seconds: 20));
    final txtConv = JsonString.orNull(result);
    final credentials = txtConv.decodedValue;
    return credentials;
  } else {
    print(response.reasonPhrase);
  }
}


Future<bool> conectCNPJ(String user, String cnpj) async {
  var headers = {'Content-Type': 'application/json'};
  var request = http.Request('POST',
      Uri.parse('http://balanco.gestaoparts.com.br:7008/v2/app/balanco/cnpj'));
  request.body = '''{\r\n "cnpj" : "$cnpj", \r\n "user" : "$user"\r\n}''';
  request.headers.addAll(headers);
  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    String result = await response.stream.bytesToString().timeout(Duration(seconds: 30));
    final txtConv = JsonString.orNull(result);
    final credentials = txtConv.decodedValue;
    String service = credentials['service'];

    if (service.trim() == 'Empresa habilitada para uso do aplicativo') {
      return varFixas.passouset = true;
    } else if (service.trim() == 'Empresa não encontrada ou não habilitada para o uso do aplicativo') {
      return varFixas.passouset = false;
    }
  } else {
    print(response.reasonPhrase);
  }
}
