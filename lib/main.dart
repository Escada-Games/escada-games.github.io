// HIDE ITCH.IO API KEY

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as dartConvert;

import 'package:responsive_grid/responsive_grid.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Escada Games',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Montserrat',
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
  bool _bHovering = false;
  String strCurrentGameHovered = '';
  final nonHoverTransform = Matrix4.identity()..translate(0, 0, 0);
  final hoverTransform = Matrix4.identity()..translate(0, -10, 0);

  void _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'It was not possible to open $url.';
    }
  }

  void _mouseEnter(bool mouseIn) {
    setState(() {
      _bHovering = mouseIn;
    });
  }

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
        elevation: 0.0,
        backgroundColor: Colors.black,
        title: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.stairs_outlined,
                size: 32,
              ),
              onPressed: () {
                ;
              },
            ),
            SizedBox(
              width: 8,
            ),
            Text(widget.title),
            SizedBox(
              width: 16,
            ),
            IconButton(
              icon: Icon(Icons.home),
              padding: EdgeInsets.all(16),
              tooltip: 'Homepage',
              onPressed: () {
                ;
              },
            ),
            IconButton(
              icon: Icon(Icons.games),
              padding: EdgeInsets.all(16),
              tooltip: 'Our games',
              onPressed: () {
                ;
              },
            )
          ],
        ),
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
                  desiredItemWidth: 256,
                  minSpacing: 32,
                  children: [
                    for (Future<JsonItchioGame> futureGame
                        in widget.lFutureGames)
                      FutureBuilder<JsonItchioGame>(
                        future: futureGame,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              transform: _bHovering &&
                                      snapshot.data.strTitle ==
                                          strCurrentGameHovered
                                  ? hoverTransform
                                  : nonHoverTransform,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SelectableText(
                                      snapshot.data.strTitle,
                                      textAlign: TextAlign.center,
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16.0),
                                      child: MouseRegion(
                                        onEnter: (e) {
                                          _mouseEnter(true);
                                          strCurrentGameHovered =
                                              snapshot.data.strTitle;
                                        },
                                        onExit: (e) {
                                          _mouseEnter(false);
                                        },
                                        cursor: SystemMouseCursors.click,
                                        child: GestureDetector(
                                          onTap: () {
                                            _launchURL(
                                                snapshot.data.strGameUrl);
                                          },
                                          child: Image.network(
                                            snapshot.data.strCoverImageUrl,
                                            width: 315,
                                            alignment: Alignment.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                            );
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
  final String strGameUrl;
  final String strTitle; // Game name
  final bool bSale;
  final String strCoverImageUrl;
  final bool bOriginalPrice;
  final String strPrice;

  JsonItchioGame(
      {this.strGameUrl,
      this.strTitle,
      this.bSale,
      this.strCoverImageUrl,
      this.bOriginalPrice,
      this.strPrice});

  factory JsonItchioGame.fromJson(String gameUrl, Map<String, dynamic> json) {
    return JsonItchioGame(
        strGameUrl: gameUrl,
        strTitle: json['title'],
        bSale: json['sale'],
        strCoverImageUrl: json['cover_image'],
        bOriginalPrice: json['original_price'],
        strPrice: json['price']);
  }
}

Future<JsonItchioGame> fetchItchioGameData(String strGameName) async {
  String gameUrl = 'https://escada-games.itch.io/' + strGameName;
  String apiUrl = gameUrl + '/data.json';
  final response = await http.get(apiUrl);

  if (response.statusCode == 200) {
    var responseBody = dartConvert.jsonDecode(response.body);
    return JsonItchioGame.fromJson(gameUrl, responseBody);
  } else {
    throw Exception('Erro: falha em obter dados da API do itch.io.');
  }
}
