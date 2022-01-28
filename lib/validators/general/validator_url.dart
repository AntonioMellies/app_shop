import 'package:shop/validators/validator.dart';

class ValidatorUrl implements Validator {
  ValidatorUrl();

  @override
  String? valid(String value) {
    bool isValidUrl = Uri.tryParse(value)?.hasAbsolutePath ?? false;
    return !isValidUrl ? 'Url invalida' : null;
  }
}
