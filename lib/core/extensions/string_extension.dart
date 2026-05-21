import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension StringExt on String {
  Color toColor() {
    if (isEmpty) {
      return Colors.transparent;
    }

    var hexColor = replaceAll('#', '');

    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor'.toUpperCase();
    }

    return Color(int.parse(hexColor, radix: 16));
  }

  bool equalsIgnoreCase(String value) {
    return toLowerCase() == value.toLowerCase();
  }

  bool containsIgnoreCase(String value) {
    return toLowerCase().contains(value.toLowerCase());
  }

  DateTime? toFormattedDateTime(String pattern, {bool isUtc = false}) {
    return DateFormat(pattern, 'en').parse(this, isUtc);
  }
}

extension NullStringExt on String? {
  bool isNullOrEmpty() => this == null || this!.isEmpty || this == 'null';

  bool equalsIgnoreCase(String? value) {
    if (this == null) {
      return false;
    }
    return this?.toLowerCase() == value?.toLowerCase();
  }

  bool containsIgnoreCase(String? value) {
    if (isNullOrEmpty() || value.isNullOrEmpty()) {
      return false;
    }

    return this!.toLowerCase().contains(value!.toLowerCase());
  }

  DateTime? toFormattedDateTime(String pattern, {bool isUtc = false}) {
    if (this == null) {
      return null;
    }
    return DateFormat(pattern, 'en').parse(this!, isUtc);
  }

  Color? toColor() {
    if (isNullOrEmpty()) {
      return null;
    }

    var hexColor = this!.replaceAll('#', '');

    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse(hexColor, radix: 16));
  }
}