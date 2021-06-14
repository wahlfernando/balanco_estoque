
import 'package:flutter/material.dart';


class ShowDialogConexao {
  ShowDialogConexao(this.context, this.titulo, this.texto, {this.icone});

  final BuildContext context;
  final String titulo;
  final String texto;
  final IconData icone;

  Future<void> showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: texto_icon(titulo, icone) ,//Text(titulo),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(texto),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(' OK '),
              onPressed: () {
                Navigator.of(context).pop();
              })
          ],
        );
      },
    );
  }
}

Widget texto_icon(String texto, IconData icone){
  return Row(
    children: [
      Icon(icone),
      Text(texto),
      Icon(icone),
    ],
  );
}
