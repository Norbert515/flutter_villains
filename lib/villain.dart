import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// Base class for all villain transitions
abstract class Villain extends StatefulWidget {

  final Widget child;

  final bool animateEntrance;
  final bool animateExit;

  const Villain({Key key, this.child, this.animateEntrance = true, this.animateExit = true}) :  assert(child != null), super(key: key);

}

abstract class _VillainState<T extends Villain> extends State<T>{

  Animation<double> _animation;

  void startAnimation(Animation<double> animation) {
    assert(animation != null);
    setState(() {
      this._animation = animation;
    });
    animation.addStatusListener(_handleStatusChange);
  }

  Animation<double> getTween() {
    if(_animation != null) {
      return _animation;
    }
    return new AlwaysStoppedAnimation<double>(1.0);
  }

  void _handleStatusChange(AnimationStatus status) {
    if(status == AnimationStatus.dismissed || status == AnimationStatus.completed) {
      if(_animation != null) {
        _animation.removeStatusListener(_handleStatusChange);
        setState(() {
          _animation = null;
        });
      }
    }
  }
}

/// A Villain which let s you supply the animation.
/// Consider using an AnimatedWidget which takes an animation as input parameter which is supplied
/// by this callback
typedef Widget WidgetWithAnimationBuilder(Animation<double> animation);

class CustomVillain extends Villain {


  final WidgetWithAnimationBuilder builder;

  CustomVillain(this.builder);

  @override
  _CustomVillainState createState() => new _CustomVillainState();
}

class _CustomVillainState extends _VillainState<CustomVillain>{
  @override
  Widget build(BuildContext context) {
    return widget.builder(getTween());
  }
}

/// A villain which slides in from any direction
///
///

enum SlideDirection {
  topToBottom,
  leftToRight,
  rightToLeft,
  bottomToTop,
}

class RelativeSlideVillain extends Villain {

  final SlideDirection slideDirection;

  RelativeSlideVillain({@required this.slideDirection, Widget child, bool animateEntrance = true, bool animateExit = true}): super(child: child, animateExit: animateExit, animateEntrance: animateEntrance);
  @override
  _RelativeSlideVillainState createState() => new _RelativeSlideVillainState();
}

class _RelativeSlideVillainState extends _VillainState<RelativeSlideVillain>{

  @override
  Widget build(BuildContext context) {
    Offset start;

    switch(widget.slideDirection) {
      case SlideDirection.topToBottom:
        start = const Offset(0.0, -1.0);
        break;
      case SlideDirection.leftToRight:
        start = const Offset(-1.0, 0.0);
        break;
      case SlideDirection.rightToLeft:
        start = const Offset(1.0, 0.0);
        break;
      case SlideDirection.bottomToTop:
        start = const Offset(0.0, 1.0);
        break;
    }

    return new SlideTransition(
        child: widget.child,
        position: new Tween<Offset>(
          begin: start,
          end: const Offset(0.0, 0.0),
        ).animate(getTween())
    );
  }

}

typedef Villain VillainBuilder(Widget child);

class PreferredSizeProxyVillain extends Villain implements PreferredSizeWidget {

  final PreferredSizeWidget child;

  final VillainBuilder villainBuilder;

  PreferredSizeProxyVillain({this.villainBuilder, this.child, bool animateEntrance = true, bool animateExit = true}): super(child: child, animateEntrance: animateEntrance, animateExit: animateExit);
  @override
  State<StatefulWidget> createState() => new _PreferredSizeProxyVillainState();

  @override
  Size get preferredSize => child.preferredSize;

}


class _PreferredSizeProxyVillainState extends _VillainState<PreferredSizeProxyVillain> {
  @override
  Widget build(BuildContext context) {
    return widget.villainBuilder(widget.child);
  }

}


class ScaleVillain extends Villain {

  final Alignment alignment;
  final double fromFactor;


  ScaleVillain({this.alignment = Alignment.center, this.fromFactor = 2.0, Widget child, bool animateEntrance = true, bool animateExit = true}): super(child:child, animateEntrance: animateEntrance, animateExit: animateExit);

  @override
  State<StatefulWidget> createState() => new _ScaleVillainState();

}

class _ScaleVillainState extends _VillainState<ScaleVillain> {


  @override
  Widget build(BuildContext context) {
    return new ScaleTransition(scale: new Tween<double>(begin: widget.fromFactor, end: 1.0).animate(getTween()), child: widget.child);
  }

}



class EasyTransitionController extends NavigatorObserver {

  // Returns a map of all of the heroes in context, indexed by hero tag.
  static List<_VillainState> _allVillainssFor(BuildContext context) {
    assert(context != null);
    final List<_VillainState> villains = [];

    void visitor(Element element) {
      if (element.widget is Villain) {
        final StatefulElement villain = element;
        final Villain heroWidget = element.widget;

        final _VillainState villainState = villain.state;
        villains.add(villainState);
      }
      element.visitChildren(visitor);
    }
    context.visitChildElements(visitor);
    return villains;
  }

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


  void _maybeStartHeroTransition(Route<dynamic> fromRoute,
      Route<dynamic> toRoute) {
    if (_questsEnabled && toRoute != fromRoute &&
        toRoute is PageRoute<dynamic> && fromRoute is PageRoute<dynamic>) {
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
    if (navigator == null || from.subtreeContext == null ||
        to.subtreeContext == null) {
      to.offstage = false; // in case we set this in _maybeStartHeroTransition
      return;
    }

    List<_VillainState> villains = EasyTransitionController
        ._allVillainssFor(to.subtreeContext);
    List<_VillainState> villains2 = EasyTransitionController
        ._allVillainssFor(from.subtreeContext);

    for (_VillainState villain in villains) {
      if (villain.widget.animateEntrance) {
        villain.startAnimation(to.animation);
      }
    }

    for (_VillainState villain in villains2) {
      if (villain.widget.animateExit) {
        villain.startAnimation(from.animation);
      }
    }
  }

}