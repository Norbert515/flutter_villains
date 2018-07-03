import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';

class VillainController {
  static Future playAllVillains(BuildContext context, {bool entrance = true}) {
    List<_VillainState> villains = VillainController._allVillainssFor(context)
      ..removeWhere((villain) {
        if (entrance) {
          return !villain.widget.animateEntrance;
        } else {
          return !villain.widget.animateExit;
        }
      });

    // Controller for the new page animation because it can be longer then the actual page transition

    //TODO test tickermode
    AnimationController controller = new AnimationController(vsync: TransitionTickerProvider(TickerMode.of(context)));

    SequenceAnimationBuilder builder = new SequenceAnimationBuilder();

    for (_VillainState villain in villains) {
      builder.addAnimatable(
        anim: Tween<double>(begin: 0.0, end: 1.0),
        from: villain.widget.villainAnimation.from,
        to: villain.widget.villainAnimation.to,
        tag: villain.hashCode,
      );
    }

    SequenceAnimation sequenceAnimation = builder.animate(controller);

    for (_VillainState villain in villains) {
      villain.startAnimation(sequenceAnimation[villain.hashCode]);
    }

    //Start the animation
    return controller.forward().then((_) {
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

  final VillainAnimation secondaryVillainAnimation;

  final Widget child;

  final bool animateEntrance;
  final bool animateExit;

  const Villain({Key key, @required this.villainAnimation, this.secondaryVillainAnimation, this.child, this.animateEntrance = true, this.animateExit = true})
      : super(key: key);

  @override
  _VillainState createState() {
    return new _VillainState();
  }
}

class _VillainState extends State<Villain> {
  Animation<double> _controllerAnimation;

  bool _atTheEnd;

  @override
  void initState() {
    super.initState();
    if (widget.animateEntrance == true) {
      _atTheEnd = false;
    } else {
      _atTheEnd = true;
    }
  }

  void startAnimation(Animation<double> animation) {
    assert(animation != null);
    _controllerAnimation?.removeStatusListener(_handleStatusChange);
    setState(() {
      _atTheEnd = false;
      this._controllerAnimation = animation;
    });
    animation.addStatusListener(_handleStatusChange);
  }

  get _animation {
    if (_controllerAnimation != null) {
      return _controllerAnimation;
    }
    if (_atTheEnd) {
      return AlwaysStoppedAnimation<double>(1.0);
    } else {
      return AlwaysStoppedAnimation<double>(0.0);
    }
  }

  void _handleStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.dismissed || status == AnimationStatus.completed) {
      if (_controllerAnimation != null) {
        _controllerAnimation.removeStatusListener(_handleStatusChange);
        setState(() {
          _atTheEnd = true;
          _controllerAnimation = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget animatedWidget = widget.villainAnimation
        .animatedWidgetBuilder(widget.villainAnimation.animatable.chain(CurveTween(curve: widget.villainAnimation.curve)).animate(_animation), widget.child);
    if (widget.secondaryVillainAnimation != null) {
      animatedWidget = widget.secondaryVillainAnimation.animatedWidgetBuilder(
          widget.secondaryVillainAnimation.animatable.chain(CurveTween(curve: widget.secondaryVillainAnimation.curve)).animate(_animation), animatedWidget);
    }

    return animatedWidget;
  }
}

typedef Widget AnimatedWidgetBuilder(Animation animation, Widget child);

const Duration _kMaterialRouteTransitionLength = const Duration(milliseconds: 300);

class VillainAnimation {
  final AnimatedWidgetBuilder animatedWidgetBuilder;

  final Animatable animatable;

  final Duration from;
  final Duration to;

  final Curve curve;

  /// [form] defaults to 0 and [to] defaults to the [MaterialPageRoute] transition duration which is 300 ms
  VillainAnimation(
      {@required this.animatedWidgetBuilder,
      @required this.animatable,
      this.from = Duration.zero,
      this.to = _kMaterialRouteTransitionLength,
      this.curve = Curves.linear});

  static VillainAnimation fromLeft(
          {double offset = 1.0, Duration from = Duration.zero, Duration to = _kMaterialRouteTransitionLength, Curve curve = Curves.linear}) =>
      VillainAnimation(
          curve: curve,
          from: from,
          to: to,
          animatable: Tween<Offset>(begin: Offset(-offset, 0.0), end: Offset(0.0, 0.0)),
          animatedWidgetBuilder: (animation, child) {
            return SlideTransition(
              position: animation,
              child: child,
            );
          });

  static VillainAnimation fromRight(
          {double offset = 1.0, Duration from = Duration.zero, Duration to = _kMaterialRouteTransitionLength, Curve curve = Curves.linear}) =>
      VillainAnimation(
          curve: curve,
          from: from,
          to: to,
          animatable: Tween<Offset>(begin: Offset(offset, 0.0), end: Offset(0.0, 0.0)),
          animatedWidgetBuilder: (animation, child) {
            return SlideTransition(
              position: animation,
              child: child,
            );
          });

  static VillainAnimation fromTop(
          {double offset = 1.0, Duration from = Duration.zero, Duration to = _kMaterialRouteTransitionLength, Curve curve = Curves.linear}) =>
      VillainAnimation(
          from: from,
          to: to,
          curve: curve,
          animatable: Tween<Offset>(begin: Offset(0.0, -offset), end: Offset(0.0, 0.0)),
          animatedWidgetBuilder: (animation, child) {
            return SlideTransition(
              position: animation,
              child: child,
            );
          });

  static VillainAnimation fromBottom(
      {double relativeOffset = 1.0, Duration from = Duration.zero, Duration to = _kMaterialRouteTransitionLength, Curve curve = Curves.linear}) {
    return VillainAnimation(
        from: from,
        to: to,
        curve: curve,
        animatable: Tween<Offset>(begin: Offset(0.0, relativeOffset), end: Offset(0.0, 0.0)),
        animatedWidgetBuilder: (animation, child) {
          return SlideTransition(
            position: animation,
            child: child,
          );
        });
  }

  static VillainAnimation fade(
          {double fadeFrom = 0.0,
          double fadeTo = 1.0,
          Duration from = Duration.zero,
          Duration to: _kMaterialRouteTransitionLength,
          Curve curve: Curves.linear}) =>
      VillainAnimation(
          from: from,
          curve: curve,
          to: to,
          animatable: Tween<double>(begin: fadeFrom, end: fadeTo),
          animatedWidgetBuilder: (animation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          });

  static VillainAnimation scale(
      {double fromScale = 0.5,
      double toScale = 1.0,
      Duration from = Duration.zero,
      Duration to = _kMaterialRouteTransitionLength,
      Curve curve = Curves.linear}) {
    return VillainAnimation(
        from: from,
        to: to,
        curve: curve,
        animatable: Tween<double>(begin: fromScale, end: toScale),
        animatedWidgetBuilder: (animation, child) {
          return ScaleTransition(
            scale: animation,
            child: child,
          );
        });
  }

  static VillainAnimation translate(
      {Offset fromOffset, Offset toOffset, Duration from = Duration.zero, Duration to = _kMaterialRouteTransitionLength, Curve curve = Curves.linear}) {
    return VillainAnimation(
        from: from,
        to: to,
        curve: curve,
        animatable: Tween<Offset>(begin: fromOffset, end: toOffset),
        animatedWidgetBuilder: (animation, child) {
          return SlideTransition(
            position: animation,
            child: child,
          );
        });
  }

//TODO custom villain FAB reveal

}

class VillainTransitionObserver extends NavigatorObserver {
  // Disable Hero animations while a user gesture is controlling the navigation.
  bool _questsEnabled = true;

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    assert(navigator != null);
    assert(route != null);
    _prepareVillainTransition(previousRoute, route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    assert(navigator != null);
    assert(route != null);
    _prepareVillainTransition(route, previousRoute);
  }

  @override
  void didStartUserGesture() {
    _questsEnabled = false;
  }

  @override
  void didStopUserGesture() {
    _questsEnabled = true;
  }

  void _prepareVillainTransition(Route<dynamic> fromRoute, Route<dynamic> toRoute) {
    if (_questsEnabled && toRoute != fromRoute && toRoute is PageRoute<dynamic> && fromRoute is PageRoute<dynamic>) {
      final PageRoute<dynamic> from = fromRoute;
      final PageRoute<dynamic> to = toRoute;

      // Putting a route offstage changes its animation value to 1.0. Once this
      // frame completes, we'll know where the heroes in the `to` route are
      // going to end up, and the `to` route will go back onstage.
      //   to.offstage = to.animation.value == 0.0;

      WidgetsBinding.instance.addPostFrameCallback((Duration value) {
        _startVillainTransition(from, to);
      });
    }
  }

  void _startVillainTransition(PageRoute from, PageRoute to) {
    // If the navigator or one of the routes subtrees was removed before this
    // end-of-frame callback was called, then don't actually start a transition.
    if (navigator == null || from.subtreeContext == null || to.subtreeContext == null) {
      to.offstage = false; // in case we set this in _maybeStartHeroTransition
      return;
    }

    VillainController.playAllVillains(to.subtreeContext, entrance: true);

    List<_VillainState> villains2 = VillainController._allVillainssFor(from.subtreeContext);

    //The animations from the previous page are driven by the transition animation because the page will not be visible afterwards, any animation after that
    //would be useless
    for (_VillainState villain in villains2) {
      if (villain.widget.animateExit) {
        villain.startAnimation(from.animation);
      }
    }
  }
}

class TransitionTickerProvider implements TickerProvider {
  final bool enabled;

  TransitionTickerProvider(this.enabled);

  @override
  Ticker createTicker(TickerCallback onTick) {
    return new Ticker(onTick, debugLabel: 'created by $this')..muted = !this.enabled;
  }
}
