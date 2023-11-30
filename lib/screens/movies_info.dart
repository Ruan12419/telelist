import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telelist/models/user.dart';
import 'package:telelist/repositories/movies_repository.dart';
import '/models/movie.dart';

class MoviesInfo extends StatefulWidget {
  final Movie movie;
  final MoviesRepository moviesRepository = MoviesRepository();

  MoviesInfo({Key? key, required this.movie}) : super(key: key);

  @override
  State<MoviesInfo> createState() => _MoviesInfoState();
}

class _MoviesInfoState extends State<MoviesInfo> {
  movies() {
    var user = Provider.of<User>(context, listen: false);

    return Container(
      width: 460,
      margin: const EdgeInsets.all(10),
      color: const Color.fromARGB(255, 0, 84, 159),
      child: Stack(
        children: <Widget>[
          Image.asset("imagens/logo.jpeg"),
          Positioned(
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(7),
                  topRight: Radius.circular(7),
                ),
              ),
              width: 460,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.movie.descricao,
                        style: const TextStyle(color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.favorite,
                        color:
                            widget.movie.favorito ? Colors.red : Colors.grey),
                    onPressed: () async {
                      setState(() {
                        widget.movie.favorito = !widget.movie.favorito;
                      });
                      if (kDebugMode) {
                        print(
                            'Filme ${widget.movie.titulo} marcado como favorito');
                      }
                      // Atualiza o filme no servidor
                      try {
                        await widget.moviesRepository.updateMovie(
                            widget.movie.uuid, user.userId, widget.movie);
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
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'descrição',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.titulo),
      ),
      backgroundColor: const Color.fromARGB(255, 0, 84, 159),
      body: movies(),
    );
  }
}
