import 'package:flutter/material.dart';
import 'package:flutter_villains/villains2.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}


/// Easy to use even without custom RoutePages
/// Its all inside the page transition duration? Some way to customize but also have easy API
/// static const

class MyHomePage extends StatefulWidget{
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Column(
        children: <Widget>[
          new Text("from the side"),
          new Expanded(child: new SizedBox(),),
          new Villain(
            animation: Villains.slideInFromRight,
            tag: 0,
            from: Duration(seconds: 3),

            child: new Text("from below")
          )
        ],
      ),
    );
  }
}

