import 'package:shop/validators/validator.dart';

class ValidatorEmail implements Validator {
  ValidatorEmail();

  @override
  String? valid(String value) {
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
    return !emailValid ? 'Email invalido' : null;
  }
}
