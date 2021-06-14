
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeColors extends ChangeNotifier{
  Color _color;

  Color cor1 = Colors.green;
  Color cor2 = Colors.blueGrey;
  Color cor3 = Colors.blueAccent;

  isColor() => _color;

  setColorTheme(String status){

    //Aqui muda as cores do sistema

    if(status == '0'){
      _color = cor1;
    } else if(status == '1'){
      _color = cor2;
    } else if(status == '2'){
      _color = cor3;
    }
    notifyListeners();
  }




}