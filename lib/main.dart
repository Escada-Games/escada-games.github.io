// HIDE ITCH.IO API KEY
// Use this: https://flutter.dev/docs/cookbook/images/fading-in-images
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

  void _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'It was not possible to open $url.';
    }
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
    MediaQueryData queryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.black,
        title: Row(
          children: queryData.size.width > 600
              ? [
                  IconButton(
                    icon: Icon(
                      Icons.stairs_outlined,
                      size: 32,
                    ),
                    padding: EdgeInsets.all(16),
                    alignment: Alignment.topCenter,
                    tooltip: 'Homepage',
                    onPressed: () {
                      ;
                    },
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.games,
                      size: 32,
                    ),
                    padding: EdgeInsets.all(16),
                    tooltip: 'Our games',
                    onPressed: () {
                      ;
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.videogame_asset,
                      size: 32,
                      color: Color.fromRGBO(241, 89, 82, 1.0),
                    ),
                    padding: EdgeInsets.all(16),
                    tooltip: 'Our itch.io page',
                    onPressed: () {
                      _launchURL('https://escada-games.itch.io');
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.videogame_asset,
                      size: 32,
                      color: Color.fromRGBO(41, 121, 255, 1.0),
                    ),
                    padding: EdgeInsets.all(16),
                    tooltip: 'Our gotm.io page',
                    onPressed: () {
                      _launchURL('https://gotm.io/escada-games');
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.help,
                      size: 32,
                    ),
                    padding: EdgeInsets.all(16),
                    tooltip: 'About us',
                    onPressed: () {
                      ;
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.email,
                      size: 32,
                    ),
                    padding: EdgeInsets.all(16),
                    tooltip: 'Contact',
                    onPressed: () {
                      ;
                    },
                  ),
                  SizedBox(
                    width: 16,
                  )
                ]
              : [],
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SelectableText(
              'Nossos jogos:',
              style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 16,
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                // margin: EdgeInsets.all(8),
                child: Scrollbar(
                  child: ResponsiveGridList(
                    desiredItemWidth:
                        150, //queryData.size.width > 256 ? 256 : 128,
                    minSpacing: 32,
                    // squareCells: true,
                    children: [
                      for (Future<JsonItchioGame> futureGame
                          in widget.lFutureGames)
                        FutureBuilder<JsonItchioGame>(
                          future: futureGame,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return GameCard.fromSnapshotData(snapshot);
                            } else if (snapshot.hasError) {
                              return SelectableText(
                                  "${snapshot.error}\nErro no snapshot.");
                            } else {
                              return CircularProgressIndicator();
                              // return Flexible(
                              //     fit: FlexFit.loose,
                              //     child: CircularProgressIndicator());
                            }
                          },
                        )
                    ],
                  ),
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

class GameCard extends StatefulWidget {
  final String strTitle;
  final String strGameUrl;
  final String strCoverImageUrl;

  final Matrix4 nonHoverTransform = Matrix4.identity()..translate(0, 0, 0);
  final Matrix4 hoverTransform = Matrix4.identity()..translate(0, -10, 0);

  GameCard({this.strTitle, this.strGameUrl, this.strCoverImageUrl});
  factory GameCard.fromSnapshotData(AsyncSnapshot<JsonItchioGame> snapshot) {
    return GameCard(
        strTitle: snapshot.data.strTitle,
        strGameUrl: snapshot.data.strGameUrl,
        strCoverImageUrl: snapshot.data.strCoverImageUrl);
  }

  @override
  _GameCardState createState() => _GameCardState();
}

class _GameCardState extends State<GameCard> {
  bool _bHovering = false;

  void _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'It was not possible to open $url.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform:
              _bHovering ? widget.hoverTransform : widget.nonHoverTransform,
          child: MouseRegion(
            onEnter: (e) {
              setState(() {
                _bHovering = true;
              });
            },
            onExit: (e) {
              setState(() {
                _bHovering = false;
              });
            },
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                _launchURL(widget.strGameUrl);
              },
              child: Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                margin: EdgeInsets.all(8),
                elevation: 8,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(widget.strTitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          )),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: MouseRegion(
                          onEnter: (e) {
                            setState(() {
                              _bHovering = true;
                            });
                          },
                          onExit: (e) {
                            setState(() {
                              _bHovering = false;
                            });
                          },
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              _launchURL(widget.strGameUrl);
                            },
                            child: Image.network(
                              widget.strCoverImageUrl,
                              // width: 315,
                              // fit: ,
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
          )),
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
