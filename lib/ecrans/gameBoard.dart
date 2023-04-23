import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snake/ecrans/home.dart';
import 'package:snake/outils/blank_pixel.dart';
import 'package:snake/outils/food_pixel.dart';
import 'package:snake/outils/snake.dart';
import 'package:snake/outils/snake_pixel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class GameBoard extends StatefulWidget {
  const GameBoard(this.game, {Key? key}) : super(key: key);

  final Snake game;

  @override
  State<GameBoard> createState() => _GameBoardState();
}

enum snake_Direction {HAUT, BAS, GAUCHE, DROITE}

class _GameBoardState extends State<GameBoard> {
  /* INIT LOGIN */
  final _formKey = GlobalKey<FormState>();
  String login = "";

  /* SIZE OF GAME CONTAINER */
  int rowSize = 10;
  int nbTotal = 100;

  /* RECEIVE DATA SNAKE SCORE*/
  var score = Snake.score;

  /* INIT A POSSIBLE BEST SCORE */
  int ?bestScore;

  /* BOOL FOR STARTGAME BUTTON */
  bool estCommencer = false;

  /* INIT POSITION OF FOOD AND BODY SNAKE */
  int foodPosition = 55;
  List<int> snakePosition = [0,1,2];
  

  /* FUNCTION NEEDING FOR PUSH SCORE DATA */
  Future<http.Response> envoiScore(
      int score) {
    return http.post(
      Uri.parse(
          'https://s3-4427.nuage-peda.fr/snake/public/api/classements'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: convert.jsonEncode(<String, dynamic>{
        "score": score,
      }),
    );
  }

  /* FUNCTON NEEDING FOR CHECK SCORE ON PUSH DATA */
  void checkPushData() async {
    var dataScore = await envoiScore(score);
    if(dataScore.statusCode == 201){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Score envoyé'),
      ));
    } else if(dataScore.statusCode == 422){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(''),
      ));
    } else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Connexion au serveur impossible'),
      ));
    }
  }

  /* INIT VARIABLE TO MAKE DIRECTION FOR SNAKE */
  var directionActu = snake_Direction.DROITE;

  /* INIT GAME ON START */
  void startGame(){
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
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

  /* GENERATE RANDOM POSITIONS ON 100 CONTAINER OF THE GAMECONTAINER */
  /* IF SNAKE POSITION IS IN FOOD POSITION, FOOD POSITION CHANGING */
  void eatFood(){
    while(snakePosition.contains(foodPosition)){
      foodPosition = Random().nextInt(nbTotal);
    }
  }

  /* MAKE MOOV ON SNAKE */
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

    /* IF HEAD SNAKE IS IN  */
    if(snakePosition.last == foodPosition){
      eatFood();
      score++;
    } else {
      snakePosition.removeAt(0);
    }
  }

  void newGame(){
    setState(() {
      snakePosition = [
        0,
        1,
        2,
      ];
      foodPosition == 55;
      directionActu = snake_Direction.DROITE;
      estCommencer = false;
      score = 0;
    });
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
                Text("Votre score est de $score"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Quitter'),
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/home");
              },
            ),
            TextButton(
              child: const Text('Rejouer'),
              onPressed: () {
                Navigator.of(context).pop();
                newGame();
              },
            ),
            TextButton(
              child: const Text('Sauvegarder et rejouer'),
              onPressed: () {
                setState(() {
                  Navigator.of(context).pop();
                  checkPushData();
                  newGame();
                });
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 35,
                      child: Image(image: AssetImage("assets/images/pomme.png")),
                    ),
                    Padding(padding: EdgeInsets.all(5)),
                    Text("$score",
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                  ],
                ),
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
              child: const Text("Jouer"),
            ),
          ],
        ),
      ),
    );
  }
}