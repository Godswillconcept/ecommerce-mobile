// Helper functions for safe numeric operations
import 'package:flutter/material.dart';

/// Safely converts a value to double
/// Returns 0.0 if conversion fails
double toDouble(dynamic value) {
  if (value == null) return 0.0;

  if (value is double) return value;
  if (value is int) return value.toDouble();

  if (value is String) {
    try {
      return double.parse(value);
    } catch (e) {
      debugPrint('Error parsing "$value" to double: $e');
      return 0.0;
    }
  }

  return 0.0;
}

/// Safely check if a value (which might be a string) is negative
bool isValueNegative(dynamic value) {
  final doubleValue = toDouble(value);
  return doubleValue.isNegative;
}

/// Format currency value that might be a string
String formatCurrency(dynamic value, {String symbol = '\$'}) {
  final doubleValue = toDouble(value);
  return '$symbol${doubleValue.toStringAsFixed(2)}';
}
