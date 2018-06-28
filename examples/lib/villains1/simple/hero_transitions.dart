import 'package:examples/villains1/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_villains/villains/villains.dart';


class HeroTransitionPage extends StatefulWidget {
  @override
  _HeroTransitionPageState createState() => new _HeroTransitionPageState();
}

class _HeroTransitionPageState extends State<HeroTransitionPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Hero Transition"),
      ),
      floatingActionButton: new Hero(
        tag: "fab",
        child: new FloatingActionButton(
          onPressed: transition,
          child: new Icon(Icons.add),
        ),
      ),
    );
  }


  void transition() {
    Navigator.of(context).push(new BlankTransition(new HeroTransitionTargetPage()));
  }
}



class HeroTransitionTargetPage extends StatefulWidget {
  @override
  _HeroTransitionTargetPageState createState() => new _HeroTransitionTargetPageState();
}

class _HeroTransitionTargetPageState extends State<HeroTransitionTargetPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Hero Transtition Target Page"),
      ),
      body: new Center(
        child: new Hero(
          tag: "fab",
          child: new FloatingActionButton(
            onPressed: back,
            child: new Icon(Icons.add),
          ),
        ),
      ),
      bottomNavigationBar: new Villain(
        villainAnimation: VillainAnimation.fromBottomToTop,
        child: new BottomNavigationBar(
          items: [
            new BottomNavigationBarItem(
                icon: new Icon(Icons.add),
                title: new Text("add"),
            ),
            new BottomNavigationBarItem(
              icon: new Icon(Icons.offline_bolt),
              title: new Text("offline bolt"),
            ),
          ],
        ),
      ),
    );
  }


  void back() {
    Navigator.of(context).pop();
  }
}
