import 'package:shop/validators/validator.dart';

class ValidatorBuilder {
  final List<Validator> _validators = [];
  final String? _value;

  ValidatorBuilder(this._value);

  ValidatorBuilder addValidators(List<Validator> validators) {
    _validators.addAll(validators);
    return this;
  }

  ValidatorBuilder addValidator(Validator validator) {
    _validators.add(validator);
    return this;
  }

  String? build() {
    return _validators.map((e) => e.valid(_value ?? '')).firstWhere((x) => x != null, orElse: () => null);
  }
}
