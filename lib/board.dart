import 'package:flutter/material.dart';
import 'board_tile.dart';

class board extends StatefulWidget{
  @override
  createState() => new newBoardState();
}

class newBoardState extends State<board> {

  
  
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
                new boardTile(),
                new boardTile(),
                new boardTile()
              ]
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new boardTile(),
                new boardTile(),
                new boardTile()
              ]
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new boardTile(),
                new boardTile(),
                new boardTile()
              ]
            )
          ],
        )
      )
    );
  }
} 