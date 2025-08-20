// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:oda/edited_packages/drop_down_library/src/widgets/props/safe_area_props.dart';

class CustomSafeArea extends StatelessWidget {
  final Widget child;
  final SafeAreaProps props;

  const CustomSafeArea({super.key, required this.child, required this.props});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: props.top,
      right: props.right,
      bottom: props.bottom,
      left: props.left,
      minimum: props.minimum,
      maintainBottomViewPadding: props.maintainBottomViewPadding,
      child: child,
    );
  }
}
