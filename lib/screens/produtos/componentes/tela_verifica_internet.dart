
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class VerificaInternet extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.white,
      child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 150,
              ),
              Text("PROBLEMAS COM CONEXÃO",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black)
              ),
              SizedBox(
                height: 40,
              ),
              Text("O processo de sincronização para baixar os dados de produtos está interrompido.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black)
              ),
              SizedBox(
                height: 40,
              ),
              Text("Verifique sua internet para voltar a baixar os produtos..",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black)
              ),
              SizedBox(
                height: 40,
              ),
              SizedBox(
                  height: 90,
                  width: 90,
                  child:  CircularProgressIndicator()
              ),
              SizedBox(
                height: 40,
              ),
            ],
          )
      ),
    );
  }
}
