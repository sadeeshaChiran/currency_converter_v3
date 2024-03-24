class Converter {
  static double convertCurrency({
    required Map<String, dynamic> exchangeRates,
    required double amount,
    required String fromCurrency,
    required String toCurrency,
  }) {
    double fromToBaseRate = exchangeRates['rates'][fromCurrency].toDouble();
    double toBaseRate = exchangeRates['rates'][toCurrency];
    double convertedAmount = (amount / fromToBaseRate) * toBaseRate;
    return convertedAmount;
  }
}
