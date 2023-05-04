import 'package:flutter/material.dart';
import 'package:snake/ecrans/game.dart';
import 'package:snake/ecrans/gameBoard.dart';
import 'package:snake/ecrans/home.dart';
import 'package:snake/ecrans_niveaux/snake_difficile.dart';
import 'package:snake/ecrans_niveaux/snake_extreme.dart';
import 'package:snake/ecrans_niveaux/snake_intermediaire.dart';
import 'package:snake/outils/snake.dart';
import 'package:snake/splashScreen/splashScreen.dart';

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
        primaryColor: Colors.green[400],
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/snake': (BuildContext context) => GameScreen(),
        '/snakeInter': (BuildContext context) => NiveauIntermediaire(),
        '/snakeDiff': (BuildContext context) => Difficile(),
        '/snakeExtre': (BuildContext context) => Extreme(),
        '/home': (BuildContext context) => MyHomePage(),
      }
    );
  }
}
