import 'package:flutter/material.dart';
import 'package:flutter_villains/villains/villains.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => new _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List"),
      ),
      body: ListView.builder(itemBuilder: (context, index) {
        return Villain(
          villainAnimation: VillainAnimation.fromLeft(
            offset: 1.0 - index/ 40,
          ),
          animateExit: false,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Container(
                padding: EdgeInsets.all(4.0),
                color: Colors.red,
              ),
            ),
          ),
        );
      }),
    );
  }
}
