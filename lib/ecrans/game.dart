import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snake/ecrans/gameBoard.dart';
import 'package:snake/outils/snake.dart';
import 'package:flutter/src/rendering/box.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final Snake _game = Snake();

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GameBoard();
  }
}