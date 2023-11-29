import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Watching extends StatefulWidget {
  final List filmesNaoAssistidos;
  final List favorites;

  const Watching(
      {Key? key, required this.filmesNaoAssistidos, required this.favorites})
      : super(key: key);

  @override
  _WatchingState createState() => _WatchingState();
}

class _WatchingState extends State<Watching> {
  List<bool> favorites = [];

  @override
  void initState() {
    super.initState();
    favorites = List<bool>.filled(widget.filmesNaoAssistidos.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assistindo'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: widget.filmesNaoAssistidos.length,
        itemBuilder: (context, index) {
          return Container(
            width: 160,
            margin: const EdgeInsets.all(10),
            color: Colors.blue,
            child: Stack(
              children: <Widget>[
                Image.asset("imagens/logo.jpeg"),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.filmesNaoAssistidos[index]['title'],
                              style: const TextStyle(color: Colors.black),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.favorite,
                              color: favorites.isEmpty
                                  ? Colors.grey
                                  : favorites[index]
                                      ? Colors.red
                                      : Colors.grey),
                          onPressed: () {
                            setState(() {
                              favorites[index] = !favorites[index];
                            });
                            if (kDebugMode) {
                              print(
                                  'Filme ${widget.filmesNaoAssistidos[index]['title']} marcado como favorito');
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
