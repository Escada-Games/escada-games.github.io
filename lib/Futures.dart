import 'package:http/http.dart' as http;
import 'dart:convert' as dartConvert;

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

class JsonIpApi {
  final String strIp;
  JsonIpApi({this.strIp});

  factory JsonIpApi.parseJson(Map<String, dynamic> json) {
    return JsonIpApi(strIp: json['query']);
  }

  String get ip {
    return strIp;
  }
}

Future<JsonIpApi> fetchJsonIpApiData() async {
  final response = await http.get('http://ip-api.com/json/');

  if (response.statusCode == 200) {
    var responseBody = dartConvert.jsonDecode(response.body);
    return JsonIpApi.parseJson(responseBody);
  } else {
    throw Exception('Failed to get data from Ip-Api.');
  }
}

class JsonSalutApi {
  final String strLocal;
  JsonSalutApi({this.strLocal});

  factory JsonSalutApi.parseJson(Map<String, dynamic> json) {
    return JsonSalutApi(
      strLocal: json['code'],
    );
  }
}

Future<JsonSalutApi> fetchJsonSalutApiData(userIp) async {
  final response =
      await http.get('https://fourtonfish.com/hellosalut/?ip=' + userIp);
  if (response.statusCode == 200) {
    var responseBody = dartConvert.jsonDecode(response.body);
    return JsonSalutApi.parseJson(responseBody);
  } else {
    throw Exception('Failed to get data from Salut api.');
  }
}

class StrIpify {
  final String strIp;
  StrIpify({this.strIp});
  factory StrIpify.parseResponse(String response) {
    return StrIpify(strIp: response);
  }
}

Future<StrIpify> fetchIpifyData() async {
  final response = await http.get('https://api.ipify.org');
  if (response.statusCode == 200) {
    return StrIpify.parseResponse(response.body);
  } else {
    throw Exception('Failed to get data from Ipify.');
  }
}
