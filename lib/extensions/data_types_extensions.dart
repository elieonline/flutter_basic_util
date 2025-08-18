import 'package:intl/intl.dart';

extension FormatAmount on num? {
  String formatAmountD({
    int? decimalDigits,
    String? currency,
    bool withSpace = false,
  }) {
    return this == null
        ? "0.00"
        : NumberFormat.currency(
            symbol:
                "${currency == 'NGN' ? '₦' : currency == 'USD' ? '\$' : (currency ?? '')}${withSpace ? ' ' : ''}",
            decimalDigits: Utils.getDecimal(this!, decimalDigits),
          ).format(this);
  }

  String get formatAmount => (this == null)
      ? "0.00"
      : NumberFormat.currency(
          name: '',
          decimalDigits: 2,
        ).format(this);

  String get formatAmountWithName => (this == null)
      ? "0.00"
      : NumberFormat.currency(
          name: '₦',
          decimalDigits: 2,
        ).format(this);

  String get formatAmount2 => (this == null)
      ? "0.00"
      : NumberFormat.currency(
          name: '',
          decimalDigits: Utils.isInteger(this!) ? 0 : 2,
        ).format(this);

  String get formatAmountWithName2 => (this == null)
      ? "0.00"
      : NumberFormat.currency(
          name: '₦',
          decimalDigits: Utils.isInteger(this!) ? 0 : 2,
        ).format(this);

  String get getmaskText {
    List data = [];
    for (var element in toString().split('')) {
      element = '*';
      data.add(element);
    }
    return data.join();
  }
}

extension FormatStar on num {
  String get toStarString {
    switch (this) {
      case 1:
        return 'ONE';
      case 2:
        return 'TWO';
      case 3:
        return 'THREE';
      case 4:
        return 'FOUR';
      case 5:
        return 'FIVE';
      default:
        return 'ZERO';
    }
  }
}

class Utils {
  static bool isInteger(num value) => value is int || value == value.roundToDouble();
  static int getDecimal(num value, [int? decimalDigits]) {
    if (decimalDigits != null) return decimalDigits;

    String fraction =
        value.toString().split('.').length > 1 ? value.toString().split('.').last : '';
    if (fraction.isEmpty || fraction.length == 1) return 2;
    // Count leading zeros
    int leadingZeros = 0;
    for (var c in fraction.split('')) {
      if (c == '0') {
        leadingZeros++;
      } else {
        break;
      }
    }
    // If first non-zero is at position 0, just 2 decimals
    if (leadingZeros == 0) return 2;
    // Else, show all leading zeros + 2 more digits
    int total = leadingZeros + 2;
    return fraction.length < total ? fraction.length : total;
  }
}
