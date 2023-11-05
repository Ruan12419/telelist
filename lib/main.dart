import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/screens/login.dart';
import '/models/user.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => User(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Login(),
      ),
    ),
  );
}
