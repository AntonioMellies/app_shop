import 'package:shop/validators/validator.dart';

class ValidatorTextMaxLimit implements Validator {
  final int _maxLimit;

  ValidatorTextMaxLimit(this._maxLimit);

  @override
  String? valid(String value) {
    return value.length > _maxLimit ? 'Tamanho maximo é ${_maxLimit} caracteres' : null;
  }
}
