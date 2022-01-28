import 'package:shop/validators/validator.dart';

class ValidatorMinLength implements Validator {
  final int _minLimit;

  ValidatorMinLength(this._minLimit);

  @override
  String? valid(String value) {
    return value.trim().length < _minLimit ? 'Tamanho minimo é ${_minLimit} caracteres' : null;
  }
}
