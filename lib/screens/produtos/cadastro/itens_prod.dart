import 'package:flutter/material.dart';

class ItensProduto extends StatelessWidget {

  String titulo;
  String descricao;

  ItensProduto({this.titulo, this.descricao});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: Text(this.titulo,
            style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 30, 8, 10),
          child: Container(

            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide( //                    <--- top side
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
            ),
            child: Text(this.descricao,
              style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.normal),
            ),
          ),
        ),
      ],
    );
  }
}
