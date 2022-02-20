import 'package:shop/validators/validator.dart';

class ValidatorPasswordStrong implements Validator {
  final int minLength;
  final bool hasUppercase;
  final bool hasDigits;
  final bool hasLowercase;
  final bool hasSpecialCharacters;

  ValidatorPasswordStrong(
    this.minLength, {
    this.hasUppercase = false,
    this.hasDigits = false,
    this.hasLowercase = false,
    this.hasSpecialCharacters = false,
  });

  @override
  String? valid(String value) {
    bool _hasUppercase = hasUppercase ? value.contains(new RegExp(r'[A-Z]')) : true;
    bool _hasDigits = hasDigits ? value.contains(new RegExp(r'[0-9]')) : true;
    bool _hasLowercase = hasLowercase ? value.contains(new RegExp(r'[a-z]')) : true;
    bool _hasSpecialCharacters = hasSpecialCharacters ? value.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]')) : true;
    bool _hasMinLength = value.length >= minLength;

    return !(_hasDigits & _hasUppercase & _hasLowercase & _hasSpecialCharacters & _hasMinLength) ? "Senha não corresponde os criterios de segurança" : null;
  }
}
