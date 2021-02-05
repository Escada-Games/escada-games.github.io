import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ScreenHome extends StatelessWidget {
  final widget;
  ScreenHome({this.widget});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text.rich(TextSpan(
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 24,
            ),
            children: [
              WidgetSpan(
                  child: Center(
                child: Text('Bem-vindo ao website da Escada Games!\n\n',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              )),
              TextSpan(
                  text:
                      "Nós somos um pequeno grupo de desenvolvedores brasileiros de jogos, no momento mais hobbystas do que qualquer outra coisa. Até agora, nossas maiores conquistas foram:\n\n"),
              WidgetSpan(
                  child: InkWell(
                child: Text(
                  '- Vencemos a Godot Wild Jam #2 com o jogo Diver Down, dentre outros 28 jogos;\n',
                  style: TextStyle(color: Colors.blue, fontSize: 24),
                ),
                onTap: () {
                  launch('https://escada-games.itch.io/diver-down');
                },
              )),
              WidgetSpan(
                  child: InkWell(
                child: Text(
                  '- Vencemos a Godot Wild Jam #10 com o jogo Null Dagger, dentre outros 28 jogos;\n',
                  style: TextStyle(color: Colors.blue, fontSize: 24),
                ),
                onTap: () {
                  launch('https://escada-games.itch.io/null-dagger');
                },
              )),
              WidgetSpan(
                  child: InkWell(
                child: Text(
                  '- Alcançamos o 30º lugar na Ludum Dare #46 na categoria humor com o jogo Pigeon Ascent, dentre outros 3576 jogos;\n',
                  style: TextStyle(color: Colors.blue, fontSize: 24),
                ),
                onTap: () {
                  launch('https://escada-games.itch.io/pigeon-ascent');
                },
              )),
              WidgetSpan(
                  child: InkWell(
                child: Text(
                  '- Fomos selecionados para entrar na revista eletrônica online Indieposcalypse, participando com os jogos Diver Down, Pigeon Ascent, e Pickaxe Tower;\n\n',
                  style: TextStyle(color: Colors.blue, fontSize: 24),
                ),
                onTap: () {
                  launch('https://pizzapranks.itch.io/indiepocalypse-11');
                },
              )),
              TextSpan(
                  text:
                      'Nos botões acima, você  pode conferir nossos jogos em diferentes sites. Esperamos que goste deles!\n'),
              TextSpan(
                  text:
                      'Por fim, você pode entrar em contato com a gente mandando um e-mail para escadagames@gmail.com')
            ])));
  }
}

class ScreenHomeEnglish extends StatelessWidget {
  final widget;
  ScreenHomeEnglish({this.widget});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text.rich(TextSpan(
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 24,
            ),
            children: [
              WidgetSpan(
                  child: Center(
                child: Text('Welcome to Escada Games\'s website!\n\n',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              )),
              TextSpan(
                  text:
                      "We are a small group of brazilian game developers, at the moment more hobbyist than anything else. Until now, or biggest achievements have been:\n\n"),
              WidgetSpan(
                  child: InkWell(
                child: Text(
                  '- We won the Godot Wild Jam #2 with the game Diver Down, over other 28 games;\n',
                  style: TextStyle(color: Colors.blue, fontSize: 24),
                ),
                onTap: () {
                  launch('https://escada-games.itch.io/diver-down');
                },
              )),
              WidgetSpan(
                  child: InkWell(
                child: Text(
                  '- We won the Godot Wild Jam #10 with the game Null Dagger, over other 28 games;\n',
                  style: TextStyle(color: Colors.blue, fontSize: 24),
                ),
                onTap: () {
                  launch('https://escada-games.itch.io/null-dagger');
                },
              )),
              WidgetSpan(
                  child: InkWell(
                child: Text(
                  '- We got the 30º place at the Ludum Dare #46 on the humor category, over 3576 other games;\n',
                  style: TextStyle(color: Colors.blue, fontSize: 24),
                ),
                onTap: () {
                  launch('https://escada-games.itch.io/pigeon-ascent');
                },
              )),
              WidgetSpan(
                  child: InkWell(
                child: Text(
                  '- We were accepted to join the online magazine Indiepocalypse, participating with the games Diver Down, Pigeon Ascent, and Pickaxe Tower;\n\n',
                  style: TextStyle(color: Colors.blue, fontSize: 24),
                ),
                onTap: () {
                  launch('https://pizzapranks.itch.io/indiepocalypse-11');
                },
              )),
              TextSpan(
                  text:
                      'On the buttons above, you can check out our games in different websites. We hope you enjoy them!\n'),
              TextSpan(
                  text:
                      'Also, you can get in touch with us by sending an e-mail to escadagames@gmail.com')
            ])));
  }
}
