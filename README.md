![](https://github.com/Norbert515/flutter_villains/blob/master/assets/icons8-joker-suicide-squad-96.png)
# flutter_villains

### What are heroes without villains?

![profile-page](media/profile.gif "profile-page")

_(Profile image from: https://unsplash.com/photos/pAs4IM6OGWI)_


## What are villains?
You keep seeing beautiful page transitions but you think to yourself those are too much work?

Fear no more, villains are here to save you!

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
Remember the StaggeredAnimation tutorial? Because this is using [SequenceAnimation](https://github.com/Norbert515/flutter_sequence_animation) internally there is no need to specify durations as portions of a time-frame. It just works. 

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

1) If you want them to automatically play on page transition (you probably want that) then add this to your `MaterialApp`
```dart
    return new MaterialApp(
      navigatorObservers: [new VillainTransitionObserver()],
```

2) Play villains in a given context manually.
```dart
    VillainController.playAllVillains(context);
```


### Secondary Animation
You can play up to two animations per `Villain`. If you want more you can always wrap Villains inside each other for _infinite_ animations!
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
 



## Features:
The villain framework takes care of:
- managing page transition callbacks
- supplying animations
- providing premade common animations

In contrast to real world villains, these villains are **very** easy to handle.







Icon form https://icons8.com/ 

## Getting Started

For help getting started with Flutter, view our online [documentation](https://flutter.io/).

For help on editing package code, view the [documentation](https://flutter.io/developing-packages/).
