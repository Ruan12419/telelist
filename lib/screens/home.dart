import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telelist/main.dart';
import 'package:telelist/repositories/user_repository.dart';
import 'package:telelist/screens/my_list.dart';
import 'package:telelist/screens/watched.dart';
import 'package:telelist/screens/watching.dart';
import '/screens/login.dart';
import '/screens/profile.dart';
import '/models/user.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final UserRepository userRepository = UserRepository();
  List users = [];
  List<bool> favorites = [];

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  fetchUserData() async {
    await userRepository.fetchUsers();
    setState(() {
      users = userRepository.users;
      favorites = List<bool>.filled(users.length, false);
    });
  }

  Container movies() {
    return Container(
      height: 200,
      child: users.isNotEmpty
          ? ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: users.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 160,
                  margin: const EdgeInsets.all(10),
                  color: Colors.blue,
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
                          width: 160,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    users[index]['title'],
                                    style: const TextStyle(color: Colors.black),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.favorite,
                                    color: favorites.isEmpty
                                        ? Colors.grey
                                        : favorites[index]
                                            ? Colors.red
                                            : Colors.grey),
                                onPressed: () {
                                  setState(() {
                                    favorites[index] = !favorites[index];
                                  });
                                  if (kDebugMode) {
                                    print(
                                        'Filme ${users[index]['title']} marcado como favorito');
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
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    final List<Widget> children = [
      HomeScreen(movies: movies, users: users, favorites: favorites),
      const Profile()
    ];
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('TeleList', style: TextStyle(color: Colors.white)),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
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
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              user.setUsername('');
              user.setPassword('');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
              );
            },
          ),
        ],
      ),
      body: children[_currentIndex],
      bottomNavigationBar: bottomNavigation(
        _currentIndex,
        context,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final Container Function() movies;
  final List users;
  final List favorites;

  const HomeScreen(
      {Key? key,
      required this.movies,
      required this.users,
      required this.favorites})
      : super(key: key);

  Padding moviesListView(String type, BuildContext context, int screen) {
    List screens = [
      MyListPage(filmesNaoAssistidos: users, favorites: favorites),
      Watching(filmesNaoAssistidos: users, favorites: favorites),
      Watched(filmesNaoAssistidos: users, favorites: favorites),
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
            style: const TextStyle(fontSize: 25),
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
          movies(),
          moviesListView("Assistindo", context, 1),
          movies(),
          moviesListView("Assistidos", context, 2),
          movies(),
        ],
      ),
    );
  }
}
