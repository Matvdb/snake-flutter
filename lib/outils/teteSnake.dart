import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class HeadSnake extends StatefulWidget {
  const HeadSnake({Key? key}) : super(key: key);

  @override
  State<HeadSnake> createState() => _HeadSnakeState();
}

class _HeadSnakeState extends State<HeadSnake> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/teteSerpent.png"),
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }
}