import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/auth_exception.dart';
import 'package:shop/models/enums/auth_mode.dart';
import 'package:shop/providers/auth_provider.dart';
import 'package:shop/validators/general/validator_email.dart';
import 'package:shop/validators/general/validator_password_strong%20copy.dart';
import 'package:shop/validators/general/validator_password_strong.dart';
import 'package:shop/validators/general/validator_required.dart';
import 'package:shop/validators/validator_builder.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _passwordController = TextEditingController();

  AuthMode _authMode = AuthMode.Login;
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  bool _isLoading = false;
  bool _isLogin() => _authMode == AuthMode.Login;
  bool _isSignup() => _authMode == AuthMode.Signup;

  void _switchAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.Signup;
      } else {
        _authMode = AuthMode.Login;
      }
    });
  }

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Ocorreu um erro"),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Fechar"),
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    setState(() => _isLoading = true);

    _formKey.currentState?.save();
    AuthProvider authProvider = Provider.of(context, listen: false);
    try {
      if (_isLogin()) {
        await authProvider.signInWithPassword(
          _authData['email']!,
          _authData['password']!,
        );
      } else {
        await authProvider.signUp(
          _authData['email']!,
          _authData['password']!,
        );
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog("Ocorreu um erro inesperado");
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: _isLogin() ? 320 : 400,
        width: deviceSize.width * 0.75,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "E-mail"),
                keyboardType: TextInputType.emailAddress,
                onSaved: (newValue) => _authData['email'] = newValue ?? '',
                validator: (value) => ValidatorBuilder(value).addValidators([ValidatorRequired(), ValidatorEmail()]).build(),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Senha"),
                keyboardType: TextInputType.emailAddress,
                obscureText: true,
                controller: _passwordController,
                onSaved: (newValue) => _authData['password'] = newValue ?? '',
                validator: (value) => _isLogin()
                    ? ValidatorBuilder(value).addValidators([ValidatorRequired()]).build()
                    : ValidatorBuilder(value).addValidators([ValidatorRequired(), ValidatorPasswordStrong(4, hasDigits: true, hasUppercase: true, hasSpecialCharacters: true)]).build(),
              ),
              if (_authMode == AuthMode.Signup)
                TextFormField(
                  decoration: const InputDecoration(labelText: "Confirmar Senha"),
                  keyboardType: TextInputType.emailAddress,
                  obscureText: true,
                  validator: (value) => _isSignup() ? ValidatorBuilder(value).addValidators([ValidatorRequired(), ValidatorEquals(value2: _passwordController.text)]).build() : null,
                ),
              const SizedBox(height: 20),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _submit,
                  child: Text(_authMode == AuthMode.Login ? 'Entrar' : 'Registrar'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                  ),
                ),
              const Spacer(),
              TextButton(
                onPressed: _switchAuthMode,
                child: Text(_isLogin() ? 'Deseja Registra ?' : 'Já possui conta ?'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
