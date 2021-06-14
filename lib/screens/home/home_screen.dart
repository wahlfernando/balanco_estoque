
import 'package:balanco_app/screens/cards/card_acesso_cnpj.dart';
import 'package:flutter/material.dart';

class HomeScreen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Balanço Mobile'),
      ),
      //drawer: CustonDrawer(),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.green,
                Colors.blueGrey,
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            ),
          ),
          ListView(
            children: [
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Image.asset(
                          "assets/images/logotipo_small.png",
                          fit: BoxFit.fill
                      ),
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      'Seja bem-vindo',
                      style: TextStyle(
                        fontSize: 48,
                        //fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Identifique-se para ter acesso',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Balanço Mobile 2',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CardAcessoCnpj(),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
