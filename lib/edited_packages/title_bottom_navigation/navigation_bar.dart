// Dart imports:
import 'dart:ui' show lerpDouble;

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:oda/edited_packages/title_bottom_navigation/navigation_bar_item.dart';

const double defaultBarHeight = 60;

const double defaultIndicatorHeight = 2;

// ignore: must_be_immutable
class TitledBottomNavigationBar extends StatefulWidget {
  final bool reverse;
  final Curve curve;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? inactiveStripColor;
  final Color? indicatorColor;
  final bool enableShadow;
  int currentIndex;
  final ValueChanged<int> onTap;
  final List<TitledNavigationBarItem> items;
  final double indicatorHeight;
  final double height;

  TitledBottomNavigationBar({
    super.key,
    this.reverse = false,
    this.curve = Curves.linear,
    required this.onTap,
    required this.items,
    this.activeColor,
    this.inactiveColor,
    this.inactiveStripColor,
    this.indicatorColor,
    this.enableShadow = true,
    this.currentIndex = 0,
    this.height = defaultBarHeight,
    this.indicatorHeight = defaultIndicatorHeight,
  }) : assert(items.length >= 2 && items.length <= 5);

  @override
  State createState() => _TitledBottomNavigationBarState();
}

class _TitledBottomNavigationBarState extends State<TitledBottomNavigationBar> {
  bool get reverse => widget.reverse;
  Curve get curve => widget.curve;
  List<TitledNavigationBarItem> get items => widget.items;
  double width = 0;
  Color? activeColor;
  Duration duration = const Duration(milliseconds: 270);

  double _getIndicatorPosition(int index) {
    var isLtr = Directionality.of(context) == TextDirection.ltr;
    if (isLtr) {
      return lerpDouble(-1.0, 1.0, index / (items.length - 1))!;
    } else {
      return lerpDouble(1.0, -1.0, index / (items.length - 1))!;
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    activeColor = widget.activeColor ?? Theme.of(context).indicatorColor;

    return Container(
      height: widget.height + MediaQuery.of(context).viewPadding.bottom,
      width: width,
      decoration: BoxDecoration(
        color: widget.inactiveStripColor ?? Theme.of(context).cardColor,
        boxShadow: widget.enableShadow
            ? [
                const BoxShadow(color: Colors.black12, blurRadius: 10),
              ]
            : null,
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: widget.indicatorHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: items.map((item) {
                var index = items.indexOf(item);
                return GestureDetector(
                  onTap: () => _select(index),
                  child: _buildItemWidget(item, index == widget.currentIndex),
                );
              }).toList(),
            ),
          ),
          Positioned(
            top: 0,
            width: width,
            child: AnimatedAlign(
              alignment: Alignment(_getIndicatorPosition(widget.currentIndex), 0),
              curve: curve,
              duration: duration,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width / (items.length * 3)),
                child: Container(
                  width: width / (items.length * 3),
                  height: widget.indicatorHeight,
                  decoration: BoxDecoration(
                    color: widget.indicatorColor ?? activeColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _select(int index) {
    widget.currentIndex = index;
    widget.onTap(widget.currentIndex);
    setState(() {});
  }

  Widget _buildIcon(TitledNavigationBarItem item) {
    return IconTheme(
      data: IconThemeData(
        color: reverse ? widget.inactiveColor : activeColor,
      ),
      child: item.icon,
    );
  }

  Widget _buildText(TitledNavigationBarItem item) {
    return DefaultTextStyle.merge(
      child: item.title,
      style: TextStyle(color: reverse ? activeColor : widget.inactiveColor),
    );
  }

  Widget _buildItemWidget(TitledNavigationBarItem item, bool isSelected) {
    return Container(
      color: item.backgroundColor,
      height: widget.height,
      width: width / items.length,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _buildIcon(item),
          _buildText(item),
        ],
      ),
    );
  }
}
