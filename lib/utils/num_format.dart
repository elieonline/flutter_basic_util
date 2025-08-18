import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NumFormatter extends TextInputFormatter {
  final int numDigits;

  NumFormatter({this.numDigits = 2}) : assert(numDigits >= 0);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText;

    if (numDigits == 0) {
      newText = newValue.text.replaceAll(RegExp('[^0-9]'), '');
    } else {
      newText = newValue.text.replaceAll(RegExp('[^0-9.]'), '');
    }

    if (newText.contains('.')) {
      if (newText.trim() == '.') {
        return newValue.copyWith(
          text: '0.',
          selection: const TextSelection.collapsed(offset: 2),
        );
      } else if ((newText.split(".").length > 2) || (newText.split(".")[1].length > numDigits)) {
        return oldValue;
      } else {
        return newValue;
      }
    }

    if (newText.trim() == '') {
      return newValue.copyWith(text: '');
    } else if (int.parse(newText) < 0) {
      return newValue.copyWith(text: '');
    }

    double newDouble = double.parse(newText);
    var selectionIndexFromTheRight = newValue.text.length - newValue.selection.end;

    String newString = NumberFormat("#,##0.##").format(newDouble);

    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(
        offset: newString.length - selectionIndexFromTheRight,
      ),
    );
  }
}

class NoSpaceInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Ensure that the new value does not contain any spaces
    if (newValue.text.contains(' ')) {
      // Replace the new value with the old value without the spaces
      return oldValue.copyWith(text: newValue.text.replaceAll(' ', ''));
    }

    // If no spaces found, simply return the new value as is
    return newValue;
  }
}
