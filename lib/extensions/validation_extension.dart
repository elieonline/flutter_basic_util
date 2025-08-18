extension CharacterValidation on String {
  bool containsUpper() {
    for (var i = 0; i < length; i++) {
      var code = codeUnitAt(i);
      if (code >= 65 && code <= 90) return true;
    }
    return false;
  }

  bool containsLower() {
    for (var i = 0; i < length; i++) {
      var code = codeUnitAt(i);
      if (code >= 97 && code <= 122) return true;
    }
    return false;
  }

  bool containsSpecialChar() {
    for (var i = 0; i < length; i++) {
      var char = this[i];
      if ("#?!@\$%^&*-_.,/[]{}|;:+=".contains(char)) return true;
    }
    return false;
  }

  bool containsUsernameSpecial() {
    for (var i = 0; i < length; i++) {
      var char = this[i];
      if ("#?!@\$%^&*,/[]{}|;:+=-.".contains(char)) return true;
    }
    return false;
  }

  bool containNameChars() {
    for (var i = 0; i < length; i++) {
      var char = this[i];
      if (!RegExp(r"[a-zA-Z0-9\s\'-]").hasMatch(char)) return false;
    }
    return true;
  }

  bool containsNumber() {
    for (var i = 0; i < length; i++) {
      var code = codeUnitAt(i);
      if (code >= 48 && code <= 57) return true;
    }
    return false;
  }
}
