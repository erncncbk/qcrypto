import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CurrencyApiClient {
  final _authority = 'pro-api.coinmarketcap.com';
  final _unencodedPath = '/v1/cryptocurrency/listings/latest';
  final _parameter = {
    'start': '1',
    'limit': '150',
    'convert': 'USD',
    'sort': 'date_added',
  };
  final _headers = {
    "Content-Type": "application/json",
    "X-CMC_PRO_API_KEY": "${dotenv.env['COINMARKETCAP_API_KEY']}"
  };
  Future<List<dynamic>> getCurrencies() async {
    Uri url = Uri.https(_authority, _unencodedPath, _parameter);
    http.Response response;

    response = await http.get(url, headers: _headers);
    if (response.statusCode != 200) {
      throw new Exception('error getting data');
    }
    var data = new Map<String, dynamic>.from(json.decode(response.body));

    return data['data'];
  }
}
