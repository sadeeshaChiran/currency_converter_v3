List<String> extractCurrencyNames(Map<String, dynamic> data) {
  List<String> currencyNames = [];
  
  // Access the 'currencies' object from the data
  Map<String, dynamic>? currencies = data['currencies'];

  // Check if 'currencies' is not null
  if (currencies != null) {
    // Iterate through each currency and extract its name (code)
    currencies.forEach((key, value) {
      // Add the currency name to the list
      currencyNames.add(key);
    });
  }
  
  return currencyNames;
}
