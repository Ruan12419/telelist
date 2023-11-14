import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/screens/home.dart';
import '/screens/register.dart';
import '/models/user.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.grey,
      ),
      backgroundColor: Colors.grey[350],
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Padding(padding: const EdgeInsets.all(20)),
            Image.asset("imagens/logo.jpeg"),
            Padding(padding: const EdgeInsets.all(20)),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    initialValue: user.username,
                    decoration: const InputDecoration(
                      fillColor: Color.fromARGB(255, 238, 238, 238),
                      filled: true,
                      labelText: 'Email',
                      labelStyle: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.all(Radius.elliptical(12.0, 12.0)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu nome de usuário';
                      }
                      return null;
                    },
                    onSaved: (value) => user.setUsername(value!),
                  ),
                  Padding(padding: const EdgeInsets.all(5)),
                  TextFormField(
                    initialValue: user.password,
                    decoration: const InputDecoration(
                      fillColor: Color.fromARGB(255, 238, 238, 238),
                      filled: true,
                      labelText: 'Senha',
                      labelStyle: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.all(Radius.elliptical(12.0, 12.0)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira sua senha';
                      }
                      return null;
                    },
                    onSaved: (value) => user.setPassword(value!),
                  ),
                  Padding(padding: const EdgeInsets.all(20)),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.black),
                    child: const Text('Entrar'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        if (user.isUserRegistered(
                            user.username, user.password)) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Home()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Usuário não registrado')),
                          );
                        }
                      }
                    },
                  ),
                  Padding(padding: const EdgeInsets.all(5)),
                  TextButton(
                    child: const Text(
                      'Registrar',
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Register()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
