import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:telelist/main.dart';
import 'package:telelist/models/user.dart';
import 'package:telelist/repositories/movies_repository.dart';
import 'package:telelist/screens/home.dart';
import 'package:telelist/screens/movies_info.dart';
import 'package:telelist/screens/my_list.dart';
import 'package:telelist/screens/watched.dart';
import 'package:telelist/screens/watching.dart';
import '/screens/login.dart';
import 'favorites.dart';
import '/models/movie.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final MoviesRepository moviesRepository = MoviesRepository();
  TextEditingController _searchController = TextEditingController();
  int _currentIndex = 0;

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

  void updateMoviesList(String query) {
    if (query.isEmpty) {
      setState(() {
        movies = moviesRepository.movies;
      });
    } else {
      var filteredMovies = moviesRepository.movies
          .where((movie) =>
              movie.titulo.toLowerCase().contains(query.toLowerCase()))
          .toList();

      setState(() {
        movies = filteredMovies;
      });
    }
  }

  Widget moviesContainer(String status, BuildContext context) {
    var user = Provider.of<User>(context, listen: false);
    var filteredMovies =
        movies.where((movie) => movie.status == status).toList();

    return Container(
      height: 200,
      child: filteredMovies.isNotEmpty
          ? ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filteredMovies.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MoviesInfo(
                          movie: filteredMovies[index],
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
                        mostraCapa(filteredMovies[index].linkImagem),
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
                            width: 160,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      filteredMovies[index].titulo,
                                      style:
                                          const TextStyle(color: Colors.black),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.favorite,
                                      color: filteredMovies[index].favorito
                                          ? Colors.red
                                          : Colors.grey),
                                  onPressed: () async {
                                    try {
                                      if (kDebugMode) {
                                        print(
                                            'Filme ${filteredMovies[index].titulo} marcado como favorito');
                                      }
                                      await moviesRepository.updateMovie(
                                          filteredMovies[index].uuid,
                                          user.userId,
                                          filteredMovies[index]);
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
                  ),
                );
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);

    final List<Widget> children = [
      HomeScreen(
        moviesContainer: (status, context) => moviesContainer(status, context),
        moviesList: movies,
      ),
      const Favorite(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('TeleList', style: TextStyle(color: Colors.black)),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: (query) {
                    updateMoviesList(query);
                  },
                  decoration: const InputDecoration(
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
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            color: Colors.black,
            onPressed: () {
              user.setUsername('');
              user.setPassword('');
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 0, 84, 159),
      body: children[_currentIndex],
      bottomNavigationBar: bottomNavigation(
        _currentIndex,
        context,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final Widget Function(String, BuildContext) moviesContainer;
  final List<Movie> moviesList;

  const HomeScreen(
      {Key? key, required this.moviesContainer, required this.moviesList})
      : super(key: key);

  Padding moviesListView(String type, BuildContext context, int screen) {
    List screens = [
      MyListPage(
          movies: moviesList
              .where((movie) => movie.status == "Para assistir")
              .toList()),
      Watching(
          movies: moviesList
              .where((movie) => movie.status == "Assistindo")
              .toList()),
      Watched(
          movies: moviesList
              .where((movie) => movie.status == "Assistido")
              .toList()),
    ];
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => screens[screen],
              ),
            );
          },
          child: Text(
            "$type ",
            style: const TextStyle(fontSize: 25, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          moviesListView("Minha Lista", context, 0),
          moviesContainer("Para assistir", context),
          moviesListView("Assistindo", context, 1),
          moviesContainer("Assistindo", context),
          moviesListView("Assistidos", context, 2),
          moviesContainer("Assistido", context),
        ],
      ),
    );
  }
}
