import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telelist/main.dart';
import 'package:telelist/models/movie.dart';
import 'package:telelist/repositories/movies_repository.dart';
import 'package:telelist/screens/movies_screen.dart';
import 'package:telelist/screens/home.dart';
import '/models/user.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  final int _currentIndex = 2;

  final List<Widget> _children = [
    const Home(),
    const Movies(),
    FavoriteScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('Favoritos', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
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

class FavoriteScreen extends StatefulWidget {
  FavoriteScreen({Key? key}) : super(key: key);

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late Future<List<Movie>> favoriteMoviesFuture;
  late MoviesRepository moviesRepository = MoviesRepository();

  @override
  void initState() {
    super.initState();
    favoriteMoviesFuture = fetchFavoriteMovies();
  }

  Future<List<Movie>> fetchFavoriteMovies() async {
    var user = Provider.of<User>(context, listen: false);
    await moviesRepository.fetchMovies(user.userId);
// Filtra os filmes baseando-se no campo booleano 'favorito'
    return moviesRepository.movies.where((movie) => movie.favorito).toList();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Text('Nome de usuário: ${user.username}',
              style: const TextStyle(color: Colors.white, fontSize: 28)),
          const SizedBox(height: 20),
          const Text('Filmes Favoritos:',
              style: TextStyle(color: Colors.white, fontSize: 20)),
          Expanded(
            child: FutureBuilder<List<Movie>>(
              future: favoriteMoviesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Erro: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var movie = snapshot.data![index];
                      return ListTile(
                        title: Text(movie.titulo,
                            style: const TextStyle(color: Colors.white)),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                          onPressed: () async {
                            movie.favorito = false;
                            if (kDebugMode) {
                              print(
                                  'Filme ${movie.titulo} removido dos favoritos');
                            }
                            try {
                              await moviesRepository.updateMovie(
                                movie.uuid,
                                user.userId,
                                movie,
                              );
                              setState(() {
                                favoriteMoviesFuture = fetchFavoriteMovies();
                              });
                            } catch (e) {
                              if (kDebugMode) {
                                print('Falha ao atualizar o filme: $e');
                              }
                            }
                          },
                        ),
                      );
                    },
                  );
                } else {
                  return const Text('Nenhum filme favorito encontrado.');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
