import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:telelist/main.dart';
import 'package:telelist/models/user.dart';
import 'package:telelist/repositories/movies_repository.dart';
import '/models/movie.dart';

class MoviesInfo extends StatefulWidget {
  Movie movie;
  final MoviesRepository moviesRepository = MoviesRepository();

  MoviesInfo({Key? key, required this.movie}) : super(key: key);

  @override
  State<MoviesInfo> createState() => _MoviesInfoState();
}

class _MoviesInfoState extends State<MoviesInfo> {
  fetchMoviesData() async {
    var user = Provider.of<User>(context, listen: false);
    await widget.moviesRepository.fetchMovie(widget.movie.uuid, user.userId);
    setState(() {
      widget.movie = widget.moviesRepository.movie;
    });
  }

  movies() {
    var user = Provider.of<User>(context, listen: false);

    return SingleChildScrollView(
      child: Container(
        width: 460,
        margin: const EdgeInsets.all(10),
        color: const Color.fromARGB(255, 0, 84, 159),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                mostraCapa(widget.movie.linkImagem),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      exibirModalComCamposDeTexto(
                        context,
                        widget.movie,
                        widget.moviesRepository,
                        user,
                        fetchMoviesData,
                      );
                    },
                  ),
                ),
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
                              widget.movie.titulo,
                              style: const TextStyle(color: Colors.black),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.favorite,
                            color: widget.movie.favorito
                                ? Colors.red
                                : Colors.grey,
                          ),
                          onPressed: () async {
                            setState(() {
                              widget.movie.favorito = !widget.movie.favorito;
                            });

                            if (kDebugMode) {
                              print(
                                  'Filme ${widget.movie.titulo} marcado como favorito');
                            }

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
              ],
            ),
            Container(
              width: 460,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Data de lançamento: ${widget.movie.dataDeLancamento}',
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: 460,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Diretores: ${widget.movie.diretores}',
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: 460,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Gêneros: ${widget.movie.generos}',
                style: const TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: 460,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Descrição: \n${widget.movie.descricao}',
                style: const TextStyle(color: Colors.white, fontSize: 22),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: 460,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Atores: ${widget.movie.atores}',
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: 460,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Roteiristas: ${widget.movie.roteiristas}',
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: 460,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Comentarios: ${widget.movie.comentarios}',
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: 460,
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.delete),
                label: const Text('Deletar Filme'),
                onPressed: () async {
                  try {
                    await widget.moviesRepository
                        .deleteMovie(widget.movie.uuid, user.userId);
                    if (kDebugMode) {
                      print('Filme deletado com sucesso!');
                    }
                    Navigator.pop(context);
                  } catch (e) {
                    if (kDebugMode) {
                      print('Falha ao deletar o filme: $e');
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
            ),
          ],
        ),
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
