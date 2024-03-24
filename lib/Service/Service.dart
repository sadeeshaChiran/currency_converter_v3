import 'dart:convert';
import 'package:http/http.dart' as http;

class Service {
  static Future<Map<String, dynamic>> fetchExchangeRates(
      String baseCurrency) async {
    final Uri uri =
        Uri.parse('https://api.exchangerate-api.com/v4/latest/$baseCurrency');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load exchange rates');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchCountryList() async {
  final Uri uri = Uri.parse('https://restcountries.com/v3.1/all');
  final response = await http.get(uri);
  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    List<Map<String, dynamic>> countryList = List<Map<String, dynamic>>.from(data);
    return countryList;
  } else {
    throw Exception('Failed to load country list');
  }
}
}
