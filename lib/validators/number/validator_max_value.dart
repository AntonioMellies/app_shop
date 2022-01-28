import 'package:shop/validators/validator.dart';

class ValidatorMaxValue implements Validator {
  final double _maxLimit;

  ValidatorMaxValue(this._maxLimit);

  @override
  String? valid(String value) {
    double _value = double.tryParse(value) ?? (_maxLimit + 1);
    return _value < _maxLimit ? 'Valor maximo é ${_maxLimit}' : null;
  }
}
