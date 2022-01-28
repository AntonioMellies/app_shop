import 'package:shop/validators/validator.dart';

class ValidatorExtension implements Validator {
  final List<String> extensions;

  ValidatorExtension({required this.extensions});

  @override
  String? valid(String value) {
    bool notEndsWith = extensions.firstWhere((element) => value.toLowerCase().endsWith(element), orElse: () => '').isEmpty;
    return notEndsWith ? 'Formato invalido' : null;
  }
}


