import 'package:flutter/material.dart';

class GameBottomButtons extends StatefulWidget {
  @override
  _GameBottomButtonsState createState() => _GameBottomButtonsState();
}

class _GameBottomButtonsState extends State<GameBottomButtons> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      color: Colors.black,
      child: Row(
        children: <Widget>[
          FlatButton(
            onPressed: (){},
            child: Text(
              "Start Game",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FlatButton(
                    onPressed: (){},
                    child:
                        Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                  FlatButton(
                    onPressed: (){},
                    child: Icon(Icons.arrow_forward_ios,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          FlatButton(
            onPressed: (){},
            child: Icon(Icons.rotate_right, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
