import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'GameCard.dart';
import 'Futures.dart';

class ScreenAllGames extends StatelessWidget {
  final widget;
  ScreenAllGames({this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class ScreenAllGamesEnglish extends StatelessWidget {
  final widget;
  ScreenAllGamesEnglish({this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SelectableText(
            'Our games:',
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
    );
  }
}
