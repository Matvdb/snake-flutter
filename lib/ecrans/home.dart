import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snake/ecrans/gameBoard.dart';
import 'package:snake/outils/snake.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:intl/intl.dart';
import 'package:snake/outils/snake_pixel.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  String login = "";

  Future<http.Response> createAccount(
      String login) {
    return http.post(
      Uri.parse(
          'https://s3-4427.nuage-peda.fr/snake/public/api/users'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: convert.jsonEncode(<String, dynamic>{
        "username": login,
        "roles": ["ROLE_ADMIN"],
      }),
    );
  }

  void checkAccount() async {
    var connexion = await createAccount(login);
    log(connexion.statusCode.toString());
    if (connexion.statusCode == 201) {
      print("Login enregistré");
    } else if (connexion.statusCode == 422) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Login déjà utilisé'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Connexion au serveur impossible'),
      ));
    }
  }

  Future<http.Response> envoiLevel(String level) {
    return http.post(
      Uri.parse(
          'https://s3-4427.nuage-peda.fr/snake/public/api/niveaux'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: convert.jsonEncode(<String, dynamic>{
        "niveaux": valeurLvl.toString(),
      }),
    );
  }

  void checkDonnee() async {
    var connexion = await envoiLevel(valeurLvl.toString());
    log(connexion.statusCode.toString());
    if (connexion.statusCode == 201) {
      print("Lvl envoyé");
    } else if (connexion.statusCode == 422) {
      print("");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Connexion au serveur impossible'),
      ));
    }
    print(valeurLvl.toString());
  }

  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Facile"),value: "facile"),
      DropdownMenuItem(child: Text("Intermédiaire"),value: "intermédiaire"),
      DropdownMenuItem(child: Text("Difficile"),value: "difficile"),
      DropdownMenuItem(child: Text("Extrême"),value: "extrême"),
    ];
    return menuItems;
  }
  String? valeurLvl;

  String? selectedValue = null;
  final _dropdownFormKey = GlobalKey<FormState>();

  Future<void> _popUpStart() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sélection de partie'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
               Form(
                key: _dropdownFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButtonFormField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          filled: true,
                          fillColor: Colors.blueAccent,
                        ),
                        validator: (value) => value == null ? "Choisissez un niveau" : null,
                        dropdownColor: Colors.blueAccent,
                        value: selectedValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValue = newValue!;
                            valeurLvl = newValue;
                          });
                        },
                        items: dropdownItems
                        ),
                    ],
                  ),
                ),
                Form(
                  key: _formKey,
                  child:
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                        decoration: const InputDecoration(labelText:"Nom d'utilisateur"),
                        validator: (username) {
                          if (username == null || username.isEmpty) {
                            return 'Please enter some text';
                          } else {
                          login = username.toString();
                          }
                        },
                    ),
                  ),
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
              child: const Text("Commencer sans s'identifier"),
              onPressed: () {
                Navigator.pushNamed(context, '/snake');
              },
            ),
            TextButton(
              child: const Text('Commencer'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  if (_formKey.currentState!.validate()) {
                    checkAccount();
                  }
                  if (_dropdownFormKey.currentState!.validate()) {
                    checkDonnee();
                    if(valeurLvl == "facile"){
                      Navigator.pushNamed(context, '/snake');
                    } else if (valeurLvl == "intermédiaire"){
                      Navigator.pushNamed(context, '/snakeInter');
                    } else if (valeurLvl == "difficile"){
                      Navigator.pushNamed(context, '/snakeDiff');
                    } else if (valeurLvl == "extrême"){
                      Navigator.pushNamed(context, '/snakeExtre');
                    }
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Snake"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
          child : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Colors.blueAccent.shade100,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Padding(padding: EdgeInsets.all(5)),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: const Image(
                      image: AssetImage("assets/images/logo.png"),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2,),
                  Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor,
                          Colors.blueAccent.shade100,
                        ],
                        begin: Alignment.bottomRight,
                        end: Alignment.topLeft,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text("Bienvenue sur Snake", 
                      style: const TextStyle(
                        fontFamily: "Bubblegum",
                        fontSize: 25.0,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2,),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Padding(padding: EdgeInsets.all(20)),
                        Text("Regle", 
                          style: TextStyle(
                            fontFamily: "Bubblegum",
                            fontSize: 25.0,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(20)),
                        Text("La règle du jeu est simple, ne vous manger pas la queue ...\nVous incorporez un serpent affiché par 3 cubes blancs. Votre objectif ? Manger le plus de pommes possible sans foncer dans le corps de votre serpent.",
                        style: TextStyle(
                          fontSize: 15.0,
                        ),),
                        Padding(padding: EdgeInsets.all(8)),
                        Text("Pour y parvenir, vous pourrez vous servir des quatres coins de la zone, vous permettant de naviguer entre les 4 divers endroits de celle-ci.",
                        style: TextStyle(
                          fontSize: 15.0,
                        ),),
                        Padding(padding: EdgeInsets.all(8)),
                        Text("Réussirez-vous à rester numéro 1 ? Seuls vos performances nous le diront ... 😈",
                        style: TextStyle(
                          fontSize: 15.0,
                        ),),
                        Padding(padding: EdgeInsets.all(15)),
                        Text("Bon courage à vous, joueur !",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _popUpStart,
        tooltip: 'Jouer',
        icon: const Icon(Icons.play_arrow),
        label: const Text("Commencez votre partie"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}