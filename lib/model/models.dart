 import 'package:flutter/material.dart';

class GameModel {


  static List<List<int>> pieces = [
    [4, 5, 14, 15],
    [4, 14, 24, 25],
    [5, 15, 24, 25],
    [4, 14, 24, 34],
    [4, 14, 15, 25],
    [5, 15, 14, 24],
    [4, 5, 6, 15]
  ];

  static List<Color> pieceColor = [
    Colors.green,
    Colors.blue,
    Colors.red,
    Colors.yellow,
    Colors.purple,
    Colors.pink,
    Colors.orange
  ];

}