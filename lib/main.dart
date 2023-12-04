import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';
import 'package:telelist/models/movie.dart';
import 'package:telelist/repositories/movies_repository.dart';
import 'package:telelist/screens/movies_screen.dart';
import '/screens/home.dart';
import 'screens/favorites.dart';
import '/screens/login.dart';
import '/models/user.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => User('', ''),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Login(),
      ),
    ),
  );
}

BottomNavigationBar bottomNavigation(int currentIndex, BuildContext context) {
  final List<Widget> children = [const Home(), const Movies(), Favorite()];
  if (currentIndex == 1) {
    children[0] = const Home();
    children[1] = const Movies();
    children[2] = Favorite();
  }

  return BottomNavigationBar(
    currentIndex: currentIndex,
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.movie),
        label: 'Filmes',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.favorite),
        label: 'Favoritos',
      ),
    ],
    onTap: (index) {
      if (index != currentIndex) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => children[index]),
        );
      }
    },
  );
}

FutureBuilder<File?> mostraCapa(String linkImagem) {
  return FutureBuilder<File?>(
    future: () async {
      File? imageFile;
      try {
        imageFile = await DefaultCacheManager().getSingleFile(linkImagem);
        if (!imageFile.existsSync()) {
          throw Exception('File does not exist');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Failed to download file or file does not exist: $e');
        }
        imageFile = null;
      }
      return imageFile;
    }(),
    builder: (BuildContext context, AsyncSnapshot<File?> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      } else if (snapshot.error != null || snapshot.data == null) {
        return Image.asset('imagens/logo.jpeg');
      } else {
        return Image.file(snapshot.data!);
      }
    },
  );
}

void showModalCreateMovie(
    BuildContext context, MoviesRepository moviesRepository, User user) {
  var controllers = {
    'titulo': TextEditingController(),
    'descricao': TextEditingController(),
    'linkImagem': TextEditingController(),
    'dataDeLancamento': TextEditingController(),
    'diretores': TextEditingController(),
    'roteiristas': TextEditingController(),
    'atores': TextEditingController(),
    'generos': TextEditingController(),
    'comentarios': TextEditingController(),
    'estrelas': TextEditingController(),
  };

  String dropdownValue = 'Para assistir';
  List<String> statusOptions = ['Para assistir', 'Assistindo', 'Assistido'];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.9,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: controllers.length + 1,
                  itemBuilder: (context, index) {
                    if (index < controllers.length) {
                      String key = controllers.keys.elementAt(index);
                      return TextField(
                        controller: controllers[key],
                        decoration: InputDecoration(
                          labelText: key.toUpperCase(),
                          hintText:
                              key == 'dataDeLancamento' ? 'ANO-MES-DIA' : null,
                        ),
                      );
                    } else {
                      return DropdownButtonFormField<String>(
                        value: dropdownValue,
                        decoration: const InputDecoration(labelText: 'STATUS'),
                        items: statusOptions
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          dropdownValue = newValue!;
                        },
                      );
                    }
                  },
                ),
              ),
              ElevatedButton(
                child: const Text('Adicionar Filme'),
                onPressed: () async {
                  Movie newMovie = Movie(
                    uuid: '',
                    titulo: controllers['titulo']!.text,
                    descricao: controllers['descricao']!.text,
                    linkImagem: controllers['linkImagem']!.text,
                    dataDeLancamento: controllers['dataDeLancamento']!.text,
                    diretores: controllers['diretores']!.text,
                    roteiristas: controllers['roteiristas']!.text,
                    atores: controllers['atores']!.text,
                    generos: controllers['generos']!.text,
                    comentarios: controllers['comentarios']!.text,
                    estrelas:
                        double.tryParse(controllers['estrelas']!.text) ?? 0.0,
                    status: dropdownValue,
                    favorito: false,
                    usuario: 0,
                  );
                  try {
                    await moviesRepository.createMovie(user.userId, newMovie);
                    if (kDebugMode) {
                      print('Filme criado!');
                    }
                  } catch (e) {
                    if (kDebugMode) {
                      print('Falha ao criar novo filme: $e');
                    }
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

void exibirModalComCamposDeTexto(BuildContext context, Movie movie,
    MoviesRepository moviesRepository, User user, Function fetchMoviesData) {
  var controllers = {
    'titulo': TextEditingController(text: movie.titulo),
    'descricao': TextEditingController(text: movie.descricao),
    'linkImagem': TextEditingController(text: movie.linkImagem),
    'dataDeLancamento': TextEditingController(text: movie.dataDeLancamento),
    'diretores': TextEditingController(text: movie.diretores),
    'roteiristas': TextEditingController(text: movie.roteiristas),
    'atores': TextEditingController(text: movie.atores),
    'generos': TextEditingController(text: movie.generos),
    'comentarios': TextEditingController(text: movie.comentarios),
    'estrelas': TextEditingController(text: movie.estrelas.toString()),
  };

  String dropdownValue = movie.status;
  List<String> statusOptions = ['Para assistir', 'Assistindo', 'Assistido'];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.9,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: controllers.length + 1,
                  itemBuilder: (context, index) {
                    if (index < controllers.length) {
                      String key = controllers.keys.elementAt(index);
                      return TextField(
                        controller: controllers[key],
                        decoration:
                            InputDecoration(labelText: key.toUpperCase()),
                      );
                    } else {
                      return DropdownButtonFormField<String>(
                        value: dropdownValue,
                        decoration: const InputDecoration(labelText: 'STATUS'),
                        items: statusOptions
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          dropdownValue = newValue!;
                        },
                      );
                    }
                  },
                ),
              ),
              ElevatedButton(
                child: const Text('Salvar Alterações'),
                onPressed: () async {
                  movie.status = dropdownValue;
                  _salvarAlteracoes(movie, controllers, moviesRepository, user,
                      fetchMoviesData);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _salvarAlteracoes(
    Movie movie,
    Map<String, TextEditingController> controllers,
    MoviesRepository moviesRepository,
    User user,
    Function fetchMoviesData) async {
  movie.titulo = controllers['titulo']!.text;
  movie.descricao = controllers['descricao']!.text;
  movie.linkImagem = controllers['linkImagem']!.text;
  movie.dataDeLancamento = controllers['dataDeLancamento']!.text;
  movie.diretores = controllers['diretores']!.text;
  movie.roteiristas = controllers['roteiristas']!.text;
  movie.atores = controllers['atores']!.text;
  movie.generos = controllers['generos']!.text;
  movie.comentarios = controllers['comentarios']!.text;
  movie.estrelas = double.tryParse(controllers['estrelas']!.text) ?? 0.0;

  try {
    await moviesRepository.updateMovie(movie.uuid, user.userId, movie);
    fetchMoviesData();
    if (kDebugMode) {
      print('Filme atualizado!');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Falha ao atualizar o filme: $e');
    }
  }
}
