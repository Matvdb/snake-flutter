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
  // init login + key form
  final _formKey = GlobalKey<FormState>();
  String login = "";

  // size du container de jeu
  int rowSize = 10;
  int nbTotal = 100;

  // init variable pour récupérer la donnée score de la classe Snake
  var score = Snake.score;

  // init d'un possible meilleur score
  int ?bestScore;

  // booléen init à false pour le commencement de la partie
  bool estCommencer = false;

  // position de base de la nourriture ainsi que du corps du Snake
  int foodPosition = 55;
  List<int> snakePosition = [0,1,2];
  

  // fonction permettant l'envoi du score dans la BDD
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

  // fonction permettant de vérifier l'envoi du score avec API Plateform
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

  // init de la direction de base du Snake (vers la droite)
  var directionActu = snake_Direction.DROITE;

  // fonction de début de game
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

  // fonction permettant le déplacement aléatoire de la pomme
  // si la tête du Snake est sur sa position, alors la pomme changera de façon random
  // dans les 100 cases
  void eatFood(){
    while(snakePosition.contains(foodPosition)){
      foodPosition = Random().nextInt(nbTotal);
    }
  }

  // fonction permettant les mouvements de déplacements du Snake
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

    // si la tête du Snake est sur la position de la pomme
    if(snakePosition.last == foodPosition){
      eatFood();
      score++;
    } else {
      snakePosition.removeAt(0);
    }
  }

  // fonction permettant la création d'une nouvelle partie
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

  // fonction booléenne retournant vrai seulement si la tête du Snake est sur la position de son corps
  bool gameOver(){
    List<int> bodySnake = snakePosition.sublist(0, snakePosition.length - 1);
    if(bodySnake.contains(snakePosition.last)){
      return true;
    }
    return false;
  }

  // Widget affichant un pop-up lorsque le Joueur a perdu
  Future<void> _loose() async {
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 35,
                      child: Image(
                        image: AssetImage("assets/images/pomme.png")
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(5)),
                    Text("$score"),
                  ],
                ),
                const Padding(padding: EdgeInsets.all(15)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Align(
                      alignment: Alignment.center,
                      child: Text("Votre score est de "),
                    ),
                    Text("$score", style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),)
                  ],
                ),
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
            TextButton(
              child: const Text('Sauvegarder et quitter'),
              onPressed: () {
                setState(() {
                  Navigator.pushNamed(context, '/home');
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
            return const SnakePixel();
          } else if(foodPosition == index){
            return const FoodPixel();
          } else {
            return const BlancPixel();
          }
        }
      ),
    );
  }

  List<Widget> btnDeplacement(){
    return [
      Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                  onPressed: () {
                    if(directionActu != snake_Direction.BAS && directionActu == snake_Direction.GAUCHE || directionActu == snake_Direction.DROITE){
                      directionActu = snake_Direction.HAUT;
                    }
                  }, 
                  child: Icon(Icons.arrow_circle_up_rounded),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: estCommencer == false ? Colors.grey : Theme.of(context).primaryColor,
                  ),
                  
                ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if(directionActu != snake_Direction.DROITE && directionActu == snake_Direction.HAUT || directionActu == snake_Direction.BAS){
                      directionActu = snake_Direction.GAUCHE;
                    }
                  }, 
                  child: Icon(Icons.arrow_circle_left_outlined),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: estCommencer == false ? Colors.grey : Theme.of(context).primaryColor,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if(directionActu != snake_Direction.GAUCHE && directionActu == snake_Direction.HAUT || directionActu == snake_Direction.BAS){
                      directionActu = snake_Direction.DROITE;
                    }
                  },
                  child: Icon(Icons.arrow_circle_right_outlined),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: estCommencer == false ? Colors.grey : Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                  onPressed: () {
                    if(directionActu != snake_Direction.HAUT && directionActu == snake_Direction.DROITE || directionActu == snake_Direction.GAUCHE){
                      directionActu = snake_Direction.BAS;
                    }
                  },
                  child: Icon(Icons.arrow_circle_down_outlined),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: estCommencer == false ? Colors.grey : Theme.of(context).primaryColor,
                  ),
                ),
            ),
    ];
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
                    const SizedBox(
                      height: 35,
                      child: Image(image: AssetImage("assets/images/pomme.png")),
                    ),
                    const Padding(padding: EdgeInsets.all(5)),
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: btnDeplacement(),
            ),
            ElevatedButton(
              onPressed: (){
                if(estCommencer == false){
                  startGame();
                  btnDeplacement();
                } else {}
              },
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