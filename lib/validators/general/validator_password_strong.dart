import 'package:shop/validators/validator.dart';

class ValidatorEquals implements Validator {
  final String value2;
 
  ValidatorEquals({required this.value2});

  @override
  String? valid(String value) {
    bool _isEqual = value == value2;
    return !_isEqual ? "Valores nao correspondem" : null;
  }
}
