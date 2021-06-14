import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:balanco_app/componentes/api/conexao/endpoints_api.dart';
import 'package:balanco_app/common/drawer/custon_drawer.dart';
import 'package:balanco_app/common/qrcode.dart';
import 'package:balanco_app/componentes/api/produtos/produto.dart';
import 'package:balanco_app/componentes/utils/show_dialog.dart';
import 'package:balanco_app/helpers/database_helper.dart';
import 'package:balanco_app/models/dados_acesso.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dynamic_color_theme/dynamic_color_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:safe_url_check/safe_url_check.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'cadastro/cadastro_produto.dart';
import 'package:http/http.dart' as http;

enum ModuloAcesso { balanco, conferencia, guarda_mercadoria }

const cor1 = Colors.green;
const cor2 = Colors.blueGrey;
const cor3 = Colors.blueAccent;


class TelaProdutos extends StatefulWidget {
  @override
  _TelaProdutosState createState() => _TelaProdutosState();
}

Color primaryColor;

class _TelaProdutosState extends State<TelaProdutos> {

  final textoBuscaController = TextEditingController();
  final textoQtdeController = TextEditingController();
  Produto produto = Produto();
  Dio dio = new Dio();

  Future<bool> connectionStatus;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  DatabaseHelper db = DatabaseHelper();
  Endpoints endpoints = Endpoints();
  int _rowPerPage = PaginatedDataTable.defaultRowsPerPage;
  QRCode qrcode = QRCode();
  FocusNode _focusNodeBusca;
  FocusNode _focusNodeQtde;
  String retConfig;
  Color primaryColor;
  String enderecoTesteConexao = 'http://balanco.gestaoparts.com.br:7008/v2/app/balanco/teste';
  String sCnpj;
  String sUser;
  String sChave;
  Future<List<Produto>> _future;
  int pagTotais = 0;
  bool ativo = false;
  bool ativoBusca = false;
  bool terminado = false;
  int totProdCircular = 0;
  int totalPrpodutos = 1;
  int totalPaginas = 0;
  double totalPorcento = 0;
  String descricaoSincronismo = '';
  int qtdeProd = 0;
  int j = 1;
  int i = 1;
  bool estousincronizando = false;
  bool bloqueia = false;
  int sinalWifi = 0;



  @override
  void initState() {
    super.initState();
    textoBuscaController.clear();
    resgataDados();
    _focusNodeBusca = FocusNode();
    _focusNodeQtde = FocusNode();
    sCnpj = context.read<DadosAcesso>().cnpjInicial;
    sUser = context.read<DadosAcesso>().usuario;
    sChave = context.read<DadosAcesso>().codAcesso;
    context.read<DadosAcesso>().search = false;
    _future = dados();
    //initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
    onUpdate();
    resgataDados();
    _focusNodeBusca.dispose();
    _focusNodeQtde.dispose();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  @override
  Widget build(BuildContext context) {

    primaryColor = Theme.of(context).primaryColor;
    resgataDados();


    setState(() {
      if(estousincronizando == true){
        bloqueia = true;
      } else{
        bloqueia = false;
      }
    });


    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        title: Text('Balanço Mobile'),
        actions: [
          !context.read<DadosAcesso>().resultConect
              ? IconButton(
                  icon: Icon(
                    Icons.wifi,
                    color: Colors.redAccent,
                  ),
                  onPressed: () {},
                )
              : Container(),
          IconButton(
            icon: Icon(
              Icons.grid_on,
              color: Colors.white,
            ),
            onPressed: () {
              if(estousincronizando == false){
                ativo = false;
                textoQtdeController.clear();
                executabusca(false);
              }
            },
          ),
          PopupMenuButton<ModuloAcesso>(
            onSelected: (ModuloAcesso result) {
              setState(() async{

                if(estousincronizando == false){
                  List produtos = await db.getAllProdutosQtdeMaiorZero();

                  if(produtos.length > 0){
                    final showDialog = ShowDialog(context, ' A T E N Ç Ã O ', 'Dados ainda não sincronizados.. '
                        '\nFavor sincronizar os dados para que possa trocar a forma de uso do Aplicativo. '
                        '\nMenu > Sincronizar', icone: Icons.stream );
                    showDialog.showMyDialog();
                  } else{
                    if (result == ModuloAcesso.balanco) {
                      context.read<DadosAcesso>().configAcesPlanilha1 = '0';
                      onUpdate();
                    }
                    if (result == ModuloAcesso.conferencia) {
                      // Temporário:
                      final showDialog = ShowDialog(context, 'Atenção',
                          '\nA opção: "Conferência (Entrada/Saída)", será liberada na versão 2.1');
                      showDialog.showMyDialog();
                      // context.read<DadosAcesso>().configAcesPlanilha1 = '1';
                      // onUpdate();
                    }
                    if (result == ModuloAcesso.guarda_mercadoria) {
                      // Temporário:
                      final showDialog = ShowDialog(context, 'Atenção',
                          '\nA opção: "Guarda de Mercadoria", será liberada na versão 2.1');
                      showDialog.showMyDialog();
                      // context.read<DadosAcesso>().configAcesPlanilha1 = '2';
                      // onUpdate();
                    }
                  }
                }

              });
            },
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<ModuloAcesso>>[
              const PopupMenuItem<ModuloAcesso>(
                value: ModuloAcesso.balanco,
                child: ListTile(
                  dense: false,
                  contentPadding: EdgeInsets.all(0),
                  leading: Icon(Icons.store, color: Colors.green, size: 40),
                  title: Text('Balanço de Estoque'),
                ),
              ),
              const PopupMenuItem<ModuloAcesso>(
                value: ModuloAcesso.conferencia,
                child: ListTile(
                  contentPadding: EdgeInsets.all(0),
                  leading:
                      Icon(Icons.card_travel, color: Colors.blueGrey, size: 40),
                  title: Text('Conferência (Entrada / Saída)'),
                ),
              ),
              const PopupMenuItem<ModuloAcesso>(
                  value: ModuloAcesso.guarda_mercadoria,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(0),
                    leading: Icon(Icons.directions_car_rounded,
                        color: Colors.blueAccent, size: 40),
                    title: Text('Guarda Mercadoria'),
                  )),

            ],
          )
        ],
      ),
      drawer: CustonDrawer(),
      body: tela_produto(),
    );
  }


  Widget tela_produto() {

    return Stack(
      children: [
        Container(
          color: Colors.white,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 8, 0),
          child: TextFormField(
            enabled: !bloqueia,
            textCapitalization: TextCapitalization.characters,
            autofocus: true,
            focusNode: _focusNodeBusca,
            controller: textoBuscaController,
            textInputAction: TextInputAction.none,
            textAlign: TextAlign.justify,
            autocorrect: false,
            decoration: InputDecoration(
              labelText: '  Busca...',
              hintText: 'Descrição / Cód. Interno / Cód. Barras.',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
              suffixIcon: IconButton(
                  iconSize: 32,
                  color: primaryColor,
                  icon: Padding(
                    padding: const EdgeInsetsDirectional.only(start: 8.0),
                    child: const Icon(Icons.search),
                  ),
                  onPressed: () {
                    context.read<DadosAcesso>().search = false;
                    EasyLoading.showToast('Buscando Produto....', duration: Duration(milliseconds: 1500) );
                    executabusca(true, txt: textoBuscaController.text);
                    textoBuscaController.clear();

                  }),
            ),
            onChanged: (txt){
              if(context.read<DadosAcesso>().search){
                bool verTipo = false;
                try {
                  int x = int.parse(txt);
                } catch (e) {
                  verTipo = true;
                }
                if (verTipo) {
                  print('Descrição ou fabricante');
                } else {
                  if (txt.length == 6) {
                    print('Interno');
                  } else {
                    print('Codigo barras');
                    context.read<DadosAcesso>().search = true;
                    Future.delayed(Duration(milliseconds: 500), () {
                      executabusca(true, txt: textoBuscaController.text);
                    });

                  }
                }
                context.read<DadosAcesso>().search = false;

              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 70, 8, 0),
          child: TextFormField(
            enabled: ativo ? true : false,
            inputFormatters: [
              new LengthLimitingTextInputFormatter(8),
            ],
            focusNode: _focusNodeQtde,
            controller: textoQtdeController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.justify,
            autocorrect: false,
            decoration: InputDecoration(
              labelText: 'Quantidade',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
              suffixIcon: IconButton(
                  iconSize: 32,
                  color: primaryColor,
                  icon: Padding(
                    padding: const EdgeInsetsDirectional.only(start: 8.0, end: 8.0),
                    child: const Icon(Icons.save),
                  ),
                  onPressed: () {
                    updateProdutoQtde(textoQtdeController.text, context.read<DadosAcesso>().codBarra);
                    ativo = false;
                    executabusca(false);
                    _focusNodeBusca.requestFocus();
                    textoQtdeController.clear();
                    textoBuscaController.clear();
                  }),
            ),
            autofocus: true,
          ),
        ),
        Padding( // Botão Escanear
          padding: EdgeInsets.fromLTRB(10, 128, 8, 0),
          child: SizedBox(
            height: 44,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              onPressed: () {
                if(bloqueia == false){
                  textoQtdeController.clear();
                  scanBarcode();
                  context.read<DadosAcesso>().search = true;
                  Future.delayed(Duration(milliseconds: 500), () {
                    setState(() {
                      _focusNodeQtde.requestFocus();
                    });
                  });
                }

              },
              color: Colors.white,
              textColor: Theme.of(context).primaryColor,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ESCANEAR',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Icon(
                      Icons.camera_alt,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Divider(
          height: 354,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 182, 8, 8),
          child: Container(
            child: ListView(
              children: [
                FutureBuilder(
                  future: _future,
                  builder: (BuildContext context, AsyncSnapshot<List<Produto>> snapshot) {
                    if (snapshot.hasData) {

                      DTS dts = DTS(snapshot.data, context);
                      return PaginatedDataTable(
                        onRowsTotalRegistros: pagTotais,
                        showCheckboxColumn: false,
                        rowsPerPage: _rowPerPage,
                        availableRowsPerPage: [12],
                        sortAscending: true,
                        sortColumnIndex: 1,
                        columnSpacing: 1,
                        dataRowHeight: 40,
                        horizontalMargin: 10,
                        headingRowHeight: 30,
                        header: Text(''),
                        columns: [
                          DataColumn(
                            label: Text(
                              'Cód. Barras',
                              style: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Descrição',
                              style: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Qtde',
                              style: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                        ],
                        source: dts,
                        onRowsPerPageChanged: (r) {
                          setState(() {
                            _rowPerPage = r;
                          });
                        },
                      );
                    } else {
                      return circularProgressGP();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      if ((result == ConnectivityResult.mobile) || (result == ConnectivityResult.wifi)) {
        //se tem conexão faz isso:
        context.read<DadosAcesso>().resultConect = true;
        if(estousincronizando == true){
          setState(() {
            dados();
          });
        }

      }else{
        //se não tem conexão faz isso:
        context.read<DadosAcesso>().resultConect = false;
        if(estousincronizando == true){
          showMyDialogConexao();
          setState(() {
            context.read<DadosAcesso>().sincronizado = true;
          });
        }
      }
    });
  }

  showMyDialogConexao(){
    return showDialog<void>(
      barrierColor: Color(0x01000000),
      context: context,
      // barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: texto_icon(' A T E N Ç Ã O ', Icons.wifi),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Restabeleça a conexão para terminar o carregamento dos produtos.'),
              ],
            ),
          ),
          // actions: <Widget>[
          //   TextButton(
          //     child: Text(' OK '),
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     }
          //  )
          // ],
        );
      },
    );
  }

  // Future<void> showMyDialogInternetRuim() async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: true,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('REDE'),
  //         content: SingleChildScrollView(
  //           child: ListBody(
  //             children: <Widget>[
  //               Text('Sua rede esté conectada porém mostra algumas falhas, verifique para voltar a fazer a sincronização.'
  //                   '\n\nForam feitas 3 tentativas de conexão sem sucesso.'
  //                   '\n\nRestabelaça a conexão e clique em "OK".'),
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: Text(' OK '),
  //             onPressed: () {
  //               setState(() {
  //                 context.read<DadosAcesso>().sincronizado = true;
  //               });
  //               dados();
  //               Navigator.pop(context);
  //
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  //
  //
  // }

  Widget texto_icon(String texto, IconData icone){
    return Row(
      children: [
        Icon(icone),
        Text(texto),
        Icon(icone),
      ],
    );
  }

  Future<void> scanBarcode() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancelar", true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Falhou.';
    }

    if (barcodeScanRes == '-1') {
      barcodeScanRes = '';
    }
    executabusca(true, txt: barcodeScanRes.trim());
  }

  updateProdutoQtde(String qtde, String codbarras) async {
    try {
      db.updateProduto('UPDATE produto SET quantidade = "$qtde", sincronizado = "" where codbarras = $codbarras');
    } catch (e) {
      print('Erro UPDATE');
    }
    await db.getQtdeProdutos(codbarras);
  }

  Future<List<Produto>> dadosBusca(String txt) async {
    DatabaseHelper db = DatabaseHelper();
    List produtos = [];
    bool verTipo = false;
    Future<List> listFuture;

    try {
      int x = int.parse(txt);
    } catch (e) {
      verTipo = true;
    }


    if (verTipo) {
      produtos = await db.getProdutosBusca(txt, 'descricao');
      if (produtos.length == 0) {
        produtos = await db.getProdutosBusca(txt, 'codfabricante');
      }
    } else {
      if (txt.length == 6) {
        produtos = await db.getProdutosBusca(txt, 'internoss');
      } else {
        produtos = await db.getProdutosBusca(txt, 'codbarras');
        context.read<DadosAcesso>().codBarra = txt;

        if (produtos.length == 0) {
          produtos = await db.getProdutosBusca(txt, 'codbarras2');

          if (produtos.length == 0) {
            String data;
            String hora;
            var data_hora = DateTime.now();
            data = data_hora.toString().substring(0, 10);
            hora = data_hora.toString().substring(11, 19);
            onGravarCritica(data, hora, txt);
          }
        }
      }
    }

    if(produtos.length == 1){
      ativo = true;
    } else { ativo = false;}

    if (produtos.length == 0) {
      Future.delayed(Duration(milliseconds: 1000), () {
        final showDialog = ShowDialog(context, 'Busca...',
            'Nenhum resultado encontrado. \nFavor realizar outra busca.');
        showDialog.showMyDialog();
        executabusca(false);
      });
    }

    context.read<DadosAcesso>().listProd.clear();

    setState(() {
      produtos.forEach((element) {
        context.read<DadosAcesso>().listProd.add(Produto(
              codbarras: element['codbarras'],
              codbarras2: element['codbarras2'],
              desproduto: element["desproduto"],
              codfabricante: element["codfabricante"],
              desmarca: element["desmarca"],
              quantidade: element["quantidade"],
              localizacao1: element["localizacao1"],
              localizacao2: element["localizacao2"],
              localizacao3: element["localizacao3"],
            ));
      });
    });
    return context.read<DadosAcesso>().listProd;
  }

  Future<List<Produto>> dados() async {

    DatabaseHelper db = DatabaseHelper();
    List produtos;
    List<Produto> listaProduto;

    bloqueia = true;
    pagTotais = await db.queryRowCount();
    context.read<DadosAcesso>().pagTotais = pagTotais.toString();
    produtos = await db.getAllProdutos();

    if( (produtos.isEmpty) || (context.read<DadosAcesso>().sincronizado) ){

      var responseInicial = await dio.request('http://balanco.gestaoparts.com.br:7008/v2/app/balanco/chave/produto/consultar/$sCnpj/$sChave/$sUser/0/${varFixas.token}').timeout(Duration(seconds: 120));

      //Verificador de conexão rapida para verificar desempenho da internet.
      final responseVerConexao = await dio.request(enderecoTesteConexao).timeout(Duration(seconds: 10));

      var paginas = responseInicial.data['detalhe']['paginas'];

      if (responseInicial.statusCode == 200) {
        try{
          db.deleteAllPagina();
        } catch (e){
          print('Deletar: $e');
        }

        try{
          db.incluirPagina('insert into detalhe (paginas) values ("$paginas") ');
        } catch (e){
          print('Incluir: $e');
        }
      }

      totalPaginas = paginas * 1000;

      while (j <= paginas) {
        estousincronizando = true;

        sinalWifi = await WiFiForIoTPlugin.getCurrentSignalStrength();

        await endpoints.resgata_produtos(sUser, sCnpj, sChave, j);
        j = j + 1;

        setState(() {
          totalPrpodutos = (j * 1000);
          totalPorcento = totalPrpodutos / 1000;
          descricaoSincronismo = '${totalPrpodutos.toString()} produtos sincronizados de ${paginas}000';
        });

        context.read<DadosAcesso>().valorJ = j;
        try{
          await db.insertProdutos(endpoints.listProd).timeout(Duration(seconds: 60));
          qtdeProd = qtdeProd + endpoints.listProd.length;
          setState(() {
            descricaoSincronismo = '$qtdeProd salvos.';
          });
          endpoints.listProd.clear();
        } catch (e){
          print(e);
        }
        i = 0;
      }

      context.read<DadosAcesso>().sincronizado = false;
      context.read<DadosAcesso>().listProd.clear();

      if(produtos.length < totalPaginas){
        estousincronizando = true;
      } else {
        estousincronizando = false;
      }


      // estousincronizando = false;

      produtos = await dados();
    } else {
      context.read<DadosAcesso>().listProd.clear();
      setState(() {
        produtos.forEach((element) {
          context.read<DadosAcesso>().listProd.add(Produto(
            codbarras: element['codbarras'],
            codbarras2: element['codbarras2'],
            desproduto: element["desproduto"],
            codfabricante: element["codfabricante"],
            desmarca: element["desmarca"],
            quantidade: element["quantidade"],
            localizacao1: element["localizacao1"],
            localizacao2: element["localizacao2"],
            localizacao3: element["localizacao3"],
          ));
        });
      });
    }

    estousincronizando = false;

    setState(() {
      bloqueia = false;
    });


    context.read<DadosAcesso>().sincronizando = false;
    textoBuscaController.clear();
    listaProduto = context.read<DadosAcesso>().listProd;

    return listaProduto;
  }

  Future<void> onGravarCritica(String data, String hora, String referencia) async {
    try {
      await db.incluirCritica(
          "insert into critica_busca(cnpjInicial, usuario, codAcesso, referencia, data, hora ) "
              "values('${context.read<DadosAcesso>().cnpjInicial}', '${context.read<DadosAcesso>().usuario}', '${context.read<DadosAcesso>().codAcesso}', "
              "'$referencia', '$data', '$hora');");
    } catch (e) {
      print('Erro ao gravar ==>> onGravarDados');
    }
  }

  executabusca(bool busca, {String txt}) {
    if (busca) {
      setState(() {
        _future = dadosBusca(txt);
      });
      _focusNodeQtde.requestFocus();
    } else {
      setState(() {
        _future = dados();
      });
      _focusNodeBusca.requestFocus();
    }
  }

  onUpdate() {
    String txt;
    if (context.read<DadosAcesso>().configAcesPlanilha1 == '0') {
      txt = 'Balanço de Estoque';
    } else if (context.read<DadosAcesso>().configAcesPlanilha1 == '1') {
      txt = 'Conferência';
    } else if (context.read<DadosAcesso>().configAcesPlanilha1 == '2') {
      txt = 'Guarda Mercadoria';
    }
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Alterar Modulo de Acesso?'),
            content: Text(
                'Deseja realmente mudar o modulo de acesso para $txt ?! \ Caso SIM, clique em "Confirma".'),
            actions: [
              FlatButton(
                onPressed: () async {
                  String status;
                  try {
                    await db.updateDsBalanco(
                        'UPDATE dados SET configAcesPlanilha1 = ${context.read<DadosAcesso>().configAcesPlanilha1}');
                    resgataDados();
                  } catch (e) {
                    print(e);
                  }

                  setState(() {
                    if (context.read<DadosAcesso>().configAcesPlanilha1 == '0') {
                      DynamicColorTheme.of(context).setColor(
                        color: cor1,
                        shouldSave: true,
                      );
                    } else if (context.read<DadosAcesso>().configAcesPlanilha1 == '1') {
                      DynamicColorTheme.of(context).setColor(
                        color: cor2,
                        shouldSave: true,
                      );
                    } else if (context.read<DadosAcesso>().configAcesPlanilha1 == '2') {
                      DynamicColorTheme.of(context).setColor(
                        color: cor3,
                        shouldSave: true,
                      );
                    }
                  });

                  Timer(Duration(milliseconds: 100), () {
                    Navigator.of(context).pop();
                  });
                },
                child: Text('Confirma?'),
                textColor: Theme.of(context).primaryColor,
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancelar'),
                textColor: Colors.blueAccent,
              ),
            ],
          );
        });
  }

  resgataDados() async {
    List linhas = await db.getDsDados();
    for (var linha in linhas) {
      retConfig = linha['configAcesPlanilha1'].toString();
      sCnpj = linha['cnpjInicial'].toString();
      sUser = linha['usuario'].toString();
      sChave = linha['codAcesso'].toString();
    }
  }

  circularProgressGP() {
    return Container(
      color: Colors.white,
      child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Text("Aguarde sincronizando os produtos ao aplicativo.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black)),
              SizedBox(
                height: 8,
              ),
              context.read<DadosAcesso>().sincronizando
                  ? Text('')
                  : Text(descricaoSincronismo == '' ? '0 produtos sincronizados' : descricaoSincronismo,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500)),
              SizedBox(
                height: 8,
              ),
              sinalWifi <= -80
                  ? Text("Sinal da Rede WIFI muito baixo \nA sincronização pode ficar lenta ou parar. \nVerifique sua conexão.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.red))
                  :Text(''),


              SizedBox(
                height: 40,
              ),
              SizedBox(
                height: 150,
                width: 150,
                child: context.read<DadosAcesso>().sincronizando
                    ? CircularProgressIndicator()
                    : LiquidCircularProgressIndicator(
                        value: totalPrpodutos / totalPaginas,
                        valueColor: AlwaysStoppedAnimation(Colors.green),
                        backgroundColor: Colors.white,
                        borderColor: Colors.teal[900],
                        borderWidth: 3.0,
                        direction: Axis.vertical,
                      ),
              ),
              SizedBox(
                height: 40,
              ),
              RotateAnimatedTextKit(
                duration: const Duration(seconds: 2),
                onTap: () {},
                text: ["Buscando Dados...", "Conectando...", "Aguarde..."],
                textStyle: TextStyle(fontSize: 30, color: Colors.black),
                textAlign: TextAlign.start,
              ),
            ],
          )
      ),
    );
  }

  circularProgressConexao() {
    return Container(
      color: Colors.white,
      child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 80,
              ),
              Text("PROBLEMAS COM CONEXÃO",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black)
              ),
              SizedBox(
                height: 40,
              ),
              Text("Verifique sua internet e clique em reconectar..",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black)
              ),
              SizedBox(
                height: 90,
                width: 90,
                child:  CircularProgressIndicator()
              ),
              SizedBox(
                height: 40,
              ),

            ],
          )
      ),
    );
  }

}

class DTS extends DataTableSource {
  DTS(this.listProd, this.context);

  BuildContext context;
  DatabaseHelper db = DatabaseHelper();
  Material material = Material();
  List<Produto> valorP;
  List valor;
  final List<Produto> listProd;
  String qtde;

  Future<List<Produto>> dados() async {
    DatabaseHelper db = DatabaseHelper();
    List produtos;
    List<Produto> listaProduto;

    produtos = await db.getAllProdutos();
    context.read<DadosAcesso>().listProd.clear();

    produtos.forEach((element) {
      context.read<DadosAcesso>().listProd.add(Produto(
            codbarras: element['codbarras'],
            codbarras2: element['codbarras2'],
            desproduto: element["desproduto"],
            codfabricante: element["codfabricante"],
            desmarca: element["desmarca"],
            quantidade: element["quantidade"],
            localizacao1: element["localizacao1"],
            localizacao2: element["localizacao2"],
            localizacao3: element["localizacao3"],
        ));
    });
    listaProduto = context.read<DadosAcesso>().listProd;
    return listaProduto;
  }

  @override
  DataRow getRow(int index) {
    String txt;

    assert(index >= 0);
    if (index >= listProd.length) {
      return null;
    }

    final row = listProd[index];
    //dados();

    return DataRow.byIndex(
      index: index,
      color: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (states.contains(MaterialState.selected))
          return material.color.withOpacity(0.08);
        if (index % 2 == 0) return Colors.grey.withOpacity(0.3);
        return null;
      }),
      onSelectChanged: (bool value) {
        notifyListeners();
        if (txt == null) {
          context.read<DadosAcesso>().qtde = row.quantidade;
        } else {
          context.read<DadosAcesso>().qtde = txt;
        }
        this.qtde = context.read<DadosAcesso>().qtde;
        Navigator.push(context, MaterialPageRoute(builder: (context) => CadastroProduto(produto: row)));
      },
      cells: [
        DataCell(
          Container(
            constraints: BoxConstraints(maxWidth: 120),
            child: Text(row.codbarras),
          ),
        ),
        DataCell(
          Container(
            constraints: BoxConstraints(maxWidth: 170),
            child: Text(
              row.desproduto,
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
        DataCell(
          Container(
            constraints: BoxConstraints(maxWidth: 170),
            child: Center(
              child: Text(
                row.quantidade == null ? '0' : row.quantidade,
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
          // TextFormField(
          //   inputFormatters: [
          //     new LengthLimitingTextInputFormatter(6),
          //   ],
          //   style: TextStyle(color: context.read<DadosAcesso>().color),
          //   initialValue: row.quantidade,
          //   keyboardType: TextInputType.number,
          //   onChanged: (text) {
          //     txt = text;
          //     updateProdutoQtde(text, index, row.codbarras);
          //   },
          //   onEditingComplete: () {
          //     updateProdutoQtde(txt, index, row.codbarras);
          //     context.read<DadosAcesso>().search = false;
          //     context.read<DadosAcesso>().focusBusca.requestFocus();
          //   },
          // )


        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => true;

  @override
  int get rowCount => 12;

  @override
  int get selectedRowCount => 0;
}
