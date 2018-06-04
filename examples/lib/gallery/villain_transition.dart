import 'package:examples/simple/hero_transitions.dart';
import 'package:examples/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_villains/villain.dart';


class PictureGridPage extends StatefulWidget {
  @override
  _PictureGridPageState createState() => new _PictureGridPageState();
}

class _PictureGridPageState extends State<PictureGridPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Villains"),
      ),
      body: new GridView.count(
        crossAxisCount: 2,
        children: Images.imageThumbUrls.map((url) => new InkWell(
            child: new Hero(tag: url, child: new Image.network(url)),
          onTap: ()=>transition(url),
        )).toList(),
      ),
    );
  }



  void transition(String url) {
    Navigator.of(context).push(new FadeRoute(new PictureDetailPage(url: url,)));
  }
}


class PictureDetailPage extends StatefulWidget {


  final String url;

  const PictureDetailPage({Key key, this.url}) : super(key: key);

  @override
  _PictureDetailPageState createState() => new _PictureDetailPageState();
}

class _PictureDetailPageState extends State<PictureDetailPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new PreferredSizeProxyVillain(
        villainBuilder: (child)=> new RelativeSlideVillain(slideDirection: SlideDirection.topToBottom, child:  child,),
        child: new AppBar(
          title: new Text("Villains"),
          backgroundColor: Colors.green,
        ),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Hero(
              tag: widget.url,
              child: new Image.network(widget.url),
            ),
            new RelativeSlideVillain(
              slideDirection: SlideDirection.bottomToTop,
              child: new Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: new Text("This is a beautiful image", style: Theme.of(context).textTheme.display1,),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: new ScaleVillain(child: new FloatingActionButton(onPressed: (){}, child: new Icon(Icons.add),)),
    );
  }
}
