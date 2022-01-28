import 'package:shop/validators/validator.dart';

class ValidatorMaxLength implements Validator {
  final int _maxLimit;

  ValidatorMaxLength(this._maxLimit);

  @override
  String? valid(String value) {
    return value.length > _maxLimit ? 'Tamanho maximo é ${_maxLimit} caracteres' : null;
  }
}
