import 'package:flutter/material.dart';

class boardTile extends StatefulWidget{
  @override
  createState() => new BoardTileState();
}

class BoardTileState extends State<boardTile>{
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.all(4.0),
      width: 88.0,
      height: 88.0,
      decoration: new BoxDecoration(
        color: Colors.blueAccent,
        boxShadow: [
          new BoxShadow(color: Colors.black38, blurRadius: 3.0)
        ],
        border: new Border.all(width: 2.0, color: const Color(0xFFFFFFFF)),
        borderRadius: new BorderRadius.circular(10.0)
      ),
    );
  }

}