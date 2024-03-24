// ignore: file_names
import 'package:currency_converter/Service/Currency.dart';
import 'package:currency_converter/widget/selectorWidget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Service/Converter.dart';
import '../Service/Service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SharedPreferences _prefs;
  Color mainColor = Color(0x949398FF);
  Color secendColor = Color(0xF4DF4EFF);

  List<String> fetchedCurrencies = [];
  double amount = 0.0;
  double convertedAmount = 0.0;
  String convertedAmountString = "0.00";
  bool isLoadingCurrency = false;
  bool isLoadingPage = false;

  bool isFROMtoTO = false;
  bool isTOtoFROM = true;

  String to = "CAD";
  String from = "LKR";

  @override
  void initState() {
    super.initState();
    _loadFromPrefs();
    fetchCurrencies();
  }

  _loadFromPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      from = _prefs.getString('from') ?? 'LKR';
      to = _prefs.getString('to') ?? 'CAD';
    });
  }

  _saveToPrefs() {
    _prefs.setString('from', from);
    _prefs.setString('to', to);
  }

  void convertCurrency() async {
    try {
      Map<String, dynamic> exchangeRates =
          await Service.fetchExchangeRates(from);
      convertedAmount = Converter.convertCurrency(
        exchangeRates: exchangeRates,
        amount: amount,
        fromCurrency: from,
        toCurrency: to,
      );
      setState(() {
        convertedAmountString = convertedAmount.toStringAsFixed(2);
      });
    } catch (e) {
      print('Error: $e');
      // Handle error
    }
  }

  Future<void> fetchCurrencies() async {
    try {
      List<Map<String, dynamic>> countryList = await Service.fetchCountryList();

      // Initialize a list to store currency names
      List<String> currenciesFromCountries = [];

      // Iterate through each country in the country list
      for (var country in countryList) {
        // Extract currency names from each country and add them to the list
        currenciesFromCountries.addAll(extractCurrencyNames(country));
      }

      // Remove duplicates from the list (if any)
      currenciesFromCountries = currenciesFromCountries.toSet().toList();

      setState(() {
        fetchedCurrencies = currenciesFromCountries;
      });
    } catch (e) {
      print('Error fetching currencies: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Currency Convertor",
                    style: TextStyle(
                      color: Color.fromARGB(255, 227, 210, 231),
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              isLoadingPage
                  ? const CircularProgressIndicator()
                  : Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: from,
                                labelStyle: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16.0,
                                ),
                              ),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                amount = double.tryParse(value) ?? 0.0;
                              },
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right:
                                          8.0), // Adjust the amount of space as needed
                                  child: SelectorWidget(
                                    selectedCountry: from,
                                    countries: fetchedCurrencies,
                                    onChanged: (newValue) {
                                      setState(() {
                                        from = newValue!;
                                      });
                                    },
                                  ),
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.fromARGB(54, 156, 7, 255)),
                                  child: IconButton(
                                    icon: const Icon(Icons.swap_horiz),
                                    onPressed: () {
                                      setState(() {
                                        String from_value = to;
                                        String to_value = from;
                                        _saveToPrefs();

                                        from = from_value;
                                        to = to_value;
                                        convertedAmountString = '0.00';
                                      });
                                    },
                                    color: Colors.white,
                                  ),
                                ),
                                // ignore: avoid_unnecessary_containers
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left:
                                          8.0), // Adjust the amount of space as needed

                                  child: SelectorWidget(
                                    selectedCountry: to,
                                    countries: fetchedCurrencies,
                                    onChanged: (newValue) {
                                      setState(() {
                                        to = newValue!;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10.0),
                            ElevatedButton(
                              onPressed: () {
                                convertCurrency();
                              },
                              child: const Text('Convert'),
                            ),
                            const SizedBox(height: 40.0),
                            Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.0)),
                              child: isLoadingCurrency
                                  ? const CircularProgressIndicator()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              to,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Text(
                                              convertedAmountString,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 25.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
