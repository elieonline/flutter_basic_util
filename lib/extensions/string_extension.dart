import 'package:dlibphonenumber/dlibphonenumber.dart';

import 'date_extensions.dart';

extension StringExtension on String? {
  String? get capitalize {
    if (this != null) {
      return "${this![0].toUpperCase()}${this!.substring(1).toLowerCase()}";
    } else {
      return null;
    }
  }

  String get capitalizeFirst {
    if (this == null) return '';
    return this![0].toUpperCase() + this!.substring(1);
  }

  String get obscuredMail {
    if (this == null) return '';
    final email = this!;
    final atIdx = email.indexOf('@');
    if (atIdx <= 3) return email; // Not enough chars to obscure

    final start = atIdx - 3 >= 1 ? atIdx - 3 : 1;
    final end = atIdx - 1;
    final buffer = StringBuffer();

    for (int i = 0; i < email.length; i++) {
      if (i >= start && i <= end) {
        buffer.write('*');
      } else {
        buffer.write(email[i]);
      }
    }
    return buffer.toString();
  }

  String get toSentenceCase {
    if (this == null || this?.isEmpty == true) return '';

    return this!.trimLeft()[0].toUpperCase() + this!.trimLeft().substring(1).toLowerCase();
  }

  String get toTitleCase {
    if (this == null) return '';
    return this!.replaceAllMapped(RegExp(r"\w+"), (Match match) {
      String word = match[0]!;
      return "${word[0].toUpperCase()}${word.substring(1).toLowerCase()}";
    });
  }

  String get toTitleCase2 {
    if (this == null) return '';
    String spacedText = this!.replaceAll('_', ' ');

    // Convert camelCase to space-separated words
    spacedText = spacedText.replaceAllMapped(
      RegExp(r'(?<!^)(?=[A-Z])'),
      (Match match) => ' ${match.group(0)}',
    );

    // Convert the first letter of each word to uppercase
    String titleCaseText = spacedText.split(' ').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');

    return titleCaseText;
  }

  String? formatPhoneNumber([String countryCode = 'NG']) {
    PhoneNumberUtil phoneUtil = PhoneNumberUtil.instance;
    try {
      final phone = phoneUtil.parse(this, countryCode);
      return "${phone.countryCode}${phone.nationalNumber}";
    } on NumberParseException catch (_) {
    } catch (_) {}
    return null;
  }

  String get toSnakeCase {
    if (this == null) return "";
    String snakeCase = this!.replaceAll(RegExp(r'[^a-zA-Z0-9]+'), '_');
    snakeCase = snakeCase.toLowerCase();
    snakeCase = snakeCase.replaceAll(RegExp(r'^_+|_+$'), '');
    return snakeCase;
  }

  String get toInitial {
    if ((this ?? '').isNotEmpty) {
      final splt = (this ?? '').split(" ");
      splt.removeWhere((element) => element.isEmpty);
      if (splt.length > 1) {
        return "${splt.first[0]}${splt.last[0]}".toUpperCase();
      }
      if (splt.first.length > 1) {
        return "${splt.first[0]}${splt.first[1]}".toUpperCase();
      } else {
        return splt.first[0].toUpperCase();
      }
    } else {
      return "";
    }
  }

  String get formatAsCardNumber {
    // Remove all non-digit characters
    final digitsOnly = this?.replaceAll(RegExp(r'\D'), '') ?? '';

    // Group into chunks of 4
    final buffer = StringBuffer();
    for (var i = 0; i < digitsOnly.length; i++) {
      if (i != 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digitsOnly[i]);
    }

    return buffer.toString();
  }

  DateTime get toDate {
    if (this != null) {
      return DateTime.parse(this!);
    }
    return DateTime.now();
  }

  DateTime get toDateTime {
    if (this != null) {
      return DateTime.fromMillisecondsSinceEpoch(int.parse(this!) * 1000);
    }
    return DateTime.now();
  }

  String get toMonthDate {
    if (this != null) {
      return DateTime.parse(this!).toMonthDate;
    }
    return "";
  }

  String get toTime {
    if (this != null && this!.isNotEmpty) {
      return DateTime.parse(this!).toTime;
    }
    return "";
  }

  String get formatStringDate {
    if (this != null) {
      return DateTime.parse(this!).toDateTime;
    }
    return "";
  }

  String get formatStringToDate {
    if (this != null) {
      try {
        return DateTime.parse(this!).toDate;
      } catch (_) {
        return "";
      }
    }
    return "";
  }

  String get toDateMonthYear {
    if (this != null) {
      return DateTime.parse(this!).toDateMonthYearTime;
    }
    return "";
  }

  String? get toDateTimeYear {
    if (this != null) {
      return DateTime.parse(this!).toDateTimeYear;
    }
    return null;
  }

  String? get toDayDateTimeYear {
    if (this != null) {
      return DateTime.parse(this!).toDateTimeYear;
    }
    return null;
  }

  String masktext({
    int start = 0,
    int end = 7,
  }) {
    if (this == null) return '****';
    end = this!.length - 4;
    assert(this!.length > 10, throw "Value cannot be less than 11");
    List newChar = [];
    for (var val = 0; val < this!.length; val++) {
      var i = this!.split('')[val];
      if (val >= start && val <= end) {
        i = "*";
        newChar.add(i);
      } else {
        newChar.add(i);
      }
    }
    return newChar.join();
  }
}
