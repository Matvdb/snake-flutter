import 'package:flutter/material.dart';
import 'package:snake/ecrans/game.dart';
import 'package:snake/ecrans/gameBoard.dart';
import 'package:snake/ecrans/home.dart';
import 'package:snake/outils/snake.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      home: const MyHomePage(title: 'Snake'),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/snake': (BuildContext context) => GameScreen(),
      }
    );
  }
}
