// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:oda/edited_packages/drop_down_library/src/widgets/props/scroll_props.dart';

class CustomSingleScrollView extends StatelessWidget {
  final ScrollProps scrollProps;
  final Widget child;

  const CustomSingleScrollView({
    super.key,
    this.scrollProps = const ScrollProps(),
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollProps.controller,
      padding: scrollProps.padding,
      clipBehavior: scrollProps.clipBehavior,
      dragStartBehavior: scrollProps.dragStartBehavior,
      //hitTestBehavior: scrollProps.hitTestBehavior,
      keyboardDismissBehavior: scrollProps.keyboardDismissBehavior,
      physics: scrollProps.physics,
      scrollDirection: Axis.vertical,
      reverse: scrollProps.reverse,
      primary: scrollProps.primary,
      child: child,
    );
  }
}
