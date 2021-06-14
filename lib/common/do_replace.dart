
class DoReplace{

  Future<void> substituir(String dados, String nomColuna) async {
    final x = dados.replaceAll('{', '').replaceAll('}', '').replaceAll('[', '').replaceAll(']', '').replaceAll(nomColuna, '');
    return x;
  }

}