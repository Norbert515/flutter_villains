import 'package:flutter/material.dart';
import 'package:flutter_villains/villains/villains.dart';

class ColumnsPage extends StatefulWidget {
  @override
  _ColumnsPageState createState() => new _ColumnsPageState();
}

class _ColumnsPageState extends State<ColumnsPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Columns"),
      ),
      body: new Center(
        child: new Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new RaisedButton(onPressed: (){}, child: new Text("Pay now", style: Theme.of(context).textTheme.display1,),),
                new SizedBox(height: 16.0,),
                new Villain(
                  animateExit: false,
                  villainAnimation: VillainAnimation.fromBottomToTop,
                  child: new Text("Lorem ipsum und so weiter, das kann sich doch niemand wirklich merken und ich mein es macht doch kein unterschied obs jetzt latein oder deutsch ist",
                  style: Theme.of(context).textTheme.title,),
                )
              ],
          ),
        ),
      ),
    );
  }
}
