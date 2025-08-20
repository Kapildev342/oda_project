import 'package:flutter/material.dart';

class RoundedExpansionTile extends StatefulWidget {
  final bool? autofocus;
  final EdgeInsetsGeometry? contentPadding;
  final bool? dense;
  final bool? enabled;
  final bool? enableFeedback;
  final Color? focusColor;
  final FocusNode? focusNode;
  final double? horizontalTitleGap;
  final Color? hoverColor;
  final bool? isThreeLine;
  final Widget? leading;
  final double? minLeadingWidth;
  final double? minVerticalPadding;
  final MouseCursor? mouseCursor;
  final void Function()? onLongPress;
  final bool? selected;
  final Color? selectedTileColor;
  final ShapeBorder? shape;
  final Widget? subtitle;
  final Widget? title;
  final Color? tileColor;
  final Widget? trailing;
  final VisualDensity? visualDensity;
  final void Function()? onTap;
  final Duration? duration;
  final List<Widget>? children;
  final Curve? curve;
  final EdgeInsets? childrenPadding;
  final bool? rotateTrailing;
  final bool? noTrailing;
  final bool initiallyExpanded;

  const RoundedExpansionTile(
      {super.key,
      this.title,
      this.subtitle,
      this.leading,
      this.trailing,
      this.duration,
      this.children,
      this.autofocus,
      this.contentPadding,
      this.dense,
      this.enabled,
      this.enableFeedback,
      this.focusColor,
      this.focusNode,
      this.horizontalTitleGap,
      this.hoverColor,
      this.isThreeLine,
      this.minLeadingWidth,
      this.minVerticalPadding,
      this.mouseCursor,
      this.onLongPress,
      this.selected,
      this.selectedTileColor,
      this.shape,
      this.tileColor,
      this.visualDensity,
      this.onTap,
      this.curve,
      this.childrenPadding,
      this.rotateTrailing,
      this.noTrailing,
      this.initiallyExpanded = false});

  @override
  State<RoundedExpansionTile> createState() => _RoundedExpansionTileState();
}

class _RoundedExpansionTileState extends State<RoundedExpansionTile> with TickerProviderStateMixin {
  late bool _expanded;
  bool? _rotateTrailing;
  bool? _noTrailing;
  late AnimationController _controller;
  late AnimationController _iconController;
  Duration defaultDuration = const Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
    _rotateTrailing = widget.rotateTrailing ?? true;
    _noTrailing = widget.noTrailing ?? false;
    _controller = AnimationController(vsync: this, duration: widget.duration ?? defaultDuration);
    _iconController = AnimationController(
      duration: widget.duration ?? defaultDuration,
      vsync: this,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    if (mounted) {
      _controller.dispose();
      _iconController.dispose();
      super.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            autofocus: widget.autofocus ?? false,
            contentPadding: widget.contentPadding,
            dense: widget.dense,
            enabled: widget.enabled ?? true,
            enableFeedback: widget.enableFeedback ?? false,
            focusColor: widget.focusColor,
            focusNode: widget.focusNode,
            horizontalTitleGap: widget.horizontalTitleGap,
            hoverColor: widget.hoverColor,
            isThreeLine: widget.isThreeLine ?? false,
            key: widget.key,
            leading: widget.leading,
            minLeadingWidth: widget.minLeadingWidth,
            minVerticalPadding: widget.minVerticalPadding,
            mouseCursor: widget.mouseCursor,
            onLongPress: widget.onLongPress,
            selected: widget.selected ?? false,
            selectedTileColor: widget.selectedTileColor,
            shape: widget.shape,
            subtitle: widget.subtitle,
            title: widget.title,
            tileColor: widget.tileColor,
            trailing: _noTrailing! ? null : _trailingIcon(),
            visualDensity: widget.visualDensity,
            splashColor: Colors.transparent,
            onTap: () {
              if (widget.onTap != null) {
                widget.onTap;
              }
              setState(() {
                if (_expanded) {
                  _expanded = !_expanded;
                  _controller.forward();
                  _iconController.reverse();
                } else {
                  _expanded = !_expanded;
                  _controller.reverse();
                  _iconController.forward();
                }
              });
            },
          ),
          AnimatedCrossFade(
              firstCurve: widget.curve == null ? Curves.fastLinearToSlowEaseIn : widget.curve!,
              secondCurve: widget.curve == null ? Curves.fastLinearToSlowEaseIn : widget.curve!,
              crossFadeState: _expanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              duration: widget.duration == null ? defaultDuration : widget.duration!,
              firstChild: ListView(
                physics: const ClampingScrollPhysics(),
                padding: widget.childrenPadding ?? EdgeInsets.zero,
                shrinkWrap: true,
                children: widget.children!,
              ),
              secondChild: Container()),
        ]);
  }

  Widget? _trailingIcon() {
    if (widget.trailing != null) {
      if (_rotateTrailing!) {
        return RotationTransition(turns: Tween(begin: 0.0, end: 0.25).animate(_iconController), child: widget.trailing);
      } else {
        return widget.trailing;
      }
    } else {
      return AnimatedIcon(icon: AnimatedIcons.close_menu, progress: _controller);
    }
  }
}
