import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlancPixel extends StatefulWidget {
  const BlancPixel({super.key});

  @override
  State<BlancPixel> createState() => _BlancPixelState();
}

class _BlancPixelState extends State<BlancPixel> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }
}