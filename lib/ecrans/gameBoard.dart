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

enum snake_Direction {HAUT, BAS, GAUCHE, DROITE}

class _GameBoardState extends State<GameBoard> {
  int rowSize = 10;
  int nbTotal = 100;
  var score = Snake.score;
  bool estCommencer = false;

  int foodPosition = 55;
  List<int> snakePosition = [0,1,2];

  var directionActu = snake_Direction.DROITE;

  void startGame(){
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {
        estCommencer = true;
        mouvementSnake();
        eatFood();
        if(gameOver()){
          timer.cancel();
          _loose();
        }
      });
    });      
  }

  void eatFood(){
    while(snakePosition.contains(foodPosition)){
      foodPosition = Random().nextInt(nbTotal);
    }
  }

  void mouvementSnake(){
    switch (directionActu){
      case snake_Direction.DROITE:
        {
          if(snakePosition.last % rowSize == 9){
            snakePosition.add(snakePosition.last + 1 - rowSize);
          } else {
            snakePosition.add(snakePosition.last + 1);
          }
        }
        break;
      case snake_Direction.GAUCHE:
        {
          if(snakePosition.last % rowSize == 0){
            snakePosition.add(snakePosition.last - 1 + rowSize);
          } else {
            snakePosition.add(snakePosition.last - 1);
          }
        }
        break;
      case snake_Direction.HAUT:
        {
          if(snakePosition.last < rowSize){
            snakePosition.add(snakePosition.last - rowSize + nbTotal);
          } else {
            snakePosition.add(snakePosition.last - rowSize);
          }
        }
        break;
      case snake_Direction.BAS:
        {
          if(snakePosition.last + rowSize > nbTotal){
            snakePosition.add(snakePosition.last + rowSize - nbTotal);
          } else {
            snakePosition.add(snakePosition.last + rowSize);
          }
        }
        break;
      default:
    }

    if(snakePosition.last == foodPosition){
      eatFood();
      score++;
    } else {
      snakePosition.removeAt(0);
    }
  }

  bool gameOver(){
    List<int> bodySnake = snakePosition.sublist(0, snakePosition.length - 1);
    if(bodySnake.contains(snakePosition.last)){
      return true;
    }
    return false;
  }

  Future<void> _loose() async { // Widget affichant un pop-up lorsque le Joueur a perdu
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Dommage... 😫', style: TextStyle(fontSize: 28.0),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Row(
                  children: [
                    Text("Votre score est de "),
                    Text("$score"),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Fermer'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Rejouer'),
              onPressed: () {
                Navigator.pushNamed(context, "/snake");
              },
            ),
          ],
        );
      }
    );
  }

  Widget gameContainer(){
    return GestureDetector(
      onVerticalDragUpdate: (details){
        if(details.delta.dy > 0 && directionActu != snake_Direction.HAUT){
          directionActu = snake_Direction.BAS;
        } else if(details.delta.dy < 0 && directionActu != snake_Direction.BAS){
          directionActu = snake_Direction.HAUT;
        }
      },
      onHorizontalDragUpdate: (details){
        if(details.delta.dx > 0 && directionActu != snake_Direction.GAUCHE){
          directionActu = snake_Direction.DROITE;
        } else if(details.delta.dx < 0 && directionActu != snake_Direction.DROITE){
          directionActu = snake_Direction.GAUCHE;
        }
      },
      child: GridView.builder(
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
      ),
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
              child: Center(
                child: Text("$score",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width,
              child: gameContainer(),
            ),
            ElevatedButton(
              onPressed: estCommencer == true ? () {} : startGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: estCommencer == true ? Colors.grey : Colors.blue,
              ),
              child: Text("Jouer"),
            ),
          ],
        ),
      ),
    );
  }
}