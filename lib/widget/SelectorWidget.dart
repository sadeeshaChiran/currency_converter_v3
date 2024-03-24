import 'package:flutter/material.dart';

class SelectorWidget extends StatelessWidget {
  final String selectedCountry;
  final List<String> countries;
  final ValueChanged<String?> onChanged;

  const SelectorWidget({
    Key? key,
    required this.selectedCountry,
    required this.countries,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Remove duplicate values from the countries list
    List<String> uniqueCountries = countries.toSet().toList();

    return DropdownButton<String>(
      value: selectedCountry,
      items: uniqueCountries.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}