import 'package:examples/colums/ColumsPage.dart';
import 'package:examples/shrine/shrine_demo.dart';
import 'package:examples/gallery/villain_transition.dart';
import 'package:examples/simple/hero_transitions.dart';
import 'package:examples/villains_without_heroes/villain_without_heroes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_villains/villain.dart';

void main() {
 // timeDilation = 2.5;
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      navigatorObservers: [new VillainTransitionObserver()],
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        'grid': (_) => new PictureGridPage(),
        'gallery': (_) => new ShrineDemo(),
        'simple': (_) => new HeroTransitionPage(),
        'columns': (_) => new ColumnsPage(),
        'no_heroes': (_) => new VillainWithoutHeroes(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new RaisedButton(
                onPressed: ()=>Navigator.of(context).pushNamed('grid'),
              child: new Text("Grid"),
            ),
            new RaisedButton(
              onPressed: ()=>Navigator.of(context).pushNamed('gallery'),
              child: new Text("gallery"),
            ),
            new RaisedButton(
              onPressed: ()=>Navigator.of(context).pushNamed('simple'),
              child: new Text("simple"),
            ),
            new RaisedButton(
              onPressed: ()=>Navigator.of(context).pushNamed('columns'),
              child: new Text("columns"),
            ),
            new RaisedButton(
              onPressed: ()=>Navigator.of(context).pushNamed('no_heroes'),
              child: new Text("no_heroes"),
            ),
          ],
        ),
      ),
    );
  }




}
