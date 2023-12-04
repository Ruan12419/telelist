import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telelist/main.dart';
import 'package:telelist/screens/movies_screen.dart';
import 'package:telelist/screens/home.dart';
import '/models/user.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  final int _currentIndex = 2;
  final List<Widget> _children = [
    const Home(),
    const Movies(),
    const FavoriteScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('Favoritos', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      backgroundColor: const Color.fromARGB(255, 0, 84, 159),
      body: _children[_currentIndex],
      bottomNavigationBar: bottomNavigation(
        _currentIndex,
        context,
      ),
    );
  }
}

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Text('Nome de usuário: ${user.username}',
              style: const TextStyle(color: Colors.white, fontSize: 28)),
        ],
      ),
    );
  }
}
