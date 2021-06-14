import 'package:balanco_app/componentes/api/produtos/busca_critica.dart';
import 'package:balanco_app/componentes/api/produtos/produto.dart';
import 'package:balanco_app/models/dados_acesso.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class DatabaseHelper extends ChangeNotifier {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static DatabaseHelper _databaseHelper;
  static Database _database;

//Dados iniciais:
  String cnpjInicial = 'cnpjInicial';
  String usuario = 'usuario';
  String codAcesso = 'codAcesso';
  String configAcesPlanilha1 = 'configAcesPlanilha1';
  String configAcesPlanilha2 = 'configAcesPlanilha2';

  //Dadso dos Produtos:
  String codbarras = 'codbarras';
  String codbarras2 = 'codbarras2';
  String codfabricante = 'codfabricante';
  String codmarca = 'codmarca';
  String codproduto = 'codproduto';
  String desmarca = 'desmarca';
  String desproduto = 'desproduto';
  String localizacao = 'localizacao';
  String localizacao1 = 'localizacao1';
  String localizacao2 = 'localizacao2';
  String localizacao3 = 'localizacao3';
  String posicao = 'posicao';
  String quantidade = 'quantidade';
  String sincronizado = 'sincronizado';

  //Dados Detalhe:
  String paginas = 'paginas';
  
  //Dados Critica/Busca
  String referencia = "referencia";
  String data = "data";
  String hora = "hora";
  
  
  
  DadosAcesso dadosAcesso;
  DatabaseHelper._createInstance();



  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }


  Future<Database> initializeDatabase() async {

    final directory = await getExternalStorageDirectory();

    String path = directory.path + '/dados_balanco.db';

    var contatosDatabase = await openDatabase(path, version: 1, onCreate: _createDb);

    return contatosDatabase;
  }



  Future<void> _createDb(Database db, int newVersion) async {
    //CRIAÇÃO DAS TABELAS:
    await db.execute(
        "CREATE TABLE dados($cnpjInicial TEXT, $usuario TEXT, $codAcesso TEXT, $configAcesPlanilha1 TEXT, $configAcesPlanilha2 TEXT)");
    await db.execute(
        "CREATE TABLE detalhe(id INTEGER PRIMARY KEY, $paginas TEXT)");
    await db.execute(
        "CREATE TABLE produto(id INTEGER PRIMARY KEY, $codbarras TEXT, $codfabricante TEXT, $codmarca TEXT, $codproduto TEXT, "
            "$desmarca TEXT, $desproduto TEXT, $localizacao TEXT, $localizacao1 TEXT,$localizacao2 TEXT, $localizacao3 TEXT, "
            "$posicao TEXT, $quantidade TEXT, $codbarras2 TEXT, $sincronizado)");
    await db.execute(
        "CREATE TABLE critica_busca(id INTEGER PRIMARY KEY, $cnpjInicial TEXT, $usuario TEXT, $codAcesso TEXT, $referencia TEXT, $data TEXT, $hora TEXT)");

    //CRIAÇÃO DOS INDICES:
    await db.execute("CREATE INDEX index_Tab_produto on produto ($codbarras, $codfabricante, $codmarca, $codproduto, $posicao, $quantidade, $codbarras2);");

  }


  //Parte dos Dados Iniciais
  Future<int> insereDsBalanco(String sql) async {
    Database db = await this.database;
    var resultado = await db.rawInsert(sql);
    return resultado;
  }

  Future<int> updateDsBalanco(String sql) async {
    Database db = await this.database;
    var resultado = await db.rawUpdate(sql);
    return resultado;
  }

  Future<int> deletarDsBalanco(String sql) async {
    Database db = await this.database;
    var resultado = await db.rawDelete(sql);
    return resultado;
  }

  Future<List<Map<String, dynamic>>> getAllDetalhes() async {
    Database db = await this.database;
    return await db.query("detalhe");
  }

  Future<List<Map<String, dynamic>>> getDsDados() async {
    Database db = await this.database;
    // return await db.rawQuery('SELECT * FROM dados');
    return await db.query("dados");
  }

  Future<int> getDsDados2() async {
    Database db = await this.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM dados'));
  }
  // Fim Dados Iniciais


  //PARTE DOS PRODUTOS
  Future<void> incluirProduto(Produto produto) async {
    Database db = await this.database;
      var resultado = await db.transaction((txn) async {
        var batch = txn.batch();
        batch.insert('produto', produto.toJson());
        await batch.commit(noResult: true);
      });
      return resultado;
  }

  Future<List<dynamic>> insertProdutos(List<Produto> produto) async {
    List<dynamic> listRes = new List();
    Database db = await this.database;

    var res;
    try {
      await db.transaction((db) async {
        produto.forEach((obj) async {
          try {
            var iRes = await db.insert('produto', obj.toJson());
            listRes.add(iRes);
          } catch (ex) {
            debugPrint('Erro');
          }
        });
      });
      res = listRes;
    } catch (er) {
      debugPrint('Erro');
    }
    return res;
  }
  // Future <void> insertProdutos(List<Produto> produto) async {
  //   final db = await database;
  //   var buffer = new StringBuffer();
  //   produto.forEach((p) {
  //     if (buffer.isNotEmpty) {
  //       buffer.write(",\n");
  //     }
  //     buffer.write("('");
  //     buffer.write(p.codbarras);
  //     buffer.write("','");
  //     buffer.write(p.codfabricante);
  //     buffer.write("','");
  //     buffer.write(p.codmarca);
  //     buffer.write("','");
  //     buffer.write(p.codproduto);
  //     buffer.write("','");
  //     buffer.write(p.desmarca);
  //     buffer.write("','");
  //     buffer.write(p.desproduto);
  //     buffer.write("','");
  //     buffer.write(p.localizacao);
  //     buffer.write("','");
  //     buffer.write(p.localizacao1);
  //     buffer.write("','");
  //     buffer.write(p.localizacao2);
  //     buffer.write("','");
  //     buffer.write(p.localizacao3);
  //     buffer.write("','");
  //     buffer.write(p.posicao);
  //     buffer.write("','");
  //     buffer.write(p.quantidade);
  //     buffer.write("','");
  //     buffer.write(p.codbarras2);
  //     buffer.write("')");
  //   });
  //   print('Dentro do Insert: ${buffer.toString()}');
  //
  //   var raw = await db.rawInsert("INSERT Into produto (codbarras,codfabricante,codmarca,codproduto,desmarca,"
  //       "desproduto,localizacao,localizacao1,localizacao2,localizacao3,posicao,quantidade,codbarras2)"
  //       " VALUES ${buffer.toString()}");
  //
  //   print('Registrou Produto ${buffer.toString()}');
  //   return raw;
  // }
  Future<int> updateProduto(String sql) async {
    Database db = await this.database;
    var resultado = await db.rawUpdate(sql);
    return resultado;
  }

  Future<int> deleteAllProdutos() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM produto');
    return res;
  }

  Future<List<Map<String, dynamic>>> getAllProdutos() async {
    Database db = await this.database;
    // return await db.rawQuery('SELECT * FROM produto');
    return await db.rawQuery('SELECT * FROM produto LIMIT 800');
  }

  Future<List<Map<String, dynamic>>> getAllProdutosSincronismo() async {
    Database db = await this.database;
    // return await db.rawQuery('SELECT * FROM produto');
    return await db.rawQuery('SELECT codproduto FROM produto');
  }

  Future<List<Map<String, dynamic>>> getAllProdutosQtdeMaiorZero() async {
    Database db = await this.database;
    return await db.rawQuery('SELECT codproduto, quantidade, localizacao1, localizacao2, localizacao3 FROM produto where quantidade > 0 and (sincronizado = null OR sincronizado = "")');
  }

  Future<List<Map<String, dynamic>>> getProdutosQTDEa(String codbarras) async {
    Database db = await this.database;
    return await db.rawQuery('SELECT quantidade FROM produto where codbarras = "$codbarras"');
  }

  Future<int> getQtdeProdutos(String codbarras) async {
    Database db = await this.database;
    var res = Sqflite.firstIntValue(await db.rawQuery('SELECT quantidade FROM produto where codbarras = "$codbarras"'));
    return res;
  }

  Future<List<Map<String, dynamic>>> getProdutosBusca(String txt, String tipo) async {
    Database db = await this.database;
    switch (tipo) {
      case "codbarras":
        return await db.rawQuery('select * from produto where codbarras = "$txt"');
        break;
      case "codbarras2":
        return await db.rawQuery('select * from produto where codbarras2 = "$txt"');
        break;
      case "codfabricante":
        return await db.rawQuery('select * from produto where codfabricante = "$txt"');
        break;
      case "descricao":
        return await db.rawQuery('select * from produto where desproduto LIKE "%$txt%"');
        break;
      case "internoss":
        return await db.rawQuery('select * from produto where idss = "$txt"');
        break;

    }
  }

  Future<int> queryRowCount() async {
    Database db = await this.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM produto'));
  }

  // FIM PARTE Busca/Critica

  //PARTE DA BUSCA/CRITICA
  Future<int> incluirCritica(String sql) async {
    Database db = await this.database;
    var resultado = await db.rawInsert(sql);
    return resultado;
  }

  Future<int> updateCritica(String sql) async {
    Database db = await this.database;
    var resultado = await db.rawUpdate(sql);
    return resultado;
  }

  Future<int> deleteAllCritica() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM critica_busca');
    return res;
  }

  Future<List<Map<String, dynamic>>> getAllCriticaBusca() async {
    Database db = await this.database;
    return await db.rawQuery('SELECT * FROM critica_busca');
  }


  Future<int> deleteAllPagina() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM detalhe');
    return res;
  }

  Future<int> incluirPagina(String sql) async {
    Database db = await this.database;
    var resultado = await db.rawInsert(sql);
    return resultado;
  }

  Future<int> totalPaginas() async {
    Database db = await this.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT paginas from detalhe'));
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    this.database;
  }

}
