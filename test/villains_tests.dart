import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

Key firstKey = const Key('first');
Key secondKey = const Key('second');
Key thirdKey = const Key('third');

Key homeRouteKey = const Key('homeRoute');
Key routeTwoKey = const Key('routeTwo');
Key routeThreeKey = const Key('routeThree');

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  '/': (BuildContext context) => new Material(
      child: new ListView(
          key: homeRouteKey,
          children: <Widget>[
            new Container(height: 100.0, width: 100.0),
            new Card(child: new Hero(tag: 'a', child: new Container(height: 100.0, width: 100.0, key: firstKey))),
            new Container(height: 100.0, width: 100.0),
            new FlatButton(
                child: const Text('two'),
                onPressed: () { Navigator.pushNamed(context, '/two'); }
            ),
            new FlatButton(
                child: const Text('twoInset'),
                onPressed: () { Navigator.pushNamed(context, '/twoInset'); }
            ),
          ]
      )
  ),
  '/two': (BuildContext context) => new Material(
      child: new ListView(
          key: routeTwoKey,
          children: <Widget>[
            new FlatButton(
                child: const Text('pop'),
                onPressed: () { Navigator.pop(context); }
            ),
            new Container(height: 150.0, width: 150.0),
            new Card(child: new Hero(tag: 'a', child: new Container(height: 150.0, width: 150.0, key: secondKey))),
            new Container(height: 150.0, width: 150.0),
            new FlatButton(
              child: const Text('three'),
              onPressed: () { Navigator.push(context, new ThreeRoute()); },
            ),
          ]
      )
  ),
  // This route is the same as /two except that Hero 'a' is shifted to the right by
  // 50 pixels. When the hero's in-flight bounds between / and /twoInset are animated
  // using MaterialRectArcTween (the default) they'll follow a different path
  // then when the flight starts at /twoInset and returns to /.
  '/twoInset': (BuildContext context) => new Material(
      child: new ListView(
          key: routeTwoKey,
          children: <Widget>[
            new FlatButton(
                child: const Text('pop'),
                onPressed: () { Navigator.pop(context); }
            ),
            new Container(height: 150.0, width: 150.0),
            new Card(
              child: new Padding(
                  padding: const EdgeInsets.only(left: 50.0),
                  child: new Hero(tag: 'a', child: new Container(height: 150.0, width: 150.0, key: secondKey))
              ),
            ),
            new Container(height: 150.0, width: 150.0),
            new FlatButton(
              child: const Text('three'),
              onPressed: () { Navigator.push(context, new ThreeRoute()); },
            ),
          ]
      )
  ),

};

class ThreeRoute extends MaterialPageRoute<void> {
  ThreeRoute() : super(builder: (BuildContext context) {
    return new Material(
        key: routeThreeKey,
        child: new ListView(
            children: <Widget>[
              new Container(height: 200.0, width: 200.0),
              new Card(child: new Hero(tag: 'a', child: new Container(height: 200.0, width: 200.0, key: thirdKey))),
              new Container(height: 200.0, width: 200.0),
            ]
        )
    );
  });
}

class MutatingRoute extends MaterialPageRoute<void> {
  MutatingRoute() : super(builder: (BuildContext context) {
    return new Hero(tag: 'a', child: const Text('MutatingRoute'), key: new UniqueKey());
  });

  void markNeedsBuild() {
    setState(() {
      // Trigger a rebuild
    });
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({ Key key, this.value: '123' }) : super(key: key);
  final String value;
  @override
  MyStatefulWidgetState createState() => new MyStatefulWidgetState();
}

class MyStatefulWidgetState extends State<MyStatefulWidget> {
  @override
  Widget build(BuildContext context) => new Text(widget.value);
}



void main() {
  testWidgets('Villain basic test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(new MaterialApp(routes: routes));

    // the initial setup.

    expect(find.byKey(firstKey), isOnstage);
    expect(find.byKey(firstKey), isInCard);
    expect(find.byKey(secondKey), findsNothing);

    await tester.tap(find.text('two'));
    await tester.pump(); // begin navigation

  });
}
