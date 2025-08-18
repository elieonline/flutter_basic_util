import 'package:dlibphonenumber/dlibphonenumber.dart';

import '../extensions/data_types_extensions.dart';
import '../extensions/validation_extension.dart';

/// A collection of common validators that can be reused
class Validators {
  static final emailPattern = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@"
    r"[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}"
    r"[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}"
    r"[a-zA-Z0-9])?)+$",
  );

  static final phonePattern = RegExp("^(\\+234[7-9]|234[7-9]|08|09|07|[7-9])\\d{9}\$");
  static final amountPattern = RegExp(r'^\d+(?:\.\d{1,8})?$');
  static final emailPhonePattern = RegExp(
    r"^(?:[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)+|(?:\+234[7-9]|234[7-9]|08|09|07|[7-9])\d{9})$",
  );

  static Validator custom(bool valid, String message) {
    return (String? value) {
      return (!valid) ? message : null;
    };
  }

  static Validator notEmpty([bool strict = false]) {
    return (String? value) {
      if ((value?.isEmpty ?? true)) {
        return "Field cannot be empty.";
      } else if (strict && !(value?.containNameChars() ?? true)) {
        return "Invalid character(s) found.";
      }
      return null;
    };
  }

  static Validator username() {
    return (String? value) {
      if ((value?.isEmpty ?? true)) {
        return "Field cannot be empty.";
      } else if (value!.contains(" ")) {
        return "Username cannot contain spaces";
      } else if (value.containsUsernameSpecial()) {
        return "Username can only contain letters, numbers and underscores";
      }
      return null;
    };
  }

  static Validator confirmPass(String val1, [String? text]) {
    return (String? value) {
      if (val1 != value) {
        return text ?? "Passwords do not match.";
      } else {
        return null;
      }
    };
  }

  static Validator phone([String countryCode = 'NG', String? text]) {
    return (String? value) {
      if (value == null) {
        return null;
      }

      PhoneNumberUtil phoneUtil = PhoneNumberUtil.instance;
      try {
        final phone = phoneUtil.parse(value, countryCode);
        bool isValid = phoneUtil.isValidNumber(phone);
        return !isValid ? (text ?? "Please enter a valid phone number") : null;
      } on NumberParseException catch (_) {
        return (text ?? "Please enter a valid phone number");
      } catch (_) {
        return (text ?? "Please enter a valid phone number");
      }
    };
  }

  static Validator emailPhone([String? text]) {
    return (String? value) {
      if (value == null) {
        return null;
      }
      return !emailPhonePattern.hasMatch(value.trim())
          ? (text ?? "Invalid email/phone number")
          : null;
    };
  }

  static Validator date() {
    return (String? input) {
      // Remove any non-numeric characters from the input
      String? numericInput = input!.replaceAll(RegExp(r'\D'), '');

      // Validate the length of the numeric input
      if (numericInput.length != 8) {
        return 'Invalid date';
      }

      // Extract the day, month, and year components
      int? day = int.tryParse(numericInput.substring(0, 2));
      int? month = int.tryParse(numericInput.substring(2, 4));
      int? year = int.tryParse(numericInput.substring(4, 8));
      // Validate the day, month, and year components
      if (day == null || month == null || year == null) {
        return 'Invalid date';
      }

      if (day > 29 && month == 2) {
        return 'Invalid February date';
      }

      // Validate the date components
      if (day < 1 || day > 31 || month < 1 || month > 12 || year < 1900) {
        return 'Invalid date';
      }

      // Ensure that the year is not less than 5 years ago
      DateTime now = DateTime.now();
      DateTime inputDate = DateTime(year, month, day);
      if (inputDate.isAfter(now.subtract(const Duration(days: 365 * 5)))) {
        return 'You must be at least 5 years old to register.';
      }

      // Additional validation logic can be added if needed

      return null;
    };
  }

  static Validator name() {
    return (String? value) {
      if (value!.isEmpty) {
        return "Field cannot be empty.";
      }
      if (!value.contains(" ")) {
        return "Seperate names with spaces";
      }
      return null;
    };
  }

  static Validator fname() {
    return (String? value) {
      if (value!.isEmpty) {
        return "Field cannot be empty.";
      }
      if (value.trim().contains(" ")) {
        return "Name cannot contain spaces";
      }
      return null;
    };
  }

  static Validator accountNumber() {
    return (String? value) {
      return (value!.length != 10) ? "Invalid account number." : null;
    };
  }

  static Validator minLength(int minLength, [String? text]) {
    return (String? value) {
      if ((value?.length ?? 0) < minLength) {
        return text ?? "Must contain a minimum of $minLength characters.";
      }
      return null;
    };
  }

  static Validator maxLength(int maxLength, [String? text]) {
    return (String? value) {
      if ((value?.length ?? 0) > maxLength) {
        return text ?? "Maximum of $minLength characters allowed.";
      }
      return null;
    };
  }

  static bool isValid(String pin, String pin2) =>
      (pin.isNotEmpty && pin2.isNotEmpty && pin == pin2);
  static Validator matchPattern(Pattern pattern, [String? patternName, String? text]) {
    return (String? value) {
      if (value == null ||
          (pattern
              .allMatches(patternName == 'amount' ? value.replaceAll(',', '') : value)
              .isEmpty)) {
        return (text ?? "Please enter a valid ${patternName ?? "value"}.");
      }
      return null;
    };
  }

  static Validator email([String? text]) {
    return matchPattern(emailPattern, "email", text);
  }

  static Validator amount([String? text]) {
    return matchPattern(amountPattern, "amount", text);
  }

  static Validator greaterThan(double val, [String? text]) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return "Field cannot be empty.";
      }
      return (double.parse(value.replaceAll(',', '')) < val)
          ? (text ?? "The value should be at least ${val.formatAmount}")
          : null;
    };
  }

  static Validator lessThan(double val, [String? text]) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return "Field cannot be empty.";
      }
      return (double.parse(value.replaceAll(',', '')) > val)
          ? (text ?? "The value should not be greater than ${val.formatAmount}")
          : null;
    };
  }

  static Validator password([int minimumLength = 8, String? text]) => multiple([
    containsUpper(text),
    containsLower(text),
    containsNumber(text),
    containsSpecialChar(text),
    containsSpace(text),
    minLength(minimumLength, text),
  ], shouldTrim: false);

  static Validator containsSpace([String? text]) {
    return (String? value) {
      if (value != null && !value.contains(' ')) return null;
      return text ?? "Password must not contain spaces";
    };
  }

  static Validator containsUpper([String? text]) {
    return (String? value) {
      if (value != null && value.containsUpper()) return null;
      if (value?.isEmpty == true) {
        return "Password must not be empty";
      }
      return text ?? "Password must contain at least one uppercase character.";
    };
  }

  static Validator containsLower([String? text]) {
    return (String? value) {
      if (value != null && value.containsLower()) return null;
      return text ?? "Password must contain at least one lowercase character.";
    };
  }

  static Validator containsNumber([String? text]) {
    return (String? value) {
      if (value != null && value.containsNumber()) return null;
      return text ?? "Password must contain at least one number.";
    };
  }

  static Validator containsSpecialChar([String? text]) {
    return (String? value) {
      if (value != null && value.containsSpecialChar()) return null;
      return text ?? "Password must contain at least one special character.";
    };
  }

  /// Creates a validator that if the combination of multiple validators.
  ///
  /// The provided validators are applied in the order in which
  /// they're specified in the list.
  static Validator multiple(List<Validator> validators, {bool shouldTrim = true}) {
    return (String? value) {
      value = shouldTrim ? value?.trim() : value;
      for (Validator validator in validators) {
        if (validator(value) != null) {
          return validator(value);
        }
      }
      return null;
    };
  }
}

typedef Validator = String? Function(String? value);
