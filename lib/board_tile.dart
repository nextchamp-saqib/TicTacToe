import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';


final FirebaseAuth _auth = FirebaseAuth.instance;
final reference = FirebaseDatabase.instance.reference();
FirebaseUser user;

class boardTile extends StatefulWidget{
  final String position;
  VoidCallback onClick;
  final String host;
  boardTile(this.position , this.onClick, this.host);
  @override
  createState() => new boardTileState(this.position , this.onClick, this.host);

}

class boardTileState extends State<boardTile>{

  final String position;
  VoidCallback onClick;
  final String host;
  Color color;
  String player;
  bool pressed = false;
  
  void checkPressed() async {
    user = await _auth.currentUser();
    StreamSubscription<Event> listener;

    if(host != user.uid){
      color = Colors.blueAccent;
      player = 'X';
    }else {
      color = Colors.redAccent;
      player = 'O';
    }

    DatabaseReference ref = reference.child('createdGames').child('liveGames').child(host);
    listener = ref.onValue.listen((e){
      DataSnapshot dataSnapshot = e.snapshot;
      Map value = dataSnapshot.value;
      if(value != null){
        Map<String, String> liveBoard = new Map();
        var moves = value['board'];

        for(int i=0; i<9; i++){
          liveBoard[i.toString()] = moves[i].toString();
        }
        if(liveBoard[position] != 'empty'){
          if(this.color == Colors.redAccent){
            setState((){
              this.pressed = true;
              this.color = Colors.blueAccent;
            });
          }else{
            setState((){
              this.pressed = true;
              this.color = Colors.redAccent;
            });
          }
        }else {
          // print('empty');
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkPressed();
  }

  boardTileState(this.position , this.onClick, this.host);

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.all(4.0),
      width: 88.0,
      height: 88.0,
      decoration: new BoxDecoration(
        color: pressed ? color: Colors.blueGrey,
        boxShadow: [
          new BoxShadow(color: Colors.black38, blurRadius: 3.0)
        ],
        border: new Border.all(width: 2.0, color: const Color(0xFFFFFFFF)),
        borderRadius: new BorderRadius.circular(10.0)
      ),
      child: new IconButton(
        highlightColor: Colors.blueGrey,
        icon: new Icon(Icons.check_circle, size: 0.0),
        onPressed: (){
          // this.setState((){
          //   pressed = true;
          // });
          onClick();
        }
      ),
    );
  }
}
