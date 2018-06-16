import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';



class VillainController {

  static Future playAllVillains(BuildContext context) {
    List<_VillainState> villains = VillainController._allVillainssFor(context);


    // Controller for the new page animation because it can be longer then the actual page transition

    AnimationController controller = new AnimationController(vsync: new TransitionTickerProvider());

    SequenceAnimationBuilder builder = new SequenceAnimationBuilder();

    for (_VillainState villain in villains) {
      builder.addAnimatable(
          anim: Tween<double>(begin: 0.0, end: 1.0), from: villain.widget.villainAnimation.from, to: villain.widget.villainAnimation.to, tag: villain.hashCode);
    }

    SequenceAnimation sequenceAnimation = builder.animate(controller);

    for (_VillainState villain in villains) {
      villain.startAnimation(sequenceAnimation[villain.hashCode]);
    }

    //Start the animation
    return controller.forward().then((_){
      controller.dispose();
    });

  }

  // Returns a map of all of the heroes in context, indexed by hero tag.
  static List<_VillainState> _allVillainssFor(BuildContext context) {
    assert(context != null);
    final List<_VillainState> villains = [];

    void visitor(Element element) {
      if (element.widget is Villain) {
        final StatefulElement villain = element;
        final _VillainState villainState = villain.state;
        villains.add(villainState);
      }
      element.visitChildren(visitor);
    }

    context.visitChildElements(visitor);
    return villains;
  }
}

class Villain extends StatefulWidget {
  final VillainAnimation villainAnimation;

  final Widget child;

  const Villain({Key key, this.villainAnimation, this.child}) : super(key: key);

  @override
  _VillainState createState() {
    return new _VillainState();
  }
}

class _VillainState extends State<Villain> {
  Animation<double> _animation;

  void startAnimation(Animation<double> animation) {
    assert(animation != null);
    setState(() {
      this._animation = animation;
    });
    animation.addStatusListener(_handleStatusChange);
  }

  Animation<double> getTween() {
    if (_animation != null) {
      return _animation;
    }
    return new AlwaysStoppedAnimation<double>(1.0);
  }

  void _handleStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.dismissed || status == AnimationStatus.completed) {
      if (_animation != null) {
        _animation.removeStatusListener(_handleStatusChange);
        setState(() {
          _animation = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.villainAnimation.animatedWidgetBuilder(widget.villainAnimation.animatable.animate(getTween()), widget.child);
  }
}

typedef Widget AnimatedWidgetBuilder(Animation animation, Widget child);

class VillainAnimation {
  final AnimatedWidgetBuilder animatedWidgetBuilder;

  final Animatable animatable;

  Duration from;
  Duration to;

  /// [form] defaults to 0 and [to] defaults to the [MaterialPageRoute] transition duration which is 300 ms
  VillainAnimation({this.animatedWidgetBuilder, this.animatable, this.from = Duration.zero, this.to = const Duration(milliseconds: 300)});







  static VillainAnimation fromLeftToRight = VillainAnimation(
      animatable: Tween<Offset>(begin: Offset(-1.0, 0.0), end: Offset(0.0, 0.0)),
      animatedWidgetBuilder: (animation, child) {
        return SlideTransition(
          position: animation,
          child: child,
        );
      });

  static VillainAnimation fromRightToLeft = VillainAnimation(
      animatable: Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0)),
      animatedWidgetBuilder: (animation, child) {
        return SlideTransition(
          position: animation,
          child: child,
        );
      });

  static VillainAnimation fromTopToBottom = VillainAnimation(
      animatable: Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset(0.0, 0.0)),
      animatedWidgetBuilder: (animation, child) {
        return SlideTransition(
          position: animation,
          child: child,
        );
      });

  static VillainAnimation fromBottomToTop = VillainAnimation(
      animatable: Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0)),
      animatedWidgetBuilder: (animation, child) {
        return SlideTransition(
          position: animation,
          child: child,
        );
      });

  static VillainAnimation fadeIn = VillainAnimation(
      animatable: Tween<double>(begin: 0.0, end: 1.0),
      animatedWidgetBuilder: (animation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      });


  static VillainAnimation scaleDown = VillainAnimation(
      animatable: Tween<double>(begin: 2.0, end: 1.0),
      animatedWidgetBuilder: (animation, child) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      });

  static VillainAnimation scaleUp = VillainAnimation(
      animatable: Tween<double>(begin: 0.0, end: 1.0),
      animatedWidgetBuilder: (animation, child) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      });

  //TODO custom villain FAB reveal


//TODO Tabcontrooler like villains, VillainController Widget, DefaultVillain InheritedWidget
//TODO DefaultTagController look at
}

class VillainTransitionObserver extends NavigatorObserver {

  // Disable Hero animations while a user gesture is controlling the navigation.
  bool _questsEnabled = true;

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    assert(navigator != null);
    assert(route != null);
    _maybeStartHeroTransition(previousRoute, route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    assert(navigator != null);
    assert(route != null);
    _maybeStartHeroTransition(route, previousRoute);
  }

  @override
  void didStartUserGesture() {
    _questsEnabled = false;
  }

  @override
  void didStopUserGesture() {
    _questsEnabled = true;
  }

  void _maybeStartHeroTransition(Route<dynamic> fromRoute, Route<dynamic> toRoute) {
    if (_questsEnabled && toRoute != fromRoute && toRoute is PageRoute<dynamic> && fromRoute is PageRoute<dynamic>) {
      final PageRoute<dynamic> from = fromRoute;
      final PageRoute<dynamic> to = toRoute;

      // Putting a route offstage changes its animation value to 1.0. Once this
      // frame completes, we'll know where the heroes in the `to` route are
      // going to end up, and the `to` route will go back onstage.
      //   to.offstage = to.animation.value == 0.0;

      WidgetsBinding.instance.addPostFrameCallback((Duration value) {
        _startHeroTransition(from, to);
      });
    }
  }

  void _startHeroTransition(PageRoute from, PageRoute to) {
    // If the navigator or one of the routes subtrees was removed before this
    // end-of-frame callback was called, then don't actually start a transition.
    if (navigator == null || from.subtreeContext == null || to.subtreeContext == null) {
      to.offstage = false; // in case we set this in _maybeStartHeroTransition
      return;
    }

    VillainController.playAllVillains(to.subtreeContext);

    List<_VillainState> villains2 = VillainController._allVillainssFor(from.subtreeContext);


    //TODO handle timing when animation out

    //The animations from the previous page are driven by the transition animation because the page will not be visible afterwards, any animation after that
    //would be useless
    for (_VillainState villain in villains2) {
      villain.startAnimation(from.animation);
    }
  }
}

class TransitionTickerProvider implements TickerProvider {

  @override
  Ticker createTicker(TickerCallback onTick) {
    return new Ticker(onTick, debugLabel: 'created by $this');
  }
}
