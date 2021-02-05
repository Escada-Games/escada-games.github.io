// HIDE ITCH.IO API KEY
// Use this: https://flutter.dev/docs/cookbook/images/fading-in-images
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ScreenHome.dart';
import 'ScreenAllGames.dart';
import 'Futures.dart';

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
    'wallker-demolition-co',
    'work-so-that-i-can-get-those-beautiful-pigeons-you-darn-bees',
    'zeitmeister'
  ];

  List<String> lMostPopular = [
    'diver-down',
    'pigeon-ascent',
    'pickaxe-tower',
    'ticaruga',
    'delay-mage',
    'blackened'
  ];

  List<dynamic> lFutureGames = [];
  List<dynamic> lFutureMostPopular = [];

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<StrIpify> futureUserIp;
  Future<JsonSalutApi> futureUserLocal;
  Future<JsonItchioGame> futureItchioGame;
  String userLocal = 'en';
  String currentPage = 'home';

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
    for (String game in widget.lGameList) {
      widget.lFutureGames.add(fetchItchioGameData(game));
    }
    for (String game in widget.lMostPopular) {
      widget..lFutureMostPopular.add(fetchItchioGameData(game));
    }

    futureUserIp = fetchIpifyData();
    futureUserIp.then((ipApifyData) {
      setState(() {
        //String strUserIp = ipApifyData.strIp;
        futureUserLocal = fetchJsonSalutApiData(ipApifyData.strIp);
        futureUserLocal.then((value) {
          setState(() {
            userLocal = value.strLocal;
          });
        });
      });
    });
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
                        setState(() {
                          currentPage = 'home';
                        });
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
                      tooltip: userLocal == 'br' ? 'Nossos jogos' : 'Our games',
                      onPressed: () {
                        setState(() {
                          currentPage = 'ourGames';
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.videogame_asset,
                        size: 32,
                        color: Color.fromRGBO(241, 89, 82, 1.0),
                      ),
                      padding: EdgeInsets.all(16),
                      tooltip: userLocal == 'br'
                          ? 'Nossa página do itch.io'
                          : 'Our itch.io page',
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
                      tooltip: userLocal == 'br'
                          ? 'Nossa página do gotm.io'
                          : 'Our gotm.io page',
                      onPressed: () {
                        _launchURL('https://gotm.io/escada-games');
                      },
                    ),
                    // IconButton(
                    //   icon: Icon(
                    //     Icons.help,
                    //     size: 32,
                    //   ),
                    //   padding: EdgeInsets.all(16),
                    //   tooltip: userLocal == 'br' ? 'Sobre nós' : 'About us',
                    //   onPressed: () {
                    //     ;
                    //   },
                    // ),
                    // IconButton(
                    //   icon: Icon(
                    //     Icons.email,
                    //     size: 32,
                    //   ),
                    //   padding: EdgeInsets.all(16),
                    //   tooltip: userLocal == 'br' ? 'Contato' : 'Contact',
                    //   onPressed: () {
                    //     ;
                    //   },
                    ),
                    SizedBox(
                      width: 16,
                    )
                  ]
                : [],
          ),
        ),
        body: Stack(children: [
          Container(
            color: Colors.black,
          ),
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 16),
                Center(
                  child: SelectableText('Escada Games',
                      style: TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          backgroundColor: Colors.black)),
                ),
                Center(
                  child: SelectableText(
                      userLocal == 'br'
                          ? 'Um pequeno grupo brasileiro de desenvolvimento de jogos'
                          : 'A small brazilian indie game development group',
                      style: TextStyle(
                          fontSize: 16,
                          // fontWeight: FontWeight.bold,
                          color: Colors.white,
                          backgroundColor: Colors.black)),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(32, 0, 32, 0),
                    padding: EdgeInsets.fromLTRB(128, 0, 128, 0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32),
                            topRight: Radius.circular(32)),
                        color: Colors.white),
                    child: currentPage == 'home'
                        ? (userLocal == 'br')
                            ? ScreenHome(widget: widget)
                            : ScreenHomeEnglish(
                                widget: widget,
                              )
                        : (userLocal == 'br')
                            ? ScreenAllGames(widget: widget)
                            : ScreenAllGamesEnglish(
                                widget: widget,
                              ),
                  ),
                )
              ]),
        ]));
  }
}
