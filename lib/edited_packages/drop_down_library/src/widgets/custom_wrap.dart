// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:oda/edited_packages/drop_down_library/src/widgets/props/wrap_props.dart';

class CustomWrap extends StatelessWidget {
  final List<Widget> children;
  final WrapProps props;

  const CustomWrap({super.key, required this.props, required this.children});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      clipBehavior: props.clipBehavior,
      verticalDirection: props.verticalDirection,
      direction: props.direction,
      alignment: props.alignment,
      runSpacing: props.runSpacing,
      spacing: props.spacing,
      textDirection: props.textDirection,
      crossAxisAlignment: props.crossAxisAlignment,
      runAlignment: props.runAlignment,
      children: children,
    );
  }
}
