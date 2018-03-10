import 'dart:async';
import 'package:flutter/material.dart';
import 'board_tile.dart';
import 'boardContainer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;
final reference = FirebaseDatabase.instance.reference();
FirebaseUser user;

class board extends StatefulWidget{

  String init;
  String playerId;
  String opponentId;

  board(this.init,this.playerId,this.opponentId);
  @override
  createState() => new newBoardState(init == 'create' ? 'X' : 'O', init == 'create' ? playerId: opponentId);
}

class newBoardState extends State<board> {

  final String player;
  final String playerId;
  String gameState;
  bool turn;
  boardConatiner conatiner = new boardConatiner();
  Map<String, String> board;

  newBoardState(this.player, this.playerId);

  @override
  void initState() {
    super.initState();
    board = conatiner.getBoard();
    this.gameState = 'live';
    this.turn = this.player == 'X' ? true : false;

    print('Player: ' +this.player);

    reference.child('createdGames').child('liveGames').child(playerId).child('board').set(board);
  }

  void makeMove(String pos) async {
    if(!this.turn){
      board = conatiner.makeMove(pos, this.player);
      await reference.child('createdGames').child('liveGames').child(playerId).child('board').set(board);
      // await reference.child('createdGames').child('liveGames').child(playerId).child('turn').set(value);
      print(board);
      this.turn = !this.turn;
    }else{
      print('Wait for ur turn.');
    }
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
                new boardTile('0', () => makeMove('0') ),
                new boardTile('1', () => makeMove('1') ),
                new boardTile('2', () => makeMove('2') ),
              ]
            ),
          ],
        )
      )
    );
  }
}
