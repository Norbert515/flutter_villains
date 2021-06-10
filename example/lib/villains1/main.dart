import 'package:flutter/material.dart';
import 'package:flutter_villains/villains/villains.dart';
import 'gallery/villain_transition.dart';
import 'list/list.dart';
import 'profile/profile.dart';

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
        'profile': (_) => new ProfilePage(),
        'profile_page_2': (_) => new ProfilePage2(),
        'list': (_) => ListPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title!),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed('grid'),
              child: new Text("Grid"),
            ),
            new ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed('profile'),
              child: new Text("profile"),
            ),
            new ElevatedButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed('profile_page_2'),
              child: new Text("profile_page_no_hero"),
            ),
            new ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed('list'),
              child: new Text("list"),
            ),
            new ElevatedButton(
              onPressed: () =>
                  Navigator.of(context).pushReplacementNamed('profile_page_2'),
              child: new Text("replace with profile_page_no_hero"),
            ),
          ],
        ),
      ),
    );
  }
}
