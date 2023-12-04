import 'package:dio/dio.dart';
import 'package:telelist/models/movie.dart';

class MoviesRepository {
  final dio = Dio();
  final String apiUrl = 'https://apiloomi.onrender.com/filme/';
  List<Movie> _movies = [];
  late Movie _movie;

  List<Movie> get movies => _movies;
  Movie get movie => _movie;

  Future<List<Movie>> fetchMovies(String userId) async {
    final response = await dio.get(
      '${apiUrl}user/$userId/',
      options: Options(
        headers: {
          'accept': 'application/json',
          'X-CSRFTOKEN':
              'NjvxHGV62q95v4lULzPEfK0ylD9qLdCK3NtvueOG23CknQQENmZRDIJTQ826JZ6A',
        },
      ),
    );

    if (response.statusCode == 200) {
      _movies = (response.data as List).map((i) => Movie.fromJson(i)).toList();
      return _movies;
    } else {
      throw Exception("Falha ao buscar filmes!");
    }
  }

  Future<Movie> fetchMovie(String movieId, String userId) async {
    final response = await dio.get(
      '$apiUrl$movieId/user/$userId/',
      options: Options(
        headers: {
          'accept': 'application/json',
          'X-CSRFTOKEN':
              'NjvxHGV62q95v4lULzPEfK0ylD9qLdCK3NtvueOG23CknQQENmZRDIJTQ826JZ6A',
        },
      ),
    );

    if (response.statusCode == 200) {
      _movie = Movie.fromJson(response.data);
      return _movie;
    } else {
      throw Exception("Falha ao buscar filme!");
    }
  }

  Future<Movie> updateMovie(
      String movieId, String userId, Movie movieData) async {
    final response = await dio.put(
      '$apiUrl$movieId/user/$userId/',
      options: Options(
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
          'X-CSRFTOKEN':
              'NjvxHGV62q95v4lULzPEfK0ylD9qLdCK3NtvueOG23CknQQENmZRDIJTQ826JZ6A',
        },
      ),
      data: movieData.toJson(),
    );

    if (response.statusCode == 200) {
      return Movie.fromJson(response.data);
    } else {
      throw Exception("Falha ao atualizar filme!");
    }
  }

  Future<Movie> patchMovie(
      String movieId, String userId, Movie movieData) async {
    final response = await dio.patch(
      '$apiUrl$movieId/user/$userId/',
      options: Options(
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
          'X-CSRFTOKEN':
              'NjvxHGV62q95v4lULzPEfK0ylD9qLdCK3NtvueOG23CknQQENmZRDIJTQ826JZ6A',
        },
      ),
      data: movieData.toJson(),
    );

    if (response.statusCode == 200) {
      return Movie.fromJson(response.data);
    } else {
      throw Exception("Falha ao atualizar parcialmente o filme!");
    }
  }

  Future deleteMovie(String movieId, String userId) async {
    final response = await dio.delete(
      '$apiUrl$movieId/user/$userId/',
      options: Options(
        headers: {
          'accept': '*/*',
          'X-CSRFTOKEN':
              'NjvxHGV62q95v4lULzPEfK0ylD9qLdCK3NtvueOG23CknQQENmZRDIJTQ826JZ6A',
        },
      ),
    );

    if (response.statusCode == 204) {
      return response.data;
    } else {
      throw Exception("Falha ao deletar o filme!");
    }
  }

  Future<Movie> createMovie(String userId, Movie movieData) async {
    var movie = {
      "titulo": movieData.titulo,
      "descricao": movieData.descricao,
      "link_imagem": movieData.linkImagem,
      "data_de_lancamento": movieData.dataDeLancamento,
      "diretores": movieData.diretores,
      "roteiristas": movieData.roteiristas,
      "atores": movieData.atores,
      "generos": movieData.generos,
      "comentarios": movieData.comentarios,
      "estrelas": movieData.estrelas,
      "favorito": movieData.favorito,
      "status": movieData.status,
    };
    final response = await dio.post(
      '${apiUrl}user/$userId/',
      options: Options(
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
          'X-CSRFTOKEN':
              'NjvxHGV62q95v4lULzPEfK0ylD9qLdCK3NtvueOG23CknQQENmZRDIJTQ826JZ6A',
        },
      ),
      data: movie,
    );

    if (response.statusCode == 201) {
      return Movie.fromJson(response.data);
    } else {
      throw Exception("Falha ao criar o filme!");
    }
  }
}
