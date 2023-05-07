import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snake/ecrans/game.dart';
import 'package:snake/ecrans/gameBoard.dart';
import 'package:snake/outils/snake.dart';

class SnakePixel extends StatefulWidget {
  const SnakePixel({super.key});

  
  @override
  State<SnakePixel> createState() => _SnakePixelState();
}

class _SnakePixelState extends State<SnakePixel> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }
}