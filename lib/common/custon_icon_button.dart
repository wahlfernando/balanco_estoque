import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomIconButton extends StatelessWidget {

  CustomIconButton({this.iconData, this.color, this.onTap, this.size});

  IconData iconData;
  Color color;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect( // esse cara serve para deixar o botão criado em um formato esecifico, arredondado, quadrado, retangular, tanto faz.
      borderRadius: BorderRadius.circular(50),
      child: Material(
        color: Colors.transparent,
        child: InkWell( //usado o InkWell para ter uma animação no botão
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Icon(
              iconData,
              color: onTap !=  null? color : Colors.grey[400],
              size: size ?? 24,
            ),
          ),
        ),
      ),
    );
  }
}
