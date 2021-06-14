

import 'package:flutter/material.dart';

class ShowDialog{

  ShowDialog(this.context, this.titulo, this.texto);

  final BuildContext context;
  final String titulo;
  final String texto;

  Future<void> showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
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
              },
            ),
          ],
        );
      },
    );
  }

}