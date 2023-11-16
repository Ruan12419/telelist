import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telelist/screens/home.dart';
import 'package:telelist/screens/profile.dart';
import '/screens/login.dart';
import '/models/user.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => User("user", "123"),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Login(),
      ),
    ),
  );
}

BottomNavigationBar bottomNavigation(int currentIndex, BuildContext context) {
  final List<Widget> _children = [HomeScreen(), Profile()];
  if (currentIndex == 1) {
    _children[0] = Home();
    _children[1] = ProfileScreen();
  }

  return BottomNavigationBar(
    currentIndex: currentIndex,
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Perfil',
      ),
    ],
    onTap: (index) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => _children[index]),
      );
    },
  );
}
