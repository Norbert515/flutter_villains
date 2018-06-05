import 'package:examples/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_villains/villain.dart';


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
      floatingActionButton: new FloatingActionButton(onPressed: transition, child: new Icon(Icons.forward),),
    );
  }


  void transition() {
    Navigator.of(context).push(new FadeRoute(new VillainWithHeroTarget()));
  }
}

class VillainWithHeroTarget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      bottomNavigationBar: new SlideVillain(
        slideDirection: SlideDirection.bottomToTop,
        child: new BottomNavigationBar(
            items: [
              new BottomNavigationBarItem(
                  icon: new Icon(Icons.free_breakfast),
                  title: new Text("Cofee")
              ),
              new BottomNavigationBarItem(
                  icon: new Icon(Icons.map),
                  title: new Text("Map")
              ),
            ]
        ),
      ),
      body: new Container(
        child: new Column(
          children: <Widget>[
            new SlideVillain(
                child: new Image.network(Images.imageUrls[10]),
              slideDirection: SlideDirection.topToBottom,
              relativeDistance: 0.05,
            ),
            new Text("This is a great image", style: Theme.of(context).textTheme.display1,)
          ],
        )
      ),
    );
  }
}
