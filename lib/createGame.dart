import 'package:flutter/material.dart';

class createGame extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

  //   return new Scaffold(
  //     appBar: new AppBar(
  //       leading: new IconButton(
  //         icon: new Icon(Icons.menu),
  //         tooltip: 'Navigation Menu',
  //         onPressed: null,
  //       ),
  //       title: new Text('Board'),
  //     ),

  //     body: new Container(
  //       color: Colors.black87,
  //       alignment: Alignment.center,
  //       child: new Text('Waiting for someone to join.'),
  //     ),
  //   );

    return new SimpleDialog(
      title: new Text('Diaglog'),
      children: <Widget>[
        new SimpleDialogOption(
          onPressed: null,
          child: const Text('data'),
        ),
        new SimpleDialogOption(
          onPressed: null,
          child: const Text('data'),
        )
      ],

    );
  }
}