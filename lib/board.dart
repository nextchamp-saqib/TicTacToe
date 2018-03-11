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
  createState() => new newBoardState(init == 'create' ? 'X' : 'O', init == 'create' ? playerId : opponentId, init == 'create' ? opponentId : playerId);
}

class newBoardState extends State<board> {

  final String player;
  final String hostId; //create => host 
  final String joinId;
  var gameRef; //join => opponent
  String gameState;
  bool turn;
  boardConatiner conatiner = new boardConatiner();
  Map<String, String> board;

  newBoardState(this.player, this.hostId, this.joinId);

  @override
  void initState() {
    super.initState();

    board = conatiner.getBoard();
    gameRef = reference.child('createdGames').child('liveGames');

    this.gameState = 'live';

    print('Player: ' +this.player);
    gameRef.child(hostId).child('board').set(board);
    gameRef.child(hostId).child('turn').set(hostId);
  }

  void checkGameState(Map<String, String> board, String p) {
    var values = board.values;
    var winState = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6],[0,1,2]];
    var flag;
    for(int i=0; i<values.length; i++){
      flag = 'win'; //default win
      for(int j=0;j<winState[i].length;j++){
        if(values.elementAt(winState[i][j]) != p){
          flag = 'live'; //change state
        }
      }
      if(flag == 'win'){
        gameRef.child(hostId).child('winner').child('player:').set(p);
        print('win');
        setState(()=>this.gameState = 'win');
        return;
      }
    }
    if(flag == 'live'){
      for(int i=0; i<values.length; i++){
        if(values.elementAt(i) == 'empty'){
          print('live');
          setState(()=>this.gameState = 'live');
          return;
        }
      }
      print('draw');
      setState(()=>this.gameState = 'draw');
      return;
    }
  }
  void makeMove(String pos) async {
    user = await _auth.currentUser();
    StreamSubscription<Event> turnListener;
    StreamSubscription<Event> gameStateListener;

    gameStateListener = gameRef.child(hostId).child('winner').onChildAdded.listen((e){
      DataSnapshot dataSnapshot = e.snapshot;
      var value = dataSnapshot.value;
      print('winner: ' +value.toString());
      setState(()=>this.gameState = 'win');
      gameStateListener.cancel();
    });
    turnListener = gameRef.child(hostId).onValue.listen((e) async {
      DataSnapshot dataSnapshot = e.snapshot;
      Map value = dataSnapshot.value;
      Map<String, String> liveBoard = new Map();
      var moves = value['board'];

      for(int i=0; i<9; i++){
        liveBoard[i.toString()] = moves[i].toString();
      }
      if(this.gameState == 'win'){
        print('game ended');
      } else if(this.gameState == 'live'){
        if(value['turn'] == user.uid && user.uid == hostId){
          conatiner.setBoard(liveBoard);
          checkGameState(liveBoard, this.player);
          if(liveBoard[pos] == "empty"){
            board = conatiner.makeMove(pos, this.player);
            await gameRef.child(hostId).child('board').set(board);
            await gameRef.child(hostId).child('turn').set(joinId);
            await turnListener.cancel();
          }else {
            await turnListener.cancel();
            print('tile taken');
          }
        }else if(value['turn'] == user.uid && user.uid == joinId){
          conatiner.setBoard(liveBoard);
          checkGameState(liveBoard, this.player);
          if(liveBoard[pos] == "empty"){
            board = conatiner.makeMove(pos, this.player);
            await gameRef.child(hostId).child('board').set(board);
            await gameRef.child(hostId).child('turn').set(hostId);
            await turnListener.cancel();
          }else {
            await turnListener.cancel();
            print('tile taken');
          }
        }else {
          await turnListener.cancel();
          print('wait for ur turn!');
        }
      }else if(this.gameState == 'draw') {
        print('Game is Draw');
      }
    });
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
        title: new Text('Game'),
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
                new boardTile('0', () => makeMove('0'), hostId ),
                new boardTile('1', () => makeMove('1'), hostId ),
                new boardTile('2', () => makeMove('2'), hostId ),
              ]
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new boardTile('3', () => makeMove('3'), hostId ),
                new boardTile('4', () => makeMove('4'), hostId ),
                new boardTile('5', () => makeMove('5'), hostId ),
              ]
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new boardTile('6', () => makeMove('6'), hostId ),
                new boardTile('7', () => makeMove('7'), hostId ),
                new boardTile('8', () => makeMove('8'), hostId ),
              ]
            )
          ],
        )
      )
    );
  }
}
