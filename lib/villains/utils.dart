import 'package:flutter/material.dart';

/// When builder this Widget, you should include the provided child into the tree
typedef Widget WidgetWithChildBuilder(BuildContext context, Widget child);

class PreferredSizeProxy extends StatelessWidget implements PreferredSizeWidget {
  final PreferredSizeWidget preferredSizeWidget;
  final WidgetWithChildBuilder widgetWithChildBuilder;

  const PreferredSizeProxy({Key key, this.preferredSizeWidget, this.widgetWithChildBuilder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return widgetWithChildBuilder(context, preferredSizeWidget);
  }

  @override
  Size get preferredSize => preferredSizeWidget.preferredSize;
}
