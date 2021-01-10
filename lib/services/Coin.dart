import 'dart:convert';

import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'TRY'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

//curl https://rest.coinapi.io/v1/exchangerate/BTC/USD?apikey=D8879841-F1D8-4FD5-BC67-003D1AA721BB
const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = 'D8879841-F1D8-4FD5-BC67-003D1AA721BB';
const bitcoinAverageURL = 'https://rest.coinapi.io/v1/exchangerate';

class Coin {
  Future getCoinData(String selectedCurrency) async {
    Map<String, String> cryptoPrices = {};

    for (String crypto in cryptoList) {
      String requestURL =
          '$coinAPIURL/$crypto/$selectedCurrency?apikey=$apiKey';
      http.Response response = await http.get(requestURL);

      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        double lastPrice = decodedData['rate'];
        cryptoPrices[crypto] = lastPrice.toStringAsFixed(0);
      } else {
        print(response.statusCode);
        throw 'Problem with the get request';
      }
    }

    return cryptoPrices;
  }
}
