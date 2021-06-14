import 'dart:async';
import 'package:balanco_app/models/dados_acesso.dart';
import 'package:balanco_app/componentes/api/produtos/produto.dart';
import 'package:balanco_app/helpers/database_helper.dart';
import 'package:balanco_app/screens/produtos/tela_products.dart';
import 'package:balanco_app/services/constantes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:json_string/json_string.dart';
import 'package:dio/dio.dart';
import 'package:safe_url_check/safe_url_check.dart';
import 'package:sqflite/sqflite.dart';
import 'package:provider/provider.dart';

VarFixas varFixas = VarFixas();

class Endpoints extends ChangeNotifier{

  final List<Produto> listProd = List();
  TelaProdutos telaProdutos = TelaProdutos();

  Future<bool> verifica_conexao() async {
    var request = http.Request('GET',Uri.parse("http://balanco.gestaoparts.com.br:7008/v2/app/balanco/teste"));
    request.body = '''''';
    try{
      http.StreamedResponse response = await request.send().timeout(Duration(seconds: 5));

      if (response.statusCode == 200) {
        String result = await response.stream.bytesToString();
        final txtConv = JsonString.orNull(result);
        final credentials = txtConv.decodedValue;
        String service = credentials['service'];
        return true;

      } else {
        print(response.reasonPhrase);
        return false;
      }
    } catch(e){
      print('Erro obtido pelo TRY: $e');
    }
  }

  Future<bool> verifica_cnpj(String user, String cnpj) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST',
        Uri.parse(
            'http://balanco.gestaoparts.com.br:7008/v2/app/balanco/cnpj'));
    request.body = '''{\r\n "cnpj" : "$cnpj", \r\n "user" : "$user"\r\n}''';
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String result =
          await response.stream.bytesToString().timeout(Duration(seconds: 30));
      final txtConv = JsonString.orNull(result);
      final credentials = txtConv.decodedValue;
      String service = credentials['service'];

      return varFixas.passouset = true;

      // if (service.trim() == 'Empresa habilitada para uso do aplicativo') {
      //   return varFixas.passouset = true;
      // } else if (service.trim() ==
      //     'Empresa não encontrada ou não habilitada para o uso do aplicativo') {
      //   return varFixas.passouset = false;
      // }
    } else {
      print(response.reasonPhrase);
      return varFixas.passouset = false;
    }
  }

  Future consulta_chave(String user, String cnpj, String chave) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('GET',Uri.parse('http://balanco.gestaoparts.com.br:7008/v2/app/balanco/chave/consultar'));
    request.body ='''{\r\n\t"cnpj"    : "$cnpj", \r\n\t"chave"   : "$chave",\r\n\t"user"    : "$user",\r\n\t"token"   : "${varFixas.token}"\r\n}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String result =
          await response.stream.bytesToString().timeout(Duration(seconds: 20));
      final txtConv = JsonString.orNull(result);
      final credentials = txtConv.decodedValue;
      return credentials;
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<List<Produto>>   resgata_produtos(String user, String cnpj, String chave, int i) async {
    varFixas.loading = true;
    DatabaseHelper databaseHelper = DatabaseHelper();
    Dio dio = new Dio();

    Database db;

    print('http://balanco.gestaoparts.com.br:7008/v2/app/balanco/chave/produto/consultar/$cnpj/$chave/$user/$i/${varFixas.token}');
    var responseInicial = await dio.request('http://balanco.gestaoparts.com.br:7008/v2/app/balanco/chave/produto/consultar/$cnpj/$chave/$user/$i/${varFixas.token}').timeout(Duration(seconds: 60));

      if (responseInicial.statusCode == 200) {
        (responseInicial.data['produtos'] as List).map((produtos) async {
          listProd.add(Produto(
            codbarras: produtos['codbarras'],
            codfabricante: produtos['codfabricante'],
            codmarca: produtos['codmarca'],
            codproduto: produtos['codproduto'],
            desmarca: produtos['desmarca'],
            desproduto: produtos['desproduto'],
            localizacao: produtos['localizacao'],
            localizacao1: produtos['localizacao1'],
            localizacao2: produtos['localizacao2'],
            localizacao3: produtos['localizacao3'],
            posicao: produtos['posicao'],
            quantidade: '0',
            codbarras2: produtos['codbarras2'],
          ));
        }).toList();
      } else {
        print('Erro...');
      }



    varFixas.loading = false;
  }


  Future<void> showMyDialogInternetRuim(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('REDE'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Sua rede esté conectada porém mostra algumas falhas, verifique para voltar a fazer a sincronização.'
                    '\nForam feitas 3 tentativas de conexão sem sucesso.'
                    '\nVerifique sua rede.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(' OK '),
              onPressed: () async{

                final existConnection = await safeUrlCheck(
                  Uri.parse('http://balanco.gestaoparts.com.br:7008/v2/app/balanco/teste'),
                  userAgent: 'myexample/1.0.0 (+https://example.com)',
                );

                if(existConnection){
                  Navigator.of(context).pop();
                } else{
                  debugPrint('Erro de conexão com o endpoint por motivos de internet fraca');
                }
              },
            ),
          ],
        );
      },
    );
  }

} //fim classe Endpoint
