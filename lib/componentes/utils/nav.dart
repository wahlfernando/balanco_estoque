import 'package:flutter/material.dart';

push(BuildContext context, Widget page, {bool replace = false}) {
  if(replace) {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return page;
    }));
  }

  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
    return page;
  }));
}




