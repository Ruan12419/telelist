import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telelist/main.dart';
import 'package:telelist/models/movie.dart';
import 'package:telelist/models/user.dart';
import 'package:telelist/repositories/movies_repository.dart';
import 'package:telelist/screens/movies_info.dart';

class Movies extends StatefulWidget {
  const Movies({super.key});

  @override
  State<Movies> createState() => _MoviesState();
}

class _MoviesState extends State<Movies> {
  final int _currentIndex = 1;
  final MoviesRepository moviesRepository = MoviesRepository();
  List<Movie> movies = [];

  @override
  void initState() {
    super.initState();
    fetchMoviesData();
  }

  fetchMoviesData() async {
    var user = Provider.of<User>(context, listen: false);
    await moviesRepository.fetchMovies(user.userId);
    setState(() {
      movies = moviesRepository.movies;
    });
  }

  Widget moviesContainer(User user) {
    return Expanded(
      child: movies.isNotEmpty
          ? GridView.count(
              crossAxisCount: 2,
              children: List.generate(
                movies.length,
                (index) {
                  return RepaintBoundary(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MoviesInfo(
                              movie: movies[index],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 160,
                        margin: const EdgeInsets.all(10),
                        color: Colors.white,
                        child: Stack(
                          children: <Widget>[
                            mostraCapa(movies[index].linkImagem),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  exibirModalComCamposDeTexto(
                                    context,
                                    movies[index],
                                    moviesRepository,
                                    user,
                                    fetchMoviesData,
                                  );
                                },
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              left: 0,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 233, 232, 232),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(7),
                                    topRight: Radius.circular(7),
                                  ),
                                ),
                                width: 160,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          movies[index].titulo,
                                          style: const TextStyle(
                                              color: Colors.black),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.favorite,
                                          color: movies[index].favorito
                                              ? Colors.red
                                              : Colors.grey),
                                      onPressed: () async {
                                        setState(() {
                                          movies[index].favorito =
                                              !movies[index].favorito;
                                        });
                                        if (kDebugMode) {
                                          print(
                                              'Filme ${movies[index].titulo} marcado como favorito');
                                        }
                                        try {
                                          await moviesRepository.updateMovie(
                                              movies[index].uuid,
                                              user.userId,
                                              movies[index]);
                                        } catch (e) {
                                          if (kDebugMode) {
                                            print(
                                                'Falha ao atualizar o filme: $e');
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
                      ),
                    ),
                  );
                },
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: Row(
          children: [
            const Text(
              "Filmes",
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Pesquisar',
                    prefixIcon: Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: const Color.fromARGB(255, 0, 84, 159),
      body: Column(
        children: <Widget>[
          moviesContainer(user),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalCreateMovie(context, moviesRepository, user);
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: bottomNavigation(
        _currentIndex,
        context,
      ),
    );
  }
}
