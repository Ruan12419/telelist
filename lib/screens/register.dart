import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/screens/home.dart';
import '/models/user.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  String? _password; // Variável local para armazenar temporariamente a senha

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nome',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu nome';
                  }
                  return null;
                },
                onSaved: (value) => user.setFirstName(value!),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Sobrenome',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu sobrenome';
                  }
                  return null;
                },
                onSaved: (value) => user.setLastName(value!),
              ),
              TextFormField(
                initialValue: user.username,
                decoration: const InputDecoration(
                  labelText: 'Nome de usuário',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu nome de usuário';
                  }
                  return null;
                },
                onSaved: (value) => user.setUsername(value!),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Senha',
                ),
                obscureText: true,
                onChanged: (value) => _password =
                    value, // Salve a senha na variável local quando o valor mudar
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira sua senha';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Confirme a senha',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, confirme sua senha';
                  }
                  if (value != _password) {
                    return 'As senhas não correspondem';
                  }
                  return null;
                },
                onSaved: (value) {
                  user.setPassword(
                      _password!); // Defina a senha do usuário depois de validar
                  user.registerUser(user.username, user.password,
                      user.firstName, user.lastName); // Registre o usuário
                },
              ),
              ElevatedButton(
                child: const Text('Registrar'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Home()),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
