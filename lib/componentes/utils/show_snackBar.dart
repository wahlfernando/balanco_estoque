import 'package:flutter/material.dart';

class ShowSnackBar{

  ShowSnackBar(this.context, this.texto, this.corFundo);

  final BuildContext context;
  final String texto;
  final Color corFundo;

  Future<void> showMySnackBar() async {
    final snackBar = SnackBar(
      backgroundColor: corFundo,
      content: Text(texto),
      duration: Duration(seconds: 1),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

}