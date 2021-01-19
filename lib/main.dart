// HIDE ITCH.IO API KEY

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as dartConvert;

import 'package:responsive_grid/responsive_grid.dart';

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
  List<String> lGameList = [
    'almastone',
    'archer-hunter-prototype',
    'ayera-the-void-sand-witch',
    'birb-peak',
    'birds-of-steel',
    'blackened',
    'cosmic-potato-trader-simulator',
    'delay-mage',
    'dentaldefense',
    'diver-down',
    'double-sided',
    'giovannis-climb',
    'gravitron-experiment',
    'horse-knight',
    'jank-warrior',
    'just-another-slime-platformer',
    'mizunis-ghostly-thermal-center',
    'nothing-to-see-here',
    'null-dagger',
    'pickaxe-tower',
    'pigeon-ascent',
    'redazul',
    'serpent',
    'ticaruga',
    'wafflegeddon',
    'work-so-that-i-can-get-those-beautiful-pigeons-you-darn-bees',
    'zeitmeister'
  ];

  List<dynamic> lFutureGames = [];

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<JsonItchioGame> futureItchioGame;

  @override
  void initState() {
    super.initState();
    futureItchioGame = fetchItchioGameData('diver-down');
    for (String game in widget.lGameList) {
      widget.lFutureGames.add(fetchItchioGameData(game));
    }
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
          children: [
            SelectableText(
              'Nossos jogos:',
            ),
            SizedBox(
              height: 8,
            ),
            Expanded(
              child: Scrollbar(
                child: ResponsiveGridList(
                  desiredItemWidth: 128,
                  minSpacing: 16,
                  children: [
                    for (Future<JsonItchioGame> futureGame
                        in widget.lFutureGames)
                      FutureBuilder<JsonItchioGame>(
                        future: futureGame,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Column(children: [
                              SelectableText(
                                snapshot.data.strTitle,
                                textAlign: TextAlign.center,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  snapshot.data.strCoverImageUrl,
                                  width: 315,
                                  alignment: Alignment.center,
                                ),
                              )
                            ]);
                          } else if (snapshot.hasError) {
                            return SelectableText(
                                "${snapshot.error}\nErro no snapshot.");
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}

class JsonItchioGame {
  final String strTitle; // Game name
  final bool bSale;
  final String strCoverImageUrl;
  final bool bOriginalPrice;
  final String strPrice;

  JsonItchioGame(
      {this.strTitle,
      this.bSale,
      this.strCoverImageUrl,
      this.bOriginalPrice,
      this.strPrice});

  factory JsonItchioGame.fromJson(Map<String, dynamic> json) {
    return JsonItchioGame(
        strTitle: json['title'],
        bSale: json['sale'],
        strCoverImageUrl: json['cover_image'],
        bOriginalPrice: json['original_price'],
        strPrice: json['price']);
  }
}

Future<JsonItchioGame> fetchItchioGameData(String strGameName) async {
  String apiUrl = 'https://escada-games.itch.io/' + strGameName + '/data.json';
  final response = await http.get(apiUrl);

  if (response.statusCode == 200) {
    var responseBody = dartConvert.jsonDecode(response.body);
    return JsonItchioGame.fromJson(responseBody);
  } else {
    throw Exception('Erro: falha em obter dados da API do itch.io.');
  }
}
