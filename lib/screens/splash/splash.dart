import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:balanco_app/helpers/database_helper.dart';
import 'package:balanco_app/models/dados_acesso.dart';
import 'package:balanco_app/screens/home/tela_inicial.dart';
import 'package:balanco_app/screens/produtos/tela_products.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';


class Splash extends StatelessWidget {

  DatabaseHelper db = DatabaseHelper();

  @override
  Widget build(BuildContext context) {

    resgataDados() async {
      List linhas = await db.getDsDados();
      for (var linha in linhas) {
        context.read<DadosAcesso>().cnpjInicial = linha['cnpjInicial'].toString();
        context.read<DadosAcesso>().usuario = linha['usuario'].toString();
        context.read<DadosAcesso>().codAcesso = linha['codAcesso'].toString();
      }
    }

    return FutureBuilder(
        future: db.getDsDados2(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if(snapshot.data > 0){
              context.read<DadosAcesso>().sincronizando = true;
              context.read<DadosAcesso>().sincronizado = false;
            } else{
              context.read<DadosAcesso>().sincronizando = false;
              context.read<DadosAcesso>().sincronizado = true;
            }

             //print('SINCRONIZADO: ${context.read<DadosAcesso>().sincronizando}');

            resgataDados();

            return AnimatedSplashScreen(
                duration: 1000,
                splash: "assets/images/logotipo.png",
                nextScreen: snapshot.data > 0
                    ? TelaProdutos()
                    : TelaInicialCnpj(),
                splashTransition: SplashTransition.fadeTransition,
                pageTransitionType: PageTransitionType.scale,
                backgroundColor: Colors.green[50]
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

}
