import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_tetris_shung/screens/game_bottom_buttons.dart';
import 'package:flutter_tetris_shung/screens/game_grid.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<int> newPieces = [];
  List<List<int>> landedPieces = [];
  Color newColor;

  // List<Color> pieceColor;
  List<int> piecesShowOnScreen = [];
  int piecesInt = 0;

  List<List<int>> pieces = [
    [4, 5, 14, 15],
    [4, 14, 24, 25],
    [5, 15, 24, 25],
    [4, 14, 24, 34],
    [4, 14, 15, 25],
    [5, 15, 14, 24],
    [4, 5, 6, 15]
  ];

  List<Color> pieceColor = [
    Colors.green,
    Colors.blue,
    Colors.red,
    Colors.yellow,
    Colors.purple,
    Colors.pink,
    Colors.orange
  ];

  bool isGameOver;
  bool isGameStarted;

  @override
  void initState() {
    super.initState();
    initAll();
  }

  initAll() {
    newPieces = [];
    landedPieces = [];
    newColor;

    // List<Color> pieceColor;
    piecesShowOnScreen = [];
    piecesInt = 0;

    pieces = [
      //Square
      //X-X
      //X-X
      [4, 5, 14, 15],
      //|_
      //X
      //X
      //X-X
      [4, 14, 24, 25],
      //_|
      //  X
      //  X
      //X-X
      [5, 15, 24, 25],
      //|
      //X
      //X
      //X
      //X
      [4, 14, 24, 34],
      //S
      //  X-X
      //X-X
      [4, 14, 15, 25],
      //Z
      //X-X
      //  X-X
      [5, 15, 14, 24],
      //T
      //X-X-X
      //  X
      [4, 5, 6, 15]
    ];

    pieceColor = [
      Colors.green,
      Colors.blue,
      Colors.red,
      Colors.yellow,
      Colors.purple,
      Colors.pink,
      Colors.orange
    ];

    isGameOver = false;
    isGameStarted = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
                color: Colors.black,
                child: GameGrid(
                  landedPieces: landedPieces,
                  newPieces: newPieces,
                  isGameOver: isGameOver,
                )),
          ),
          Container(
            height: 80,
            color: Colors.black,
            child: Row(
              children: <Widget>[
                FlatButton(
                  child: Text(
                    !isGameOver ? "Start" : "Restart",
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                  onPressed: startGame,
                ),
                Expanded(
                  child: Container(
                    color: Colors.blue,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 1,
                          child: FlatButton(
                            onPressed: moveLeft,
                            child:
                                Icon(Icons.arrow_back_ios, color: Colors.white),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: FlatButton(
                            onPressed: moveRight,
                            child: Icon(Icons.arrow_forward_ios,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: rotatePieces,
                  child: Icon(Icons.rotate_right, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void addToLandedPiece(List<int> pieceJustLanded) {
    landedPieces.add(pieceJustLanded);
  }

  void startGame() {

    if(!isGameStarted){
      isGameStarted = true;
    } else {
      return;
    }

      if (!isGameOver) {
        createNewPiece();
        moveDown();
      } else {
        initAll();
        isGameOver = false;
        startGame();
      }


  }

  void createNewPiece() {
    piecesInt = Random().nextInt(6);
    // piecesInt = 1;
    newPieces = [];
    pieces[piecesInt].forEach((element) {
      newPieces.add(element);
    });
    newColor = pieceColor[piecesInt];
  }

  void randomPiece() {}

  Timer gameTimer;

  void moveDown() {
    Timer.periodic(Duration(milliseconds: 400), (timer) {
      gameTimer = timer;
      setState(() {
        gameTimer.cancel();

        checkAndClearRow();

        if (isHitFloor()) {
          addToLandedPiece(newPieces);

          createNewPiece();

          if (!checkIsGameOver()) {
            moveDown();
          } else {
            gameTimer.cancel();
            isGameOver = true;
            isGameStarted = false;
          }
        } else {
          newPieces.forEach((element) {
            int index = newPieces.indexOf(element);
            newPieces[index] += 10;
          });

          print("the actual first is " + newPieces[0].toString());
          moveDown();
        }
      });
    });
  }

  bool isHitFloor() {
    bool isHit = false;
    //If newPieces is already at the ground, end the cycle of checking
    if (newPieces.any((element) => element > 129)) {
      return true;
    }

    //Otherwise, check if there is a Landed block ahead
    newPieces.forEach((np) {
      int index = newPieces.indexOf(np);
      landedPieces.forEach((lp) {
        lp.forEach((lpInner) {
          if (lpInner == newPieces[index] + 10) {
            isHit = true;
          }
        });
      });
    });

    return isHit;
  }

  moveRight() {
    setState(() {
      if (newPieces.any((element) => (element + 1) % 10 == 0)) {
      } else {
        if (!checkIfGotPiecesOnTheRight()) {
          newPieces.forEach((element) {
            int index = newPieces.indexOf(element);
            newPieces[index] += 1;
          });
        }
      }
    });
  }

  moveLeft() {
    setState(() {
      if (newPieces.any((element) => (element + 1) % 10 == 1)) {
      } else {
        if (!checkIfGotPiecesOnTheLeft()) {
          newPieces.forEach((element) {
            int index = newPieces.indexOf(element);
            newPieces[index] -= 1;
          });
        }
      }
    });
  }

  bool checkIsGameOver() {
    List<int> listToCheck = [];
    landedPieces.forEach((lp) {
      lp.forEach((innerLP) {
        listToCheck.add(innerLP);
      });
    });

    if (newPieces.any((item) => listToCheck.contains(item))) {
      // Lists have at least one common element
      return true;
    } else {
      // Lists DON'T have any common element
      return false;
    }
  }

  bool checkIfGotPiecesOnTheRight() {
    List<int> listToCheck = [];
    landedPieces.forEach((lp) {
      lp.forEach((innerLP) {
        listToCheck.add(innerLP);
      });
    });

    if (newPieces.any((item) => listToCheck.contains(item + 1))) {
      // Lists have at least one common element
      return true;
    } else {
      // Lists DON'T have any common element
      return false;
    }
  }

  bool checkIfGotPiecesOnTheLeft() {
    List<int> listToCheck = [];
    landedPieces.forEach((lp) {
      lp.forEach((innerLP) {
        listToCheck.add(innerLP);
      });
    });

    if (newPieces.any((item) => listToCheck.contains(item - 1))) {
      // Lists have at least one common element
      return true;
    } else {
      // Lists DON'T have any common element
      return false;
    }
  }

  List<int> futureRotatedPieces = [];
  List<int> allOfTheX = [];
  List<int> allOfTheY = [];
  List<int> matrixPointTransformed = [];

  bool isRotatedButtonDisable = false;

  rotatePieces() {
    setState(() {
      isRotatedButtonDisable = true;
    });
    performRotationMatrix();

    if (!checkIfLeftAndRightSideExceedBoundaries(allOfTheX)) {
      if (!checkIfGotPiecesOnTheLeft() && !checkIfGotPiecesOnTheRight()) {
        newPieces.asMap().forEach((index, value) {
          String xyString = (allOfTheY[index].abs() != 0
                  ? allOfTheY[index].abs().toString()
                  : "") +
              allOfTheX[index].abs().toString();
          futureRotatedPieces.add(int.parse(xyString));
        });

        setState(() {
          newPieces = futureRotatedPieces;
          clearRotationParams();
        });
      } else if (checkIfGotPiecesOnTheLeft() && !checkIfGotPiecesOnTheRight()) {
        setState(() {
          shiftPiecesToTheRight();
          clearRotationParams();
          rotatePieces();
        });
      } else if (!checkIfGotPiecesOnTheLeft() && checkIfGotPiecesOnTheRight()) {
        setState(() {
          shiftPiecesToTheLeft();
          clearRotationParams();
          rotatePieces();
        });
      }
    } else {
      if (checkIfIsLessThanZero(allOfTheX)) {
        shiftPiecesToTheRight();
        clearRotationParams();
        rotatePieces();
      } else if (checkIfIsMoreThanNine(allOfTheX)) {
        shiftPiecesToTheLeft();
        clearRotationParams();
        rotatePieces();
      }
    }

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        isRotatedButtonDisable = false;
      });
    });
  }

  clearRotationParams() {
    //Clear State
    futureRotatedPieces = [];
    allOfTheX = [];
    allOfTheY = [];
    matrixPointTransformed = [];
  }

  bool checkIfLeftAndRightSideExceedBoundaries(List<int> allOfTheX) {
    bool hasExceedBoundaries = false;
    allOfTheX.asMap().forEach((index, futurePieces) {
      print("x is " + futurePieces.toString());
      setState(() {
        if (checkIfIsLessThanZero(allOfTheX) ||
            checkIfIsMoreThanNine(allOfTheX)) {
          hasExceedBoundaries = true;
        }
      });
    });

    return hasExceedBoundaries;
  }

  bool checkIfIsLessThanZero(List<int> allOfTheX) {
    bool hasExceedBoundaries = false;
    allOfTheX.asMap().forEach((index, futurePieces) {
      print("x is " + futurePieces.toString());
      setState(() {
        if (futurePieces < 0) {
          hasExceedBoundaries = true;
        }
      });
    });

    return hasExceedBoundaries;
  }

  bool checkIfIsMoreThanNine(List<int> allOfTheX) {
    bool hasExceedBoundaries = false;
    allOfTheX.asMap().forEach((index, futurePieces) {
      print("x is " + futurePieces.toString());
      setState(() {
        if (futurePieces > 9) {
          hasExceedBoundaries = true;
        }
      });
    });

    return hasExceedBoundaries;
  }

  performRotationMatrix() {
    setState(() {
      newPieces.asMap().forEach((index, element) {
        if (index != 1) {
          int y;
          int x;
          y = -(element ~/ 10).toInt();
          x = (element % 10).toInt();

          int midY;
          int midX;

          midY = -newPieces[1] ~/ 10;
          midX = newPieces[1] % 10;

          print("midY $midY midX $midX");

          List<int> matrixPoint = [];
          matrixPoint.add(x - midX);
          matrixPoint.add(y - midY);

          matrixPointTransformed = [];
          matrixPointTransformed.add(matrixPoint[1]);
          matrixPointTransformed.add(matrixPoint[0] * -1);

          matrixPointTransformed[0] = matrixPointTransformed[0] + midX;
          matrixPointTransformed[1] = matrixPointTransformed[1] + midY;

          allOfTheX.add(matrixPointTransformed[0]);
          allOfTheY.add(matrixPointTransformed[1]);

          // }
        } else {
          int midY = -newPieces[1] ~/ 10;
          int midX = newPieces[1] % 10;
          allOfTheX.add(midX);
          allOfTheY.add(midY);
          // futureRotatedPieces.add(newPieces[index]);
        }
      });
    });
  }

  shiftPiecesToTheRight() {
    setState(() {
      newPieces.asMap().forEach((index, value) {
        newPieces[index] = newPieces[index] + 1;
        print("the real new pieces is" + newPieces[index].toString());
      });
    });
  }

  shiftPiecesToTheLeft() {
    setState(() {
      newPieces.asMap().forEach((index, value) {
        newPieces[index] = newPieces[index] - 1;
      });
    });
  }

  //In Progress
  // bool checkIfLeftSideGotPieces(List<int> currentPiece) {
  //   bool isLeftSideGotPiece = false;
  //   //Check most far left of the landedPiece vs the most far left of the current piece
  //   List<int> existingLandedX = [];
  //   List<int> existingLandedY = [];
  //   landedPieces.asMap().forEach((index, element) {
  //     element.asMap().forEach((key, value) {
  //       int y = -landedPieces[index][key] ~/ 10;
  //       int x = landedPieces[index][key] % 10;
  //
  //       existingLandedX.add(x);
  //       existingLandedY.add(y);
  //     });
  //   });
  //
  //   List<int> currentPieceX = [];
  //   List<int> currentPieceY = [];
  //
  //   currentPiece.asMap().forEach((index, element) {
  //     int y = -currentPiece[index] ~/ 10;
  //     int x = currentPiece[index] % 10;
  //
  //     currentPieceX.add(x);
  //     currentPieceY.add(y);
  //   });
  //
  //   if (existingLandedX.contains(currentPieceX.reduce((min)))) {
  //     currentPieceX.asMap().forEach((index, value) {
  //       if (existingLandedY.contains(currentPieceY[index])) {
  //         return true;
  //       }
  //     });
  //   }
  //
  //   return isLeftSideGotPiece;
  // }
  // checkIfRightSideGotPieces() {}

  List<int> listOfRows = [];
  List<int> fistLine = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
  List<int> secondLine = [10, 11, 12, 13, 14, 15, 16, 17, 18, 19];
  List<int> thirdLine = [20, 21, 22, 23, 24, 25, 26, 27, 28, 29];
  List<int> forthLine = [30, 31, 32, 33, 34, 35, 36, 37, 38, 39];
  List<int> fifthLine = [40, 41, 42, 43, 44, 45, 46, 47, 48, 49];
  List<int> sixthLine = [50, 51, 52, 53, 54, 55, 56, 57, 58, 59];
  List<int> seventhLine = [60, 61, 62, 63, 64, 65, 66, 67, 68, 69];
  List<int> eighthLine = [70, 71, 72, 73, 74, 75, 76, 77, 78, 79];
  List<int> ninthLine = [80, 81, 82, 83, 84, 85, 86, 87, 88, 89];
  List<int> tenthLine = [90, 91, 92, 93, 94, 95, 96, 97, 98, 99];
  List<int> eleventhLine = [100, 101, 102, 103, 104, 105, 106, 107, 108, 109];
  List<int> twelvethLine = [110, 111, 112, 113, 114, 115, 116, 117, 118, 119];
  List<int> thirteenthLine = [120, 121, 122, 123, 124, 125, 126, 127, 128, 129];
  List<int> fortheenthLine = [130, 131, 132, 133, 134, 135, 136, 137, 138, 139];

  List<int> removeRow = [];

  checkAndClearRow() {
    // setState(() {


    for (int i = 0; i < 14; i++) {
      int pointer;
      for (int j = 0; j < 10; j++) {
        pointer = int.parse(i.toString() + j.toString());
        print("pointer is " + pointer.toString());

        landedPieces.asMap().forEach((lpIndex, lp) {
          lp.asMap().forEach((innerLPIndex, innerLP) {
            if (pointer == landedPieces[lpIndex][innerLPIndex]) {
              removeRow.add(innerLP);
            }
          });
        });

        if (removeRow.length == 10) {
          removeRow.asMap().forEach((rrIndex, rr) {
            print("remove row " + rr.toString());


            landedPieces.asMap().forEach((lpIndex, lp) {
              listOfRows = [];
              lp.asMap().forEach((innerLPIndex, innerLP) {
                //if removeRow is innerLP, clear away
                if(!removeRow.contains(landedPieces[lpIndex][innerLPIndex])){
                  listOfRows.add(innerLP);
                }
              });

              landedPieces[lpIndex] = listOfRows;

            });


          });

//here like works
          goDownOneRow();

        }



      }


      removeRow.clear();

    }




  }

  goDownOneRow(){
    setState(() {
      landedPieces.asMap().forEach((lpIndex, lp) {
        lp.asMap().forEach((innerLPIndex, innerLP) {
          if(innerLP < 130){
            if(!landedPieces[lpIndex].contains(innerLP+10)){
              landedPieces[lpIndex][innerLPIndex] = landedPieces[lpIndex][innerLPIndex] + 10;
            }
          }

        });
      });
    });

  }
}
