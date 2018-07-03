import 'package:flutter/material.dart';
import 'package:flutter_villains/villains/villains.dart';
import '../utils.dart';

// image from https://unsplash.com/photos/pAs4IM6OGWI
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => new _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            child: Hero(tag: "profile", child: CircleAvatar(backgroundImage: AssetImage("assets/joe-gardner.jpg"))),
            onTap: () {
              Navigator.of(context).push(BlankTransition(ProfilePage2()));
            },
          ),
        ),
      ),
    );
  }
}

class ProfilePage2 extends StatefulWidget {
  @override
  _ProfilePage2State createState() => new _ProfilePage2State();
}

class _ProfilePage2State extends State<ProfilePage2> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      backgroundColor: Color(0xffdddddd),
      body: Center(
        child: ListView(
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Villain(
                  animateEntrance: false,
                  villainAnimation: VillainAnimation.fade(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Hero(
                          tag: "profile",
                          child: CircleAvatar(
                            backgroundImage: AssetImage("assets/joe-gardner.jpg"),
                            radius: 50.0,
                          )),
                      SizedBox(
                        height: 16.0,
                      ),
                      Villain(
                        villainAnimation: VillainAnimation.fromBottom(relativeOffset: 0.4, to: Duration(milliseconds: 150)),
                        animateExit: false,
                        secondaryVillainAnimation: VillainAnimation.fade(),
                        child: Text(
                          "This is some great text writtin. This is a short summary, containing useful information. This needs to be a bit longer so I'll jsut keep writing.",
                          style: Theme
                              .of(context)
                              .textTheme
                              .body1,
                        ),
                      ),
                      Villain(
                        villainAnimation: VillainAnimation.fromBottom(relativeOffset: 0.4),
                        animateExit: false,
                        secondaryVillainAnimation: VillainAnimation.fade(),
                        child: Divider(
                          color: Colors.black,
                          height: 32.0,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Villain(
                            villainAnimation: VillainAnimation.fromBottom(
                                relativeOffset: 0.8, curve: Curves.fastOutSlowIn, from: Duration(milliseconds: 100), to: Duration(milliseconds: 250)),
                            secondaryVillainAnimation: VillainAnimation.fade(),
                            animateExit: false,
                            child: Container(
                              child: Center(child: Text("A", style: TextStyle(color: Colors.white, fontSize: 20.0),)),
                              decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xffea4c89)),
                              width: 32.0,
                              height: 32.0,
                            ),
                          ),
                          Villain(
                              villainAnimation: VillainAnimation.fromBottom(
                                  relativeOffset: 0.8, curve: Curves.fastOutSlowIn, from: Duration(milliseconds: 150), to: Duration(milliseconds: 300)),
                            secondaryVillainAnimation: VillainAnimation.fade(),
                            animateExit: false,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Container(
                                child: Center(child: Text("B", style: TextStyle(color: Colors.white, fontSize: 20.0),)),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blueAccent,
                                ),
                                width: 32.0,
                                height: 32.0,
                              ),
                            ),
                          ),
                          Villain(
                              villainAnimation: VillainAnimation.fromBottom(
                                  relativeOffset: 0.8, curve: Curves.fastOutSlowIn, from: Duration(milliseconds: 200), to: Duration(milliseconds: 350)),
                            secondaryVillainAnimation: VillainAnimation.fade(),
                            animateExit: false,
                            child: Container(
                              child: Center(child: Text("C", style: TextStyle(color: Colors.white, fontSize: 20.0),)),
                              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.redAccent),
                              width: 32.0,
                              height: 32.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 64.0,
            ),
            Villain(
              villainAnimation: VillainAnimation.fromBottom(relativeOffset: 0.05, from: Duration(milliseconds: 300), to: Duration(milliseconds: 400)),
              secondaryVillainAnimation: VillainAnimation.fade(),
              child: Card(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text("Info card"),
                        subtitle: Text("More info"),
                      ),
                      ListTile(
                        title: Text("Ideas start running out"),
                        subtitle: Text("Yup no idea"),
                      ),
                      ListTile(
                        title: Text("Some text"),
                        subtitle: Text("A text specifying the text above"),
                      ),
                      ListTile(
                        title: Text("Please"),
                        subtitle: Text("A text specifying the text above"),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
