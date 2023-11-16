import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telelist/main.dart';
import 'package:telelist/repositories/user_repository.dart';
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
  final List<Widget> _children = [HomeScreen(), Profile()];
  final UserRepository userRepository = UserRepository();

  @override
  void initState() {
    userRepository.fetchUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
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
      body: _children[_currentIndex],
      bottomNavigationBar: bottomNavigation(
        _currentIndex,
        context,
      ),
    );
  }
}

Container movies() {
  return Container(
    height: 200,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          width: 160,
          margin: const EdgeInsets.all(10),
          color: Colors.blue,
          child: Image.asset("imagens/logo.jpeg"),
        );
      },
    ),
  );
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Minha Lista",
                style: TextStyle(fontSize: 25),
              ),
            ),
          ),
          movies(),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Assistindo",
                style: TextStyle(fontSize: 25),
              ),
            ),
          ),
          movies(),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Assistidos",
                style: TextStyle(fontSize: 25),
              ),
            ),
          ),
          movies(),
        ],
      ),
    );
  }
}
