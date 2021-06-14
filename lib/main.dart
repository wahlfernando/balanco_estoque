import 'package:balanco_app/common/qrcode.dart';
import 'package:balanco_app/helpers/database_helper.dart';
import 'package:balanco_app/models/dados_acesso.dart';
import 'package:balanco_app/screens/base/base.dart';
import 'package:balanco_app/screens/cards/acesso_planilha.dart';
import 'package:balanco_app/screens/cards/card_contLivre_acessoChave.dart';
import 'package:balanco_app/screens/configuracoes/tela_configuracoes.dart';
import 'package:balanco_app/screens/home/tela_inicial.dart';
import 'package:balanco_app/screens/produtos/cadastro/cadastro_produto.dart';
import 'package:balanco_app/screens/produtos/tela_products.dart';
import 'package:balanco_app/screens/splash/splash.dart';
import 'package:balanco_app/services/configuracoes.dart';
import 'package:balanco_app/services/constantes.dart';
import 'package:balanco_app/services/definicoes_cores.dart';
import 'package:balanco_app/services/verifica_conexao.dart';
import 'package:dynamic_color_theme/dynamic_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_foreground_plugin/flutter_foreground_plugin.dart';
import 'package:provider/provider.dart';

void main() async {
  //Isos faz com que o celular fique em pé.
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MyApp());

  //Configuração do Loading;
  configLoading();

  //Start serviço;
  startForegroundService();
}

  // FlutterForegroundPlugin.stopForegroundService();

void startForegroundService() async {
  await FlutterForegroundPlugin.setServiceMethodInterval(seconds: 5);
  await FlutterForegroundPlugin.setServiceMethod(globalForegroundService);
  await FlutterForegroundPlugin.startForegroundService(
    holdWakeLock: false,
    onStarted: () {
      print("Foreground on Started");
    },
    onStopped: () {
      print("Foreground on Stopped");
    },
    title: "App em Segundo Plano",
    content: "App em Segundo Plano",
    iconName: "ic_stat_hot_tub",
  );
}

void globalForegroundService() {
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2500)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
const cor1 = Colors.green;

  Color primaryColor;

class _MyAppState extends State<MyApp> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  ThemeColors themeColors = ThemeColors();
  DadosAcesso dadosAcesso = DadosAcesso();
  VarFixas varFixas = VarFixas();
  int qtde;
  int qtdeProd;
  String retConfig;


  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }
    (context as Element).visitChildren(rebuild);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    setState(() {
      resgataDados();
      rebuildAllChildren(context);
    });

    return DynamicColorTheme(
      data: (Color color, bool isDark) {
        return buildTheme(color, isDark);
      },
      defaultColor: cor1,
      defaultIsDark: false,
      themedWidgetBuilder: (BuildContext context, ThemeData theme) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => DatabaseHelper(),
              lazy: false,
            ),
            ChangeNotifierProvider(
              create: (_) => DadosAcesso(),
              lazy: false,
            ),
            ChangeNotifierProvider(
              create: (_) => QRCode(),
              lazy: false,
            ),
            ChangeNotifierProvider(
              create: (_) => ThemeColors(),
              lazy: false,
            ),
            ChangeNotifierProvider(
              create: (_) => VerificaConexao(),
              lazy: false,
            ),
          ],
          child: MaterialApp(
            builder: EasyLoading.init(),
            debugShowCheckedModeBanner: false,
            title: 'Balanço Mobile',
            theme: theme,
            //initialRoute: '/',
            onGenerateRoute: (setings) {
              switch (setings.name) {
                case '/acessoplanilha':
                  return MaterialPageRoute(builder: (_) => AcessoPlanilha(),);
                case '/cadastro_produto':
                  return MaterialPageRoute(builder: (_) => CadastroProduto(),);
                case '/contlivre_acessochave':
                  return MaterialPageRoute(builder: (_) => ContLivreAcessoChave());
                case '/produtos':
                  return MaterialPageRoute(builder: (_) => TelaProdutos());
                case '/tela_inicial':
                  return MaterialPageRoute(builder: (_) => TelaInicialCnpj());
                case '/splash':
                  return MaterialPageRoute(builder: (_) => Splash());
                case '/configuracoes':
                  return MaterialPageRoute(builder: (_) => TelaConfiguracoes());
                case '/basetelas':
                  return MaterialPageRoute(builder: (_) => BaseTelas());

                case '/':
                default:
                  return MaterialPageRoute(builder: (_) => Splash());
              //return MaterialPageRoute(builder: (_) => qtde != 0 ? TelaProdutos() : TelaInicialCnpj());
              }
            },
          ),
        );
      },
    );

  }


  resgataDados() async {
    List linhas = await databaseHelper.getDsDados();
    for(var linha in linhas){
      retConfig = linha['configAcesPlanilha1'].toString();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }



}
