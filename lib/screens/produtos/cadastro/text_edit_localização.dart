import 'package:flutter/material.dart';

class TextEditLoc extends StatelessWidget {

  String label;
  TextEditingController controller = TextEditingController();
  String valorInicial;

  TextEditLoc({this.label, this.controller, this.valorInicial});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          initialValue: valorInicial,
          controller: controller,
          autocorrect: false,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(2)),
            labelText: label,
            labelStyle: TextStyle(fontSize: 20, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
