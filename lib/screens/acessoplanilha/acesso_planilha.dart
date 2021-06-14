import 'package:flutter/material.dart';

class AcessoPlanilha extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                Color.fromARGB(255, 204, 229, 255),
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
                      'Acesso a planilha',
                      style: TextStyle(
                        fontSize: 42,
                        //fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),

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
