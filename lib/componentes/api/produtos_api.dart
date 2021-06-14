import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';


const baseUrl = "https://jsonplaceholder.typicode.com";

class API {
  static Future getPosts() async{
    var url = baseUrl + "/users";
    return await http.get(url);
  }
}

class ProdutosApi extends ChangeNotifier {
  int userId;
  int id;
  String title;
  String body;
  String name;
  String username;
  String email;

  ProdutosApi({int userId, int id, String title, String body, String name, String username, String email}) {
    this.id = id;
    this.userId = userId;
    this.title = title;
    this.body = body;

    this.name = name;
    this.username = username;
    this.email = email;
  }

  ProdutosApi.fromJson(Map json)
      : userId = json['userId'],
        id = json['id'],
        title = json['title'],
        body = json['body'],
        name = json['name'],
        username = json['username'],
        email = json['email'];



  String _search = '';
  String get search => _search;

  set search(String value) {
    _search = value;
    notifyListeners();
  }

}
