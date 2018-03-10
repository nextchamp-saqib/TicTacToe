import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'createGame.dart';
import 'package:firebase_database/firebase_database.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final reference = FirebaseDatabase.instance.reference();
FirebaseUser user;

class homePage extends StatefulWidget{
  @override
  createState() => new homePageState();
}


Future<FirebaseUser> _handleSignIn() async {
  if( user == null){
    print('not signed');
    user = await _auth.signInAnonymously();
    reference.child('onlineUsers').child(user.uid).set('true');
  }else if( user != null ){
    print(user.uid.toString());
  }
  return user;
}

Future<Null> _handleSignOut() async {
  FirebaseUser currUser = await _auth.currentUser();
  print('signout');
  reference.child('onlineUsers').child(currUser.uid).set('false');
  return;
  // return await _auth.signOut();
}

class homePageState extends State<homePage>{


  @override
  void initState() {
    super.initState();
    _handleSignIn();
  }

  void _createGame() async{
    FirebaseUser user = await _auth.currentUser();    
    reference.child('createdGames').child('Waiting').child(user.uid).set('true');
    // reference.child('createdGames').child('InGame').onChildAdded.listen(onData)
  }
  void _joinGame() async{
    FirebaseUser user = await _auth.currentUser();
    reference.onValue.listen((e) {
      DataSnapshot dataSnapshot = e.snapshot;
      Map data = dataSnapshot.value['createdGames']['Waiting'];
      if(data.keys.length < 1){
        print('No game found');
      }else {
        //start game
      }
    });
  }
  @override
  Widget build(BuildContext context) {

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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              margin: new EdgeInsets.all(5.0),
              alignment: Alignment.center,
              child: new RaisedButton(
                padding: new EdgeInsets.fromLTRB(35.0, 15.0, 35.0, 15.0),
                disabledTextColor: Colors.black,
                color: Colors.lightBlueAccent,
                child: new Text('Create Game'),
                onPressed: () { 
                  _createGame();
                  print("Created");
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      child: new AlertDialog(
                        title: const Text("Searching for joiners."),
                        content: const Text('Please wait...'),
                        actions: [
                          new FlatButton(
                            child: const Text("Cancel"),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                  );
                  // Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new createGame()));
                 },
              )
            ),
            new Container(
              margin: new EdgeInsets.all(5.0),
              alignment: Alignment.center,
              child: new RaisedButton(
                padding: new EdgeInsets.fromLTRB(35.0, 15.0, 35.0, 15.0),
                disabledTextColor: Colors.black,
                color: Colors.lightBlueAccent,
                child: new Text('Join Game'),
                onPressed: () { 
                  print("Joining");
                  _joinGame();
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      child: new AlertDialog(
                        title: const Text("Searching for players."),
                        content: const Text('Please wait...'),
                        actions: [
                          new FlatButton(
                            child: const Text("Cancel"),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                  );
                 },
              )
            ),
            new Container(
              margin: new EdgeInsets.all(5.0),
              alignment: Alignment.center,
              child: new RaisedButton(
                padding: new EdgeInsets.fromLTRB(35.0, 15.0, 35.0, 15.0),
                disabledTextColor: Colors.black,
                color: Colors.lightBlueAccent,
                child: new Text('Exit'),
                onPressed: () { 
                  _handleSignOut().whenComplete((){
                    print('set');
                    this.setState((){
                      user = null;
                    });
                  });
                  print("Exit");
                },
              )
            ),
          ],
        ),
      )
    );
  }
}