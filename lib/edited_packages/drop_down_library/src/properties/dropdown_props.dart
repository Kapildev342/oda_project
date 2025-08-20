// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:oda/edited_packages/drop_down_library/dropdown_search.dart';
import 'package:oda/edited_packages/drop_down_library/src/widgets/props/icon_button_props.dart';

typedef DropdownButtonAnimationBuilder = Widget Function(
    Widget child, bool isOpen);

class DropdownButtonProps extends IconButtonProps {
  final Widget? iconOpened;
  final DropdownButtonAnimationBuilder? animationBuilder;

  const DropdownButtonProps({
    this.iconOpened,
    Widget? iconClosed,
    this.animationBuilder,
    super.isVisible = true,
    super.iconSize,
    super.visualDensity,
    super.padding,
    super.alignment,
    super.splashRadius,
    super.color,
    super.focusColor,
    super.hoverColor,
    super.highlightColor,
    super.splashColor,
    super.disabledColor,
    super.mouseCursor,
    super.focusNode,
    super.autofocus,
    super.tooltip,
    super.enableFeedback,
    super.constraints,
    super.style,
    super.isSelected,
    super.selectedIcon,
  }) : super(icon: iconClosed);
}

class DropDownDecoratorProps {
  final InputDecoration? decoration;
  final TextStyle? baseStyle;
  final TextAlign? textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool expands;
  final bool isHovering;

  const DropDownDecoratorProps({
    this.decoration,
    this.baseStyle,
    this.textAlign,
    this.textAlignVertical,
    this.expands = false,
    this.isHovering = false,
  });
}
