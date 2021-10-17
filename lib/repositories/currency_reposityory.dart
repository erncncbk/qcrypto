import 'package:qcrypto/repositories/currency_api_client.dart';

class CurrencyRepository {
  final CurrencyApiClient currencyApiClient;

  CurrencyRepository({required this.currencyApiClient});

  Future<List<dynamic>> getCurrencies() async {
    return await currencyApiClient.getCurrencies();
  }
}
