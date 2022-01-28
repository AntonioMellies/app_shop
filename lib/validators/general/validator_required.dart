import 'package:shop/validators/validator.dart';

class ValidatorRequired implements Validator {
  ValidatorRequired();

  @override
  String? valid(String value) {
    return value.trim().isEmpty ? 'Preenchimento obrigatorio' : null;
  }
}
