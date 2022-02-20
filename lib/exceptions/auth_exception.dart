class AuthException implements Exception {
  static const Map<String, String> errors = {
    'EMAIL_EXISTS': 'Email ja cadastrado',
    'OPERATION_NOT_ALLOWED': 'Operação não permitida',
    'TOO_MANY_ATTEMPTS_TRY_LATER': 'Acesso bloqueado temporariamente, tente mais tarde',
    'EMAIL_NOT_FOUND': 'Email nao encontrado',
    'INVALID_PASSWORD': 'Senha invalida',
    'USER_DISABLED': 'Usuario desabilitado',
  };

  final String key;

  AuthException(this.key);

  @override
  String toString() {
    return errors[key] ?? 'Ocorreu um erro na auntenticação';
  }
}
