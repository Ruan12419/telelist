import 'package:flutter/material.dart';
import 'package:telelist/main.dart';

class Movies extends StatefulWidget {
  const Movies({super.key});

  @override
  State<Movies> createState() => _MoviesState();
}

class _MoviesState extends State<Movies> {
  final int _currentIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filmes"),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: 2,
        itemBuilder: (BuildContext context, int index) {
          return;
        },
      ),
      bottomNavigationBar: bottomNavigation(
        _currentIndex,
        context,
      ),
    );
  }
}
