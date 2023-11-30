import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telelist/screens/all_movies.dart';
import '/screens/home.dart';
import '/screens/profile.dart';
import '/screens/login.dart';
import '/models/user.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => User('', ''),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Login(),
      ),
    ),
  );
}

BottomNavigationBar bottomNavigation(int currentIndex, BuildContext context) {
  final List<Widget> children = [const Home(), const Movies(), const Profile()];
  if (currentIndex == 1) {
    children[0] = const Home();
    children[1] = const Movies();
    children[2] = const Profile();
  }

  return BottomNavigationBar(
    currentIndex: currentIndex,
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.movie),
        label: 'Filmes',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Perfil',
      ),
    ],
    onTap: (index) {
      if (index != currentIndex) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => children[index]),
        );
      }
    },
  );
}
