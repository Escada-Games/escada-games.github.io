import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/rendering.dart';
import 'Futures.dart';

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
