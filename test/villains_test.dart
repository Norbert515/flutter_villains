import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_villains/villains/villains.dart';


Key openRoute1 = Key('openRoute1');
Key openRoute2 = Key('openRoute2');
Key openRoute3 = Key('openRoute3');



Key un = UniqueKey();

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  '/': (BuildContext context) => new Material(
      child: Row(
        children: <Widget>[
          MaterialButton(
            onPressed: (){
              Navigator.pushNamed(context, "/1");
            },
            key: openRoute1,
          ),
          MaterialButton(
            onPressed: (){
              Navigator.pushNamed(context, "/2");
            },
            key: openRoute2,
          ),
          MaterialButton(
            onPressed: (){
              Navigator.pushNamed(context, "/3");
            },
            key: openRoute3,
          ),
        ],
      )
  ),
  '/1': (BuildContext context) => new Material(
    child: Center(
      child: Villain(
        villainAnimation: VillainAnimation.scaleAnimation(2.0, 0.1)
          ..to = Duration(seconds: 3),
        child: Container(
          width: 200.0,
          height: 200.0,
          color: Colors.red,
          key: un,
        ),
      ),
    ),
  ),
  '/2': (BuildContext context) => new Material(
    child: Container(

    ),
  ),
  '/3': (BuildContext context) => new Material(
    child: Container(

    ),
  ),

};




void main() {
  testWidgets('Villain first page test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(new MaterialApp(routes: routes, navigatorObservers: [VillainTransitionObserver()],));

    // the initial setup.
    expect(find.byKey(openRoute1), findsOneWidget);
    expect(find.byKey(openRoute2), findsOneWidget);
    expect(find.byKey(openRoute3), findsOneWidget);


  });


  testWidgets('Villain scale test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(new MaterialApp(routes: routes, navigatorObservers: [VillainTransitionObserver()],));

    await tester.tap(find.byKey(openRoute1));
    await tester.pump();

    debugDumpApp();

    print(find.byKey(un).evaluate().last.renderObject.semanticBounds.width);
 //   expect(find.byType(Container).evaluate().first.renderObject.paintBounds.width < 200 , true);



    await tester.pumpAndSettle();

    print(find.byKey(un).evaluate().last.renderObject.semanticBounds.width);


  //  print(find.byType(Container).evaluate().first.renderObject.paintBounds.width);

  //  expect(find.byType(Container).evaluate().first.renderObject.paintBounds.width , 200);
 //   expect(find.byType(Container), findsOneWidget);


  });
}
