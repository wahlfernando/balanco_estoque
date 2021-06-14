import 'package:balanco_app/helpers/database_helper.dart';
import 'package:balanco_app/models/dados_acesso.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustonDrawerHeader extends StatefulWidget {
  @override
  _CustonDrawerHeaderState createState() => _CustonDrawerHeaderState();
}

class _CustonDrawerHeaderState extends State<CustonDrawerHeader> {
  DatabaseHelper db = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    resgataDados() async {
      List linhas = await db.getDsDados();
      for (var linha in linhas) {
        context.read<DadosAcesso>().cnpjInicial = linha['cnpjInicial'].toString();
        context.read<DadosAcesso>().usuario = linha['usuario'].toString();
      }
    }

    resgataDados();

    return Container(
        padding: const EdgeInsets.fromLTRB(32, 24, 16, 8),
        height: 190,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Center(
              child: Container(
                child: Image.asset(
                    "assets/images/logotipo_small.png",
                    fit: BoxFit.cover
                ),
              ),
            ),
            Text(context.read<DadosAcesso>().usuario == null ? '' : context.read<DadosAcesso>().usuario,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(context.read<DadosAcesso>().cnpjInicial == null ? '' : context.read<DadosAcesso>().cnpjInicial,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                fontSize: 16,
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ));
  }

}
