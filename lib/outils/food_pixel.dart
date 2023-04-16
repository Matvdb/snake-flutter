import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FoodPixel extends StatefulWidget {
  const FoodPixel({super.key});

  @override
  State<FoodPixel> createState() => _FoodPixelState();
}

class _FoodPixelState extends State<FoodPixel> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/pomme.png"),
          ),
          color: Colors.green,
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }
}