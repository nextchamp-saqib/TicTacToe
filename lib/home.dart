import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseUser user;

class homePage extends StatefulWidget{
  @override
  createState() => new homePageState();

}


Future<FirebaseUser> _handleSignIn() async {
  if( user == null){
    print('not signed');
    user = await _auth.signInAnonymously();
  }
  if( user != null ){
    print(user.uid.toString());
  }
  return user;
}

Future<Null> _handleSignOut() async {
  FirebaseUser currUser = await _auth.currentUser();
  print('signout');
  print(currUser.uid.toString());
  return;
  // return await _auth.signOut();
}

class homePageState extends State<homePage>{

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
                child: new Text('Multiplayer'),
                onPressed: () { 
                  _handleSignIn();
                  print("Multiplayer");
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