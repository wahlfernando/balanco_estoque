import 'package:balanco_app/common/drawer/custon_drawer.dart';
import 'package:balanco_app/componentes/api/produtos/produto.dart';
import 'package:balanco_app/componentes/utils/show_dialog.dart';
import 'package:balanco_app/helpers/database_helper.dart';
import 'package:balanco_app/models/dados_acesso.dart';
import 'package:balanco_app/screens/produtos/cadastro/itens_prod.dart';
import 'package:balanco_app/screens/produtos/cadastro/text_edit_localiza%C3%A7%C3%A3o.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../tela_products.dart';

class CadastroProduto extends StatefulWidget {

   Produto produto;

  @override
  _CadastroProdutoState createState() => _CadastroProdutoState();

  CadastroProduto({this.produto});
}

class _CadastroProdutoState extends State<CadastroProduto> {

  DatabaseHelper db = DatabaseHelper();
  Color primaryColor;
  String qtde;
  final loc1Controller = TextEditingController();
  final loc2Controller = TextEditingController();
  final loc3Controller = TextEditingController();
  final qtdeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    resgataDados();
  }

  @override
  Widget build(BuildContext context) {
    primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Produto - ${widget.produto.desproduto}',overflow: TextOverflow.fade,
          maxLines: 1,
          softWrap: false, ),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      drawer: CustonDrawer(),
      body: WillPopScope(
        onWillPop: () async => false,
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text('Balanço', style: TextStyle(fontSize: 24),),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Text('Atualize seu produto  ',
                      style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic),
                    ),
                    Icon(
                      Icons.refresh, size: 16,
                    ),
                  ],
                ),
              ),

              //Campos Fixos:
              ItensProduto(titulo: 'Código do Fabricante:', descricao: widget.produto.codfabricante,),
              ItensProduto(titulo: 'Descrição:', descricao: widget.produto.desproduto,),
              ItensProduto(titulo: 'Marca:', descricao: widget.produto.desmarca,),

              //Localizações
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 2),
                child: Text('Localização',
                  style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic),
                ),
              ),
              Container(
                child: Row(
                  children: [
                    TextEditLoc(label: 'Loc. 1', controller: loc1Controller,),
                    TextEditLoc(label: 'Loc. 2', controller: loc2Controller,),
                    TextEditLoc(label: 'Loc. 3', controller: loc3Controller,),
                  ],
                ),
              ),

              //Quantidade:
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Quantidade',
                      style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      inputFormatters: [
                          new LengthLimitingTextInputFormatter(8),
                        ],
                      controller: qtdeController,
                      autocorrect: false,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(2)),
                        labelText: 'Qtde.',
                        labelStyle: TextStyle(fontSize: 20, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),

              //Botões
              Padding(
                padding: EdgeInsets.all(8),
                child: SizedBox(
                  height: 44,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(2.0)),
                    ),
                    onPressed: (){
                      try {
                        db.updateProduto('UPDATE produto SET '
                            'quantidade = "${qtdeController.text}", '
                            'localizacao1 = "${loc1Controller.text}", '
                            'localizacao2 = "${loc2Controller.text}", '
                            'localizacao3 = "${loc3Controller.text}", '
                            'sincronizado = "" '
                            'where codbarras = "${widget.produto.codbarras}" ');

                        final showDialog = ShowDialog(context, 'Salvar...', 'O produto ${widget.produto.desproduto}, foi salvo com sucesso.');
                        showDialog.showMyDialog();

                        Navigator.push(context, MaterialPageRoute(builder: (context) => TelaProdutos()));


                      } catch (e) {
                        final showDialog = ShowDialog(context, 'Salvar(ERRO!!!)', 'Falha ao salvar o produto ${widget.produto.desproduto}. \nVerifique os dados digitados.');
                        showDialog.showMyDialog();
                      }
                    },
                    color: Colors.grey[200],
                    textColor: Theme.of(context).primaryColor,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Salvar  ',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Icon(Icons.save,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: SizedBox(
                  height: 44,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(2.0)),
                    ),
                    onPressed: (){
                      onClearText();
                      context.read<DadosAcesso>().search = false;
                      Navigator.pop(context);
                    },
                    color: Colors.grey[200],
                    textColor: Theme.of(context).primaryColor,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Cancelar  ',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Icon(Icons.cancel,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  resgataDados()async{
    if(context.read<DadosAcesso>().qtde == '0'){
      qtdeController.text = '';
    } else{
      qtdeController.text = context.read<DadosAcesso>().qtde;
    }
    loc1Controller.text = widget.produto.localizacao1;
    loc2Controller.text = widget.produto.localizacao2;
    loc3Controller.text = widget.produto.localizacao3;
  }

  onClearText(){
    qtdeController.clear();
    loc1Controller.clear();
    loc2Controller.clear();
    loc3Controller.clear();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
