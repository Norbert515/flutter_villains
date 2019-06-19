import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';

class VillainController {
  static Future playAllVillains(BuildContext context, {bool entrance = true, bool didPop = false}) {
    List<_VillainState> villains = VillainController._allVillainsFor(context)
      ..removeWhere((villain) {
        if(entrance) {
          if(!villain.widget.animateEntrance) return true;
        } else {
          if(!villain.widget.animateExit) return true;
        }
        if(didPop) {
          if(!villain.widget.animateReEntrance) return true;
        }
        return false;
      });

    // Controller for the new page animation because it can be longer then the actual page transition

    AnimationController controller = new AnimationController(vsync: TransitionTickerProvider(TickerMode.of(context)));

    SequenceAnimationBuilder builder = new SequenceAnimationBuilder();

    for (_VillainState villain in villains) {
      builder.addAnimatable(
        animatable: Tween<double>(begin: 0.0, end: 1.0),
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
  static List<_VillainState> _allVillainsFor(BuildContext context) {
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
/// A widget which animates when a page transition occurs.
///
/// This class warps its child in an [AnimatedWidget] and handles its animation
/// when a page transition happens.
///
/// Important: You need to add this to your [MaterialApp]
/// ```
/// navigatorObservers: [new VillainTransitionObserver()],
/// ```
class Villain extends StatefulWidget {

  const Villain(
      {Key key,
        @required this.villainAnimation,
        this.secondaryVillainAnimation,
        this.child,
        this.animateEntrance = true,
        this.animateExit = true,
        this.animateReEntrance = true})
      : super(key: key);

  final VillainAnimation villainAnimation;
  final VillainAnimation secondaryVillainAnimation;

  final Widget child;

  final bool animateEntrance;
  final bool animateExit;
  final bool animateReEntrance;

  @override
  _VillainState createState() => _VillainState();
}

class _VillainState extends State<Villain> {
  Animation<double> _controllerAnimation;

  @override
  void dispose() {
    _controllerAnimation?.removeStatusListener(_handleStatusChange);
    super.dispose();
  }

  void startAnimation(Animation<double> animation) {
    assert(animation != null);
    _controllerAnimation?.removeStatusListener(_handleStatusChange);
    setState(() {
      this._controllerAnimation = animation;
    });
    animation.addStatusListener(_handleStatusChange);
  }

  get _animation {
    if (_controllerAnimation != null) {
      return _controllerAnimation;
    }
    return AlwaysStoppedAnimation<double>(1.0);
  }

  void _handleStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.dismissed || status == AnimationStatus.completed) {
      if (_controllerAnimation != null) {
        _controllerAnimation.removeStatusListener(_handleStatusChange);
        setState(() {
          _controllerAnimation = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget animatedWidget = widget.villainAnimation.animatedWidgetBuilder(
        widget.villainAnimation.animatable.chain(CurveTween(curve: widget.villainAnimation.curve)).animate(_animation), widget.child);
    if (widget.secondaryVillainAnimation != null) {
      animatedWidget = widget.secondaryVillainAnimation.animatedWidgetBuilder(
          widget.secondaryVillainAnimation.animatable.chain(CurveTween(curve: widget.secondaryVillainAnimation.curve)).animate(_animation),
          animatedWidget);
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
  VillainAnimation({
    @required this.animatedWidgetBuilder,
    @required this.animatable,
    this.from = Duration.zero,
    this.to = _kMaterialRouteTransitionLength,
    this.curve = Curves.linear,
  });

  static VillainAnimation fromLeft({
    double offset = 1.0,
    Duration from = Duration.zero,
    Duration to = _kMaterialRouteTransitionLength,
    Curve curve = Curves.linear,
  }) =>
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

  static VillainAnimation fromRight({
    double offset = 1.0,
    Duration from = Duration.zero,
    Duration to = _kMaterialRouteTransitionLength,
    Curve curve = Curves.linear,
  }) =>
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

  static VillainAnimation fromTop({
    double offset = 1.0,
    Duration from = Duration.zero,
    Duration to = _kMaterialRouteTransitionLength,
    Curve curve = Curves.linear,
  }) =>
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

  static VillainAnimation fromBottom({
    double relativeOffset = 1.0,
    Duration from = Duration.zero,
    Duration to = _kMaterialRouteTransitionLength,
    Curve curve = Curves.linear,
  }) =>
      VillainAnimation(
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

  static VillainAnimation fade({
    double fadeFrom = 0.0,
    double fadeTo = 1.0,
    Duration from = Duration.zero,
    Duration to: _kMaterialRouteTransitionLength,
    Curve curve: Curves.linear,
  }) =>
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

  static VillainAnimation scale({
    double fromScale = 0.5,
    double toScale = 1.0,
    Duration from = Duration.zero,
    Duration to = _kMaterialRouteTransitionLength,
    Curve curve = Curves.linear,
  }) =>
      VillainAnimation(
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

  static VillainAnimation translate({
    Offset fromOffset,
    Offset toOffset,
    Duration from = Duration.zero,
    Duration to = _kMaterialRouteTransitionLength,
    Curve curve = Curves.linear,
  }) =>
      VillainAnimation(
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

  static VillainAnimation transformRotate({
    double toAngle = 0.0,
    @required double fromAngle,
    Duration from = Duration.zero,
    @required Duration to,
    Curve curve = Curves.linear,
  }) =>
      VillainAnimation(
        curve: curve,
        from: from,
        to: to,
        animatable: Tween<double>(begin: fromAngle, end: toAngle),
        animatedWidgetBuilder: (animation, child) {
          return AnimatedBuilder(
            animation: animation,
            builder: (BuildContext a, Widget b) {
              return Transform.rotate(
                angle: animation.value,
                child: child,
              );
            },
          );
        },
      );

  static VillainAnimation transformTranslate({
    Offset toOffset = Offset.zero,
    @required Offset fromOffset,
    Duration from = Duration.zero,
    @required Duration to,
    Curve curve = Curves.linear,
  }) =>
      VillainAnimation(
          curve: curve,
          from: from,
          to: to,
          animatable: Tween<Offset>(begin: fromOffset, end: toOffset),
          animatedWidgetBuilder: (animation, child) {
            return AnimatedBuilder(
              animation: animation,
              builder: (BuildContext a, Widget b) {
                return Transform.translate(
                  offset: animation.value,
                  child: child,
                );
              },
            );
          });

//TODO custom villain FAB reveal

}

class VillainTransitionObserver extends NavigatorObserver {
  // Disable Hero animations while a user gesture is controlling the navigation.
  bool _questsEnabled = true;

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    assert(navigator != null);
    assert(route != null);
    _prepareVillainTransition(previousRoute, route, false);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    assert(navigator != null);
    assert(route != null);
    _prepareVillainTransition(route, previousRoute, true);
  }


  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    assert(navigator != null);
    assert(newRoute != null);
    _prepareVillainTransition(oldRoute, newRoute, false);
  }


  @override
  void didRemove(Route<dynamic> route, Route<dynamic> previousRoute) {
    assert(navigator != null);
    assert(route != null);
    _prepareVillainTransition(route, previousRoute, true);
  }

  @override
  void didStartUserGesture(Route<dynamic> route, Route<dynamic> previousRoute) {
    _questsEnabled = false;
  }

  @override
  void didStopUserGesture() {
    _questsEnabled = true;
  }

  void _prepareVillainTransition(Route<dynamic> fromRoute, Route<dynamic> toRoute, bool didPop) {
    if (_questsEnabled && toRoute != fromRoute && toRoute is PageRoute<dynamic> && fromRoute is PageRoute<dynamic>) {
      final PageRoute<dynamic> from = fromRoute;
      final PageRoute<dynamic> to = toRoute;

      // Putting a route offstage changes its animation value to 1.0. Once this
      // frame completes, we'll know where the heroes in the `to` route are
      // going to end up, and the `to` route will go back onstage.
      //   to.offstage = to.animation.value == 0.0;

      WidgetsBinding.instance.addPostFrameCallback((Duration value) {
        _startVillainTransition(from, to, didPop);
      });
    }
  }

  void _startVillainTransition(PageRoute from, PageRoute to, bool didPop) {
    // If the navigator or one of the routes subtrees was removed before this
    // end-of-frame callback was called, then don't actually start a transition.
    if (navigator == null || from.subtreeContext == null || to.subtreeContext == null) {
      to.offstage = false; // in case we set this in _maybeStartHeroTransition
      return;
    }

    // Can be null because of didReplace and didRemove
    if(to != null) {
      VillainController.playAllVillains(to.subtreeContext, entrance: true, didPop: didPop);
    }

    if(to != null) {
      List<_VillainState> villains2 = VillainController._allVillainsFor(from.subtreeContext);

      //The animations from the previous page are driven by the transition animation because the page will not be visible afterwards, any animation after that
      //would be useless
      for (_VillainState villain in villains2) {
        if (villain.widget.animateExit) {
          villain.startAnimation(from.animation);
        }
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
