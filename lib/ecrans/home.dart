import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snake/ecrans/gameBoard.dart';
import 'package:snake/outils/snake.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  String login = "";
  String password = "";

  Future<http.Response> createAccount(
      String login, String password) {
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
        "password": password,
      }),
    );
  }

  void checkAccount() async {
    var connexion = await createAccount(login, password);
    log(connexion.statusCode.toString());
    if (connexion.statusCode == 201) {
      Navigator.pushReplacementNamed(context, '/snake');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Compte crée'),
      ));
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

  
  Future<void> _popUpStart() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sélection de partie'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
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
                ),),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(labelText:"Mot de passe"),
                      validator: (mdp) {
                        if (mdp == null || mdp.isEmpty) {
                          return 'Please enter some text';
                        } else {
                        password = mdp.toString();
                        }
                      },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (_formKey.currentState!.validate()) {
                        checkAccount();
                      }
                    });
                  }, 
                  child: const Text("Commencer la partie"),
                )
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
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _popUpStart,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}