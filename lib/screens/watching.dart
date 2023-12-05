import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telelist/main.dart';
import 'package:telelist/repositories/movies_repository.dart';
import '../models/user.dart';
import '/models/movie.dart';

class Watching extends StatefulWidget {
  final List<Movie> movies;
  final MoviesRepository moviesRepository = MoviesRepository();

  Watching({Key? key, required this.movies}) : super(key: key);

  @override
  _WatchingState createState() => _WatchingState();
}

class _WatchingState extends State<Watching> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Assistindo',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 0, 84, 159),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: widget.movies.length,
        itemBuilder: (context, index) {
          return Container(
            width: 160,
            margin: const EdgeInsets.all(10),
            color: Colors.blue,
            child: Stack(
              children: <Widget>[
                mostraCapa(widget.movies[index].linkImagem),
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
                              widget.movies[index].titulo,
                              style: const TextStyle(color: Colors.black),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.favorite,
                              color: widget.movies[index].favorito
                                  ? Colors.red
                                  : Colors.grey),
                          onPressed: () async {
                            setState(() {
                              widget.movies[index].favorito =
                                  !widget.movies[index].favorito;
                            });
                            if (kDebugMode) {
                              print(
                                  'Filme ${widget.movies[index].titulo} marcado como favorito');
                            }
                            try {
                              await widget.moviesRepository.updateMovie(
                                  widget.movies[index].uuid,
                                  user.userId,
                                  widget.movies[index]);
                            } catch (e) {
                              if (kDebugMode) {
                                print('Falha ao atualizar o filme: $e');
                              }
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
