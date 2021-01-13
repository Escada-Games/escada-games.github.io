// HIDE ITCH.IO API KEY

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as dartConvert;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Escada Games',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Escada Games'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<JsonItchioGame> futureItchioGame;

  @override
  void initState() {
    super.initState();
    futureItchioGame = fetchItchioGameData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Nossos jogos:',
            ),
            FutureBuilder<JsonItchioGame>(
              future: futureItchioGame,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SelectableText(snapshot.data.strName);
                } else if (snapshot.hasError) {
                  return SelectableText("${snapshot.error}\nErro no snapshot.");
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class JsonItchioGame {
  final String strName; // Game name
  final bool bPublished; // If game is published
  final String strUrl; // The game's URL
  final String strCover; // Game cover Url
  final String strDescription; // Game's decription, aka short_text

  JsonItchioGame(
      {this.strName,
      this.bPublished,
      this.strUrl,
      this.strCover,
      this.strDescription});

  factory JsonItchioGame.fromJson(Map<String, dynamic> json) {
    return JsonItchioGame(strName: json['title']);
  }
}

Future<JsonItchioGame> fetchItchioGameData() async {
  String itchioKey = 'wwDZ8H5JgClYc7Fft1iei41VgkCFLmEKBKr6gvOk';
  String apiUrl = 'https://itch.io/api/1/' + itchioKey + '/my-games';
  final response = await http.get(apiUrl);
  print('?ASD?ASD?ASd');

  if (response.statusCode == 200) {
    var responseBody = dartConvert.jsonDecode(response.body);
    print(apiUrl);
    print(responseBody);
    return JsonItchioGame.fromJson(responseBody[0]);
  } else {
    print('Erro: falha em obter dados da API do itch.io.');
    throw Exception('Erro: falha em obter dados da API do itch.io.');
  }
}
