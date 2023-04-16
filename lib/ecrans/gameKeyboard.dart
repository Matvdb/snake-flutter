import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snake/ecrans/gameBoard.dart';
import 'package:snake/outils/snake.dart';

class GameKeyboard extends StatefulWidget {
  const GameKeyboard({super.key, required this.game});

  final Snake game;

  @override
  State<GameKeyboard> createState() => _GameKeyboardState();
}

class _GameKeyboardState extends State<GameKeyboard> {
  Icon flecheGauche = Icon(Icons.arrow_circle_left_outlined);
  Icon flecheDroite = Icon(Icons.arrow_circle_right_outlined);
  Icon flecheHaut = Icon(Icons.arrow_circle_up);
  Icon flecheBas = Icon(Icons.arrow_circle_down);

  int point = 0;
  bool _aGagner = false;
  bool _recupDataBool = false;
  int _status_code = -1;
  Map<String, dynamic> _mots = new Map();


  void score(){ // Fonction ajoutant 1 de score à chaque fois que le Joueur gagne la partie
    
  }

  Future<void> _win() async { // Widget affichant un pop-up lorsque le Joueur a gagné
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Félicitations 🎉', style: TextStyle(fontSize: 28.0),),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Gagnée !',style: TextStyle(fontSize: 25.0), textAlign: TextAlign.center,),
                Text('Vous venez de trouvez le mot !'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Quitter'),
              onPressed: () {
                Navigator.pushNamed(context, "");
              },
            ),
            TextButton(
              child: const Text('Continuer'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
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
              children: const <Widget>[
                Text('Défaite 🥴',style: TextStyle(fontSize: 25.0),),
                Text("Vous n'avez pas réussi à trouver le mot, réessayer !"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Continuer'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children:[
        GameBoard(widget.game),
        Row(
          children: [
            ElevatedButton(
              onPressed: null, 
              child: flecheGauche,
            ),
            ElevatedButton(
              onPressed: null, 
              child: flecheDroite,
            ),
            ElevatedButton(
              onPressed: null, 
              child: flecheHaut,
            ),
            ElevatedButton(
              onPressed: null, 
              child: flecheBas,
            ),
          ],
        ),
      ],
    );
  }
}