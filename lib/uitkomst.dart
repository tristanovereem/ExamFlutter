import 'package:flutter/material.dart';

class Uitkomst extends StatelessWidget {
  final double inputValue;
  final String fromUnit;
  final String toUnit;

  const Uitkomst({
    Key? key,
    required this.inputValue,
    required this.fromUnit,
    required this.toUnit,
  }) : super(key: key);

  double _convert(double value, String from, String to) {
    double valueInKg;

    // First convert to kg
    switch (from) {
      case 'g':
        valueInKg = value / 1000;
        break;
      case 'lb':
        valueInKg = value / 2.2046226218;
        break;
      case 'oz':
        valueInKg = value / 35.27396195;
        break;
      default:
        valueInKg = value;
    }

    // Then from kg to target
    switch (to) {
      case 'g':
        return valueInKg * 1000;
      case 'lb':
        return valueInKg * 2.2046226218;
      case 'oz':
        return valueInKg * 35.27396195;
      default:
        return valueInKg;
    }
  }

  double _getRate(String from, String to) {
    return _convert(1, from, to);
  }

  @override
  Widget build(BuildContext context) {
    final result = _convert(inputValue, fromUnit, toUnit);
    final rate = _getRate(fromUnit, toUnit);
    final textStyle = Theme.of(context).textTheme.headline5;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${inputValue.toStringAsFixed(2)} $fromUnit = ${result.toStringAsFixed(2)} $toUnit',
                style: textStyle,
              ),
              const SizedBox(height: 12),
              Text(
                '1 $fromUnit = ${_getRate(fromUnit, toUnit).toStringAsFixed(4)} $toUnit',
                style: textStyle?.copyWith(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
