import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_villains/villains/villains.dart';




class ListVillain extends StatelessWidget {


  ListVillain.batman({
    this.child,
    int index,
    Curve curve,
    int delay,
  }) : primaryAnimation = null, secondaryAnimation = null;

  final Widget child;
  
  final VillainAnimation primaryAnimation;

  final VillainAnimation secondaryAnimation;


  @override
  Widget build(BuildContext context) {
    return Villain(
      villainAnimation: primaryAnimation,
      secondaryVillainAnimation: secondaryAnimation,
      child: child,
    );
  }
}


class VillainListView extends StatelessWidget {

  final Axis scrollDirection;

  final bool reverse;

  final ScrollController controller;

  final bool primary;

  final ScrollPhysics physics;

  final bool shrinkWrap;

  final EdgeInsetsGeometry padding;

  final double itemExtent;

  final double cacheExtent;

  final SliverChildDelegate childrenDelegate;

  VillainListView({
    Key key,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.itemExtent,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    this.cacheExtent,
    List<Widget> children = const <Widget>[],
  }) : childrenDelegate = SliverChildListDelegate(
    children,
    addAutomaticKeepAlives: addAutomaticKeepAlives,
    addRepaintBoundaries: addRepaintBoundaries,
  ),  super(key: key,);


  VillainListView.builder({
    Key key,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.itemExtent,
    @required IndexedWidgetBuilder itemBuilder,
    int itemCount,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    this.cacheExtent,
  }) : childrenDelegate = SliverChildBuilderDelegate(
    itemBuilder,
    childCount: itemCount,
    addAutomaticKeepAlives: addAutomaticKeepAlives,
    addRepaintBoundaries: addRepaintBoundaries,
  ), super(key: key,);


  VillainListView.separated({
    Key key,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    @required IndexedWidgetBuilder itemBuilder,
    @required IndexedWidgetBuilder separatorBuilder,
    @required int itemCount,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    this.cacheExtent,
  }) : assert(itemBuilder != null),
        assert(separatorBuilder != null),
        assert(itemCount != null && itemCount >= 0),
        itemExtent = null,
        childrenDelegate = SliverChildBuilderDelegate(
              (BuildContext context, int index) {
            final int itemIndex = index ~/ 2;
            return index.isEven
                ? itemBuilder(context, itemIndex)
                : separatorBuilder(context, itemIndex);
          },
          childCount: math.max(0, itemCount * 2 - 1),
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
        ), super(key: key,);


  @override
  Widget build(BuildContext context) {
    return ListView.custom(
      padding: padding,
      controller: controller,
      shrinkWrap: shrinkWrap,
      primary: primary,
      itemExtent: itemExtent,
      cacheExtent: cacheExtent,
      reverse: reverse,
      scrollDirection: scrollDirection,
      physics: physics,
      childrenDelegate: childrenDelegate
    );
  }
}
