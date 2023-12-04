import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/screens/home.dart';
import '/models/user.dart';
import '/repositories/user_repository.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final UserRepository userRepository = UserRepository();

  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 0, 84, 159),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.only(top: 100)),
            Image.asset("imagens/logo.jpeg"),
            const Padding(padding: EdgeInsets.all(20)),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
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
                    onSaved: (value) => username = value!,
                  ),
                  const Padding(padding: EdgeInsets.all(5)),
                  TextFormField(
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
                    onSaved: (value) => password = value!,
                  ),
                  const Padding(padding: EdgeInsets.all(20)),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.black),
                    child: const Text('Entrar'),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        User user = User(username, password);
                        user.userId = await userRepository.fetchUsers(user);
                        if (user.userId.isNotEmpty) {
                          Provider.of<User>(context, listen: false)
                              .setUser(user);
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
