import 'package:flutter/material.dart';


class VillainWithoutHeroes extends StatefulWidget {
  @override
  _VillainWithoutHeroesState createState() => new _VillainWithoutHeroesState();
}

class _VillainWithoutHeroesState extends State<VillainWithoutHeroes> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("No heroes"),
      ),
    );
  }
}
