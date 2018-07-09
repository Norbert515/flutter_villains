![](https://github.com/Norbert515/flutter_villains/blob/master/assets/icons8-joker-suicide-squad-96.png)
# flutter_villains

### What are heroes without villains?

![profile-page](media/profile.gif "profile-page")

_(Profile image from: https://unsplash.com/photos/pAs4IM6OGWI)_

_Check out the [article](https://medium.com/flutter-community/flutter-heroes-and-villains-bringing-balance-to-the-flutterverse-2e900222de41)._

## What are villains?
You keep seeing beautiful page transitions but you think to yourself those are too much work?

Fear no more, villains are here to save you!

When doing animations when a page transition occurs you'd usally define an `AnimationController` in the `initState()` and start it there. You'd also have to wrap your widgets in `AnimatedWidgets` to react to the animation controller. Besides this being a lot of boilerplate code which clogs up you precious widgets animating on exit isn't as trivial.

Using this library you can just wrap your widget you'd like to be animated when a page transition occurs in a `Villain` and everything is handled automatically.

## Installation
```
dependencies:
  flutter_villains: "^1.0.0"
```
Run packages get and **import**:
```
import 'package:flutter_villains/villain.dart';
```

### Assembling pages with style
Define animations to play when a page is opened.

### Easy to use 
```dart
      Villain(
        villainAnimation: VillainAnimation.fromBottom(
          relativeOffset: 0.4,
          from: Duration(milliseconds: 100),
          to: Duration(seconds: 1),
        ),
        animateExit: false,
        secondaryVillainAnimation: VillainAnimation.fade(),
        child: Divider(
          color: Colors.black,
          height: 32.0,
        ),
      ),
```
That's it. No `TickerProvider`s, no `AnimationController`s, no boilerplate, no worries.
Remember the StaggeredAnimation tutorial? This is using [SequenceAnimation](https://github.com/Norbert515/flutter_sequence_animation) internally and there is therefore no need to specify durations as portions of a time-frame. It just works. 

With this basic setup the `Divider` fades in and moves up when a page transition occures (don't forget the `VillainTransitionObserver` more on that under *Code*).

### Flexible 
The animation you'd like to use is not premade? Make it yourself with a few lines of code!

```dart
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
```
Every `VillainAnimation` needs an `Animatable` (most of the time it's a `Tween`) and an `AnimatedWidget`. Everything else is handled automatically.


## Code

There are two way of playing your villains.

1) If you want them to automatically play when a page transition occurs (you probably want that) then add this to your `MaterialApp`
```dart
    return new MaterialApp(
      navigatorObservers: [new VillainTransitionObserver()],
```

2) Play villains in a given context manually.
```dart
    VillainController.playAllVillains(context);
```


### Secondary Animation
You can play up to two animations per `Villain`. You can always wrap Villains inside each other for _infinite_ animations!
```dart
    Villain(
      villainAnimation: VillainAnimation.fromBottomToTop(0.4, to: Duration(milliseconds: 150)),
      animateExit: false,
      secondaryVillainAnimation: VillainAnimation.fade,
      child: Text(
        "Hi",
        style: Theme.of(context).textTheme.body1,
      ),
    ),
```

### Extras
Define whether the villain should play on entrance/ exit.
```dart
    animateEntrance: true,
    animateExit: true,
```
When using the `VillainController` manually, it checks this bool to determine whether it should animate. 
```dart
  static Future playAllVillains(BuildContext context, {bool entrance = true})
```

Villains entering the page are decoupled from the page transition, meaning they can be as long as they 
want. On the other hand, if a villain leaves the page, the animation is driven by the page transition.
This means:
 - The exit animation is always as long a the exit page transition
 - Setting the duration doesn't change anything
 

## Examples
Take a look at the example folder for three nice examples.

## Features:
The villain framework takes care of:
- managing page transition callbacks
- supplying animations
- providing premade common animations

In contrast to real world villains, these villains are **very** easy to handle.



## Controller
Currenty there are no controllers implemented to play individual villains by themselves. If you'd like to have that implemented I opened an issue discussing it. Check it out!




Icon from https://icons8.com/ 

## Getting Started

For help getting started with Flutter, view our online [documentation](https://flutter.io/).

For help on editing package code, view the [documentation](https://flutter.io/developing-packages/).
