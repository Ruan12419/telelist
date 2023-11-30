import 'package:flutter/material.dart';

class MoviesInfo extends StatefulWidget {
  final dynamic movie;

  const MoviesInfo({Key? key, required this.movie}) : super(key: key);

  @override
  State<MoviesInfo> createState() => _MoviesInfoState();
}

class _MoviesInfoState extends State<MoviesInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie["title"]),
      ),
    );
  }
}
