
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GameGrid extends StatefulWidget {
  List<List<int>> landedPieces = [];
  List<int> newPieces = [];
  Color newColor;
  bool isGameOver;

  GameGrid({this.landedPieces,this.newPieces,this.newColor,this.isGameOver = false});

  @override
  _GameGridState createState() => _GameGridState();
}

class _GameGridState extends State<GameGrid> {


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GridView.builder(
            itemCount: 140,
            gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 10),
            itemBuilder: (BuildContext context, int index) {
              Color myColor;

              print("landedPiece length " + widget.landedPieces.length.toString());

              List<int> allTheList = [];
              widget.newPieces.forEach((element) {
                allTheList.add(element);
              });

              widget.landedPieces.forEach((element) {
                element.forEach((innerElement) {
                  allTheList.add(innerElement);
                });
              });

              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: allTheList.contains(index)
                                ? Colors.red
                                : Colors.black
                          // color: Colors.red
                        ),
                      ),
                      // Text(
                      //   index.toString(),
                      //   style: TextStyle(color: Colors.white),
                      // )
                    ],
                  ),
                ),
              );
            }),
        widget.isGameOver ? Center(child: Text("GAME OVER", style: TextStyle(color: Colors.white, fontSize: 32,backgroundColor: Colors.black87),)) : SizedBox.shrink(),
      ],
    );
  }


}
