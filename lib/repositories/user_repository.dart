import 'package:dio/dio.dart';

class UserRepository {
  final dio = Dio();
  final String apiUrl = 'https://jsonplaceholder.typicode.com/todos/';

  List users = [];

  Future fetchUsers() async {
    final response = await dio.get(apiUrl);

    if (response.statusCode == 200) {
      return users.addAll(response.data);
    } else {
      throw Exception("Falha ao buscar usuários!");
    }
  }
}
