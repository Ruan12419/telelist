import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telelist/main.dart';
import 'package:telelist/screens/all_movies.dart';
import 'package:telelist/screens/home.dart';
import '/models/user.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final int _currentIndex = 2;
  final List<Widget> _children = [
    const Home(),
    const Movies(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil', style: TextStyle(color: Colors.black)),
        backgroundColor: const Color.fromARGB(255, 230, 230, 230),
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

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Text('Nome de usuário: ${user.username}',
              style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
