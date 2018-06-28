import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_villains/villains/villains.dart';

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

class TestWidget extends StatelessWidget {
  final Widget pageToOpen;

  final Key buttonKey;

  const TestWidget({Key key, this.pageToOpen, this.buttonKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [VillainTransitionObserver()],
      home: Material(
        child: Center(child: LayoutBuilder(
          builder: (BuildContext navigatorContext, BoxConstraints constraints) {
            return MaterialButton(
              onPressed: () {
                Navigator.push(navigatorContext, BlankTransition(pageToOpen));
              },
              key: buttonKey,
            );
          },
        )),
      ),
    );
  }
}


class TestWidgetWithDisabledTickerMode extends StatelessWidget {
  final Widget pageToOpen;

  final Key buttonKey;

  const TestWidgetWithDisabledTickerMode({Key key, this.pageToOpen, this.buttonKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TickerMode(
      enabled: false,
      child: MaterialApp(
        navigatorObservers: [VillainTransitionObserver()],
        home: Material(
          child: Center(child: LayoutBuilder(
            builder: (BuildContext navigatorContext, BoxConstraints constraints) {
              return MaterialButton(
                onPressed: () {
                  Navigator.push(navigatorContext, BlankTransition(pageToOpen));
                },
                key: buttonKey,
              );
            },
          )),
        ),
      ),
    );
  }
}

void main() {
  testWidgets('Villain fromBottomToTop', (WidgetTester tester) async {
    Key container = Key('container');

    Widget page = Material(
      child: Align(
        alignment: Alignment.topCenter,
        child: Villain(
          villainAnimation: VillainAnimation.fromBottomToTopOld..to = Duration(milliseconds: 750),
          child: Container(
            width: 200.0,
            height: 200.0,
            color: Colors.red,
            key: container,
          ),
        ),
      ),
    );

    Key openKey = Key('open');

    await tester.pumpWidget(TestWidget(
      pageToOpen: page,
      buttonKey: openKey,
    ));

    await tester.tap(find.byKey(openKey));
    await tester.pump();
    await tester.pump();

    expect(find.byKey(container), findsOneWidget);

    final double initialY = tester.getTopLeft(find.byKey(container)).dy;

    expect(initialY, 200.0);

    await tester.pump(Duration(milliseconds: 250));

    final double yAt250 = tester.getTopLeft(find.byKey(container)).dy;

    expect(yAt250, greaterThan(125.0));
    expect(yAt250, lessThan(150.0));

    await tester.pumpAndSettle();

    final double yAtEnd = tester.getTopLeft(find.byKey(container)).dy;

    expect(yAtEnd, 0.0);
  });

  testWidgets('Villain translateAnimation test', (WidgetTester tester) async {
    Key container = Key('container');

    Widget page = Material(
      child: Align(
        alignment: Alignment.topCenter,
        child: Villain(
          villainAnimation: VillainAnimation.translateAnimation(Offset(0.0, 1.0), Offset(0.0, 0.0))..to = Duration(milliseconds: 750),
          child: Container(
            width: 200.0,
            height: 200.0,
            color: Colors.red,
            key: container,
          ),
        ),
      ),
    );

    Key openKey = Key('open');

    await tester.pumpWidget(TestWidget(
      pageToOpen: page,
      buttonKey: openKey,
    ));

    await tester.tap(find.byKey(openKey));
    await tester.pump();
    await tester.pump();

    expect(find.byKey(container), findsOneWidget);

    final double initialY = tester.getTopLeft(find.byKey(container)).dy;
    expect(initialY, 200.0);

    await tester.pump(const Duration(milliseconds: 250));

    final double yAt100ms = tester.getTopLeft(find.byKey(container)).dy;

    // The animation is 750ms long and goes from 200 - 0, meaning it should be 250.0
    expect(yAt100ms, greaterThan(125.0));
    expect(yAt100ms, lessThan(150.0));

    await tester.pumpAndSettle();

    final double yAtEnd = tester.getTopLeft(find.byKey(container)).dy;

    expect(yAtEnd, 0.0);
  });

  testWidgets('Villain animation starting later', (WidgetTester tester) async {
    Key container = Key('container');

    Widget page = Material(
      child: Align(
        alignment: Alignment.topCenter,
        child: Villain(
          villainAnimation: VillainAnimation.fromBottomToTopOld
            ..from = Duration(seconds: 1)
            ..to = Duration(seconds: 2),
          child: Container(
            width: 200.0,
            height: 200.0,
            color: Colors.red,
            key: container,
          ),
        ),
      ),
    );

    Key openKey = Key('open');

    await tester.pumpWidget(TestWidget(
      pageToOpen: page,
      buttonKey: openKey,
    ));

    await tester.tap(find.byKey(openKey));
    await tester.pump();
    await tester.pump();

    expect(find.byKey(container), findsOneWidget);

    final double initialY = tester.getTopLeft(find.byKey(container)).dy;

    expect(initialY, 200.0);

    await tester.pump(Duration(milliseconds: 999));

    final double beforeAnimation = tester.getTopLeft(find.byKey(container)).dy;

    expect(beforeAnimation, 200.0);

    await tester.pumpAndSettle();

    final double yAtEnd = tester.getTopLeft(find.byKey(container)).dy;

    expect(yAtEnd, 0.0);
  });

  testWidgets('Villain secondary animation x-y movement', (WidgetTester tester) async {
    Key container = Key('container');

    Widget page = Material(
      child: Align(
        alignment: Alignment.topLeft,
        child: Villain(
          villainAnimation: VillainAnimation.translateAnimation(Offset(0.0, 0.0), Offset(1.0, 0.0))..to = Duration(milliseconds: 750),
          secondaryVillainAnimation: VillainAnimation.translateAnimation(Offset(0.0, 0.0), Offset(0.0, 1.0))..to = Duration(milliseconds: 750),
          child: Container(
            width: 200.0,
            height: 200.0,
            color: Colors.red,
            key: container,
          ),
        ),
      ),
    );

    Key openKey = Key('open');

    await tester.pumpWidget(TestWidget(
      pageToOpen: page,
      buttonKey: openKey,
    ));

    await tester.tap(find.byKey(openKey));
    await tester.pump();
    await tester.pump();

    expect(find.byKey(container), findsOneWidget);

    final double initialY = tester.getTopLeft(find.byKey(container)).dy;
    final double initialX = tester.getTopLeft(find.byKey(container)).dx;

    expect(initialY, 0.0);
    expect(initialX, 0.0);

    await tester.pump(Duration(milliseconds: 250));

    final double after250Y = tester.getTopLeft(find.byKey(container)).dy;
    final double after250X = tester.getTopLeft(find.byKey(container)).dx;

    expect(after250Y, greaterThan(50.0));
    expect(after250Y, lessThan(75.0));

    expect(after250X, greaterThan(50.0));
    expect(after250X, lessThan(75.0));

    await tester.pumpAndSettle();

    final double yAtEnd = tester.getTopLeft(find.byKey(container)).dy;
    final double xAtEnd = tester.getTopLeft(find.byKey(container)).dx;

    expect(yAtEnd, 200.0);
    expect(xAtEnd, 200.0);
  });


  testWidgets('Villain wrapped in villain animation x-y movement', (WidgetTester tester) async {
    Key container = Key('container');

    Widget page = Material(
      child: Align(
        alignment: Alignment.topLeft,
        child: Villain(
          villainAnimation: VillainAnimation.translateAnimation(Offset(0.0, 0.0), Offset(0.0, 1.0))..to = Duration(milliseconds: 750),
          child: Villain(
            villainAnimation: VillainAnimation.translateAnimation(Offset(0.0, 0.0), Offset(1.0, 0.0))..to = Duration(milliseconds: 750),
            child: Container(
              width: 200.0,
              height: 200.0,
              color: Colors.red,
              key: container,
            ),
          ),
        ),
      ),
    );

    Key openKey = Key('open');

    await tester.pumpWidget(TestWidget(
      pageToOpen: page,
      buttonKey: openKey,
    ));

    await tester.tap(find.byKey(openKey));
    await tester.pump();
    await tester.pump();

    expect(find.byKey(container), findsOneWidget);

    final double initialY = tester.getTopLeft(find.byKey(container)).dy;
    final double initialX = tester.getTopLeft(find.byKey(container)).dx;

    expect(initialY, 0.0);
    expect(initialX, 0.0);

    await tester.pump(Duration(milliseconds: 250));

    final double after250Y = tester.getTopLeft(find.byKey(container)).dy;
    final double after250X = tester.getTopLeft(find.byKey(container)).dx;

    expect(after250Y, greaterThan(50.0));
    expect(after250Y, lessThan(75.0));

    expect(after250X, greaterThan(50.0));
    expect(after250X, lessThan(75.0));

    await tester.pumpAndSettle();

    final double yAtEnd = tester.getTopLeft(find.byKey(container)).dy;
    final double xAtEnd = tester.getTopLeft(find.byKey(container)).dx;

    expect(yAtEnd, 200.0);
    expect(xAtEnd, 200.0);
  });

/*
  testWidgets('Villain mutedTicker', (WidgetTester tester) async {
    Key container = Key('container');

    Widget page = Material(
      child: Align(
        alignment: Alignment.topCenter,
        child: Villain(
          villainAnimation: VillainAnimation.translateAnimation(Offset(0.0, 1.0), Offset(0.0, 0.0))..to = Duration(milliseconds: 750),
          child: Container(
            width: 200.0,
            height: 200.0,
            color: Colors.red,
            key: container,
          ),
        ),
      ),
    );

    Key openKey = Key('open');

    await tester.pumpWidget(TestWidgetWithDisabledTickerMode(
      pageToOpen: page,
      buttonKey: openKey,
    ));

    await tester.tap(find.byKey(openKey));
    await tester.pump();
    await tester.pump();

    expect(find.byKey(container), findsOneWidget);

    final double initialY = tester.getTopLeft(find.byKey(container)).dy;
    expect(initialY, 200.0);

    await tester.pump(const Duration(milliseconds: 250));

    final double yAt100ms = tester.getTopLeft(find.byKey(container)).dy;

    expect(yAt100ms, 200.0);

    await tester.pumpAndSettle();

    final double yAtEnd = tester.getTopLeft(find.byKey(container)).dy;

    expect(yAtEnd, 200.0);
  });*/
}
