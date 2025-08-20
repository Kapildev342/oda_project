// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:oda/edited_packages/drop_down_lib/src/widgets/drop_down_search_field.dart';

class SuggestionsBox {
  static const int waitMetricsTimeoutMilliseconds = 1000;
  final BuildContext context;
  final AxisDirection desiredDirection;
  final bool autoFlipDirection;
  final bool autoFlipListDirection;
  final double autoFlipMinHeight;
  OverlayEntry? overlayEntry;
  AxisDirection direction;
  bool isOpened = false;
  bool widgetMounted = true;
  double maxHeight = 300.0;
  double textBoxWidth = 100.0;
  double textBoxHeight = 100.0;
  late double directionUpOffset;

  SuggestionsBox(
    this.context,
    this.direction,
    this.autoFlipDirection,
    this.autoFlipListDirection,
    this.autoFlipMinHeight,
  ) : desiredDirection = direction;

  void open() {
    if (isOpened) return;
    assert(overlayEntry != null);
    resize();
    Overlay.of(context).insert(overlayEntry!);
    isOpened = true;
  }

  void close() {
    if (!isOpened) return;
    assert(overlayEntry != null);
    overlayEntry!.remove();
    isOpened = false;
  }

  void toggle() {
    if (isOpened) {
      close();
    } else {
      open();
    }
  }

  MediaQuery? _findRootMediaQuery() {
    MediaQuery? rootMediaQuery;
    context.visitAncestorElements((element) {
      if (element.widget is MediaQuery) {
        rootMediaQuery = element.widget as MediaQuery;
      }
      return true;
    });
    return rootMediaQuery;
  }

  /// Delays until the keyboard has toggled or the orientation has fully changed
  Future<bool> _waitChangeMetrics() async {
    if (widgetMounted) {
      EdgeInsets initial = MediaQuery.of(context).viewInsets;
      MediaQuery? initialRootMediaQuery = _findRootMediaQuery();
      int timer = 0;
      while (widgetMounted && timer < waitMetricsTimeoutMilliseconds) {
        await Future<void>.delayed(const Duration(milliseconds: 170));
        timer += 170;
        if (widgetMounted &&
            // ignore: use_build_context_synchronously
            (MediaQuery.of(context).viewInsets != initial || _findRootMediaQuery() != initialRootMediaQuery)) {
          return true;
        }
      }
    }
    return false;
  }

  void resize() {
    if (widgetMounted) {
      _adjustMaxHeightAndOrientation();
      overlayEntry!.markNeedsBuild();
    }
  }

  // See if there's enough room in the desired direction for the overlay to display
  // correctly. If not, try the opposite direction if things look more roomy there
  void _adjustMaxHeightAndOrientation() {
    DropDownSearchField widget = context.widget as DropDownSearchField;
    RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box == null || box.hasSize == false) {
      return;
    }

    textBoxWidth = box.size.width;
    textBoxHeight = box.size.height;
    double textBoxAbsY = box.localToGlobal(Offset.zero).dy;
    double windowHeight = MediaQuery.of(context).size.height;
    MediaQuery rootMediaQuery = _findRootMediaQuery()!;
    double keyboardHeight = rootMediaQuery.data.viewInsets.bottom;

    double maxHDesired = _calculateMaxHeight(desiredDirection, box, widget, windowHeight, rootMediaQuery, keyboardHeight, textBoxAbsY);
    if (maxHDesired >= autoFlipMinHeight || !autoFlipDirection) {
      direction = desiredDirection;
      if (!maxHDesired.isNaN) {
        maxHeight = maxHDesired;
      }
    } else {
      AxisDirection flipped = flipAxisDirection(desiredDirection);
      double maxHFlipped = _calculateMaxHeight(flipped, box, widget, windowHeight, rootMediaQuery, keyboardHeight, textBoxAbsY);
      if (maxHFlipped > maxHDesired) {
        direction = flipped;
        if (!maxHFlipped.isNaN) {
          maxHeight = maxHFlipped;
        }
      }
    }
    if (maxHeight < 0) maxHeight = 0;
  }

  double _calculateMaxHeight(AxisDirection direction, RenderBox box, DropDownSearchField widget, double windowHeight, MediaQuery rootMediaQuery, double keyboardHeight, double textBoxAbsY) {
    return direction == AxisDirection.down ? _calculateMaxHeightDown(box, widget, windowHeight, rootMediaQuery, keyboardHeight, textBoxAbsY) : _calculateMaxHeightUp(box, widget, windowHeight, rootMediaQuery, keyboardHeight, textBoxAbsY);
  }

  double _calculateMaxHeightDown(RenderBox box, DropDownSearchField widget, double windowHeight, MediaQuery rootMediaQuery, double keyboardHeight, double textBoxAbsY) {
    // unsafe area, ie: iPhone X 'home button'
    // keyboardHeight includes unsafeAreaHeight, if keyboard is showing, set to 0
    double unsafeAreaHeight = keyboardHeight == 0 ? rootMediaQuery.data.padding.bottom : 0;

    return windowHeight - keyboardHeight - unsafeAreaHeight - textBoxHeight - textBoxAbsY - 2 * widget.suggestionsBoxVerticalOffset;
  }

  double _calculateMaxHeightUp(RenderBox box, DropDownSearchField widget, double windowHeight, MediaQuery rootMediaQuery, double keyboardHeight, double textBoxAbsY) {
    // recalculate keyboard absolute y value
    double keyboardAbsY = windowHeight - keyboardHeight;

    directionUpOffset = textBoxAbsY > keyboardAbsY ? keyboardAbsY - textBoxAbsY - widget.suggestionsBoxVerticalOffset : -widget.suggestionsBoxVerticalOffset;

    // unsafe area, ie: iPhone X notch
    double unsafeAreaHeight = rootMediaQuery.data.padding.top;

    return textBoxAbsY > keyboardAbsY ? keyboardAbsY - unsafeAreaHeight - 2 * widget.suggestionsBoxVerticalOffset : textBoxAbsY - unsafeAreaHeight - 2 * widget.suggestionsBoxVerticalOffset;
  }

  Future<void> onChangeMetrics() async {
    if (await _waitChangeMetrics()) {
      resize();
    }
  }
}
