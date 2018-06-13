import 'package:flutter/material.dart';


class Villain extends StatelessWidget {

  final VillainAnimation villainAnimation;

  final Widget child;

  final Duration from;

  final Duration to;

  const Villain({Key key, this.villainAnimation, this.child, this.from, this.to}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return villainAnimation.animationBuilder(null, child);
  }
}


typedef Widget AnimationBuilder(Animation animation, Widget child);

class VillainAnimation {

  final AnimationBuilder animationBuilder;

  VillainAnimation({this.animationBuilder});




  static VillainAnimation fromLeftToRight = VillainAnimation(animationBuilder: (anim, child) {
    return new SlideTransition(
      position: Tween<Offset>(begin: Offset(-1.0, 0.0), end: Offset(0.0,0.0)).animate(anim),
      child: child,
    );
  });

}
