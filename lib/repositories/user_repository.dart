import 'package:dio/dio.dart';
import '/models/user.dart';

class UserRepository {
  final dio = Dio();
  final String apiUrl = 'https://apiloomi.onrender.com/login/';

  Future fetchUsers(User user) async {
    final response = await dio.post(
      apiUrl,
      options: Options(
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
          'X-CSRFTOKEN':
              'NjvxHGV62q95v4lULzPEfK0ylD9qLdCK3NtvueOG23CknQQENmZRDIJTQ826JZ6A',
          'username': user.username,
          'password': user.password,
        },
      ),
      data: user.toJson(),
    );

    if (response.statusCode == 200) {
      return response.data['user_id'];
    } else {
      throw Exception("Falha ao buscar usuários!");
    }
  }
}
