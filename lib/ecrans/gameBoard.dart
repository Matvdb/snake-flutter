import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snake/outils/blank_pixel.dart';
import 'package:snake/outils/food_pixel.dart';
import 'package:snake/outils/snake.dart';
import 'package:snake/outils/snake_pixel.dart';

class GameBoard extends StatefulWidget {
  const GameBoard(this.game, {Key? key}) : super(key: key);

  final Snake game;

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  int rowSize = 10;
  int nbTotal = 100;

  int foodPosition = 55;
  static List<int> snakePosition = [0,1,2];

  void incrementSnake(){}

  void startGame(){
      Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          snakePosition.add(snakePosition.last + 1);

          snakePosition.removeAt(0);
        });
      });      
  }

  Widget gameContainer(){
    return GridView.builder(
        itemCount: 100,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 10
        ), 
        itemBuilder: (context, index){
          if(snakePosition.contains(index)){
            return SnakePixel();
          } else if(foodPosition == index){
            return FoodPixel();
          } else {
            return BlancPixel();
          }
        }
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade700,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width,
              child: gameContainer(),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () => startGame(),
                child: const Text("Jouer"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}