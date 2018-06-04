import 'package:flutter/material.dart';
import 'package:flutter_villains/villain.dart';


class BlankTransition extends PageRoute {

  final Widget child;

  BlankTransition(this.child);

  @override
  Color get barrierColor => null;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

}

class FadeRoute extends PageRoute {

  final Widget child;

  FadeRoute(this.child);

  @override
  Color get barrierColor => null;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return new FadeTransition(
        opacity: animation,
      child: child,
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

}


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
      bottomNavigationBar: new RelativeSlideVillain(
        slideDirection: SlideDirection.bottomToTop,
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
