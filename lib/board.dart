import 'package:flutter/material.dart';
import 'board_tile.dart';
import 'boardContainer.dart';

class board extends StatefulWidget{

  String init;

  board(this.init);
  @override
  createState() => new newBoardState(init == 'create' ? 'X' : 'O');
}

class newBoardState extends State<board> {

  String player;
  newBoardState(this.player);

  Map<String, String> board = new Map();
  boardConatiner conatiner = new boardConatiner();

  void makeMove(String pos, String player) {
    conatiner.makeMove(pos, player);
    board = conatiner.getBoard();
  }
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.menu),
          tooltip: 'Navigation Menu',
          onPressed: null,
        ),
        title: new Text('Board'),
      ),

      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Expanded(
                  child: new Container(
                    alignment: Alignment.center,
                    child: new Text('TIC-TAC-TOE', style: Theme.of(context).textTheme.title)
                  ),
              )],
            ),
            new Padding(
              padding: new EdgeInsets.all(8.0),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new boardTile('0', () => makeMove('0', 'X') ),
                new boardTile('1', () => makeMove('1', 'X') ),
                new boardTile('2', () => makeMove('2', 'X') ),
              ]
            ),
          ],
        )
      )
    );
  }
}
