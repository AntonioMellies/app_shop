import 'package:shop/validators/validator.dart';

class ValidatorNumberMinLimit implements Validator {
  final double _minLimit;

  ValidatorNumberMinLimit(this._minLimit);

  @override
  String? valid(String value) {
    double _value = double.tryParse(value) ?? (_minLimit -1);

    return _value < _minLimit ? 'Valor minimo é ${_minLimit}' : null;
  }
}
