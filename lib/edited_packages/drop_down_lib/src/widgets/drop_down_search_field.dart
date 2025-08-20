// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:pointer_interceptor/pointer_interceptor.dart';

// Project imports:
import 'package:oda/edited_packages/drop_down_lib/src/keyboard_suggestion_selection_notifier.dart';
import 'package:oda/edited_packages/drop_down_lib/src/should_refresh_suggestion_focus_index_notifier.dart';
import 'package:oda/edited_packages/drop_down_lib/src/suggestions/suggestions_box.dart';
import 'package:oda/edited_packages/drop_down_lib/src/suggestions/suggestions_box_controller.dart';
import 'package:oda/edited_packages/drop_down_lib/src/suggestions/suggestions_box_decoration.dart';
import 'package:oda/edited_packages/drop_down_lib/src/suggestions/suggestions_list.dart';
import 'package:oda/edited_packages/drop_down_lib/src/type_def.dart';
import 'package:oda/edited_packages/drop_down_lib/src/widgets/search_field_configuration.dart';

class DropDownSearchField<T> extends StatefulWidget {
  final SuggestionsCallback<T>? suggestionsCallback;
  final SuggestionsCallback<T>? paginatedSuggestionsCallback;
  final SuggestionSelectionCallback<T> onSuggestionSelected;
  final ItemBuilder<T> itemBuilder;
  final IndexedWidgetBuilder? itemSeparatorBuilder;
  final LayoutArchitecture? layoutArchitecture;
  final ScrollController? scrollController;
  final SuggestionsBoxDecoration suggestionsBoxDecoration;
  final SuggestionsBoxController? suggestionsBoxController;
  final Duration debounceDuration;
  final WidgetBuilder? loadingBuilder;
  final WidgetBuilder? noItemsFoundBuilder;
  final ErrorBuilder? errorBuilder;
  final bool intercepting;
  final AnimationTransitionBuilder? transitionBuilder;
  final Duration animationDuration;
  final AxisDirection direction;
  final double animationStart;
  final TextFieldConfiguration textFieldConfiguration;
  final double suggestionsBoxVerticalOffset;
  final bool getImmediateSuggestions;
  final bool hideOnLoading;
  final bool hideOnEmpty;
  final bool hideOnError;
  final bool hideSuggestionsOnKeyboardHide;
  final bool keepSuggestionsOnLoading;
  final bool keepSuggestionsOnSuggestionSelected;
  final bool autoFlipDirection;
  final bool autoFlipListDirection;
  final double autoFlipMinHeight;
  final bool hideKeyboard;
  final int minCharsForSuggestions;
  final bool hideKeyboardOnDrag;
  final void Function(bool)? onSuggestionsBoxToggle;
  final bool displayAllSuggestionWhenTap;

  const DropDownSearchField({
    this.suggestionsCallback,
    this.paginatedSuggestionsCallback,
    required this.itemBuilder,
    this.itemSeparatorBuilder,
    this.layoutArchitecture,
    this.intercepting = false,
    required this.onSuggestionSelected,
    this.textFieldConfiguration = const TextFieldConfiguration(),
    this.suggestionsBoxDecoration = const SuggestionsBoxDecoration(),
    this.debounceDuration = const Duration(milliseconds: 300),
    this.suggestionsBoxController,
    this.scrollController,
    this.loadingBuilder,
    this.noItemsFoundBuilder,
    this.errorBuilder,
    this.transitionBuilder,
    this.animationStart = 0.25,
    this.animationDuration = const Duration(milliseconds: 500),
    this.getImmediateSuggestions = false,
    this.suggestionsBoxVerticalOffset = 5.0,
    this.direction = AxisDirection.down,
    this.hideOnLoading = false,
    this.hideOnEmpty = false,
    this.hideOnError = false,
    this.hideSuggestionsOnKeyboardHide = true,
    this.keepSuggestionsOnLoading = true,
    this.keepSuggestionsOnSuggestionSelected = false,
    this.autoFlipDirection = false,
    this.autoFlipListDirection = true,
    this.autoFlipMinHeight = 64.0,
    this.hideKeyboard = false,
    this.minCharsForSuggestions = 0,
    this.onSuggestionsBoxToggle,
    this.hideKeyboardOnDrag = false,
    required this.displayAllSuggestionWhenTap,
    super.key,
  })  : assert(animationStart >= 0.0 && animationStart <= 1.0),
        assert(direction == AxisDirection.down || direction == AxisDirection.up),
        assert(minCharsForSuggestions >= 0),
        assert(!hideKeyboardOnDrag || hideKeyboardOnDrag && !hideSuggestionsOnKeyboardHide),
        assert(
          (suggestionsCallback != null || paginatedSuggestionsCallback != null) && !(suggestionsCallback != null && paginatedSuggestionsCallback != null),
          'Either suggestionsCallback or paginatedSuggestionsCallback must be provided, but not both.',
        );

  @override
  State<DropDownSearchField> createState() => _DropDownSearchFieldState<T>();
}

class _DropDownSearchFieldState<T> extends State<DropDownSearchField<T>> with WidgetsBindingObserver {
  FocusNode? _focusNode;
  final KeyboardSuggestionSelectionNotifier _keyboardSuggestionSelectionNotifier = KeyboardSuggestionSelectionNotifier();
  TextEditingController? _textEditingController;
  SuggestionsBox? _suggestionsBox;
  TextEditingController? get _effectiveController => widget.textFieldConfiguration.controller ?? _textEditingController;
  FocusNode? get _effectiveFocusNode => widget.textFieldConfiguration.focusNode ?? _focusNode;
  late VoidCallback _focusNodeListener;
  final LayerLink _layerLink = LayerLink();
  Timer? _resizeOnScrollTimer;
  final Duration _resizeOnScrollRefreshRate = const Duration(milliseconds: 500);
  ScrollPosition? _scrollPosition;
  final Stream<bool>? _keyboardVisibility = null;
  late StreamSubscription<bool>? _keyboardVisibilitySubscription;
  bool _areSuggestionsFocused = false;
  late final _shouldRefreshSuggestionsFocusIndex = ShouldRefreshSuggestionFocusIndexNotifier(textFieldFocusNode: _effectiveFocusNode);

  @override
  void didChangeMetrics() {
    // Catch keyboard event and orientation change; resize suggestions list
    this._suggestionsBox!.onChangeMetrics();
  }

  @override
  void dispose() {
    this._suggestionsBox!.close();
    this._suggestionsBox!.widgetMounted = false;
    WidgetsBinding.instance.removeObserver(this);
    _keyboardVisibilitySubscription?.cancel();
    _effectiveFocusNode!.removeListener(_focusNodeListener);
    _focusNode?.dispose();
    _resizeOnScrollTimer?.cancel();
    _scrollPosition?.removeListener(_scrollResizeListener);
    _textEditingController?.dispose();
    _keyboardSuggestionSelectionNotifier.dispose();
    super.dispose();
  }

  KeyEventResult _onKeyEvent(FocusNode _, KeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.arrowUp || event.logicalKey == LogicalKeyboardKey.arrowDown) {
    } else {
      _keyboardSuggestionSelectionNotifier.onKeyboardEvent(event);
    }
    return KeyEventResult.ignored;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.textFieldConfiguration.controller == null) {
      this._textEditingController = TextEditingController();
    }
    final textFieldConfigurationFocusNode = widget.textFieldConfiguration.focusNode;
    if (textFieldConfigurationFocusNode == null) {
      this._focusNode = FocusNode(onKeyEvent: _onKeyEvent);
    }
    else if (textFieldConfigurationFocusNode.onKeyEvent == null) {
      // * we add the _onKeyEvent callback to the textFieldConfiguration focusNode
      textFieldConfigurationFocusNode.onKeyEvent = ((node, event) {
        final keyEventResult = _onKeyEvent(node, event);
        return keyEventResult;
      });
    }
    else {
      final onKeyCopy = textFieldConfigurationFocusNode.onKeyEvent!;
      textFieldConfigurationFocusNode.onKeyEvent = ((node, event) {
        _onKeyEvent(node, event);
        return onKeyCopy(node, event);
      });
    }

    this._suggestionsBox = SuggestionsBox(
      context,
      widget.direction,
      widget.autoFlipDirection,
      widget.autoFlipListDirection,
      widget.autoFlipMinHeight,
    );

    widget.suggestionsBoxController?.suggestionsBox = this._suggestionsBox;
    widget.suggestionsBoxController?.effectiveFocusNode = this._effectiveFocusNode;

    this._focusNodeListener = () {
      if (_effectiveFocusNode!.hasFocus) {
        this._suggestionsBox!.open();
      } else if (!_areSuggestionsFocused) {
        if (widget.hideSuggestionsOnKeyboardHide) {
          this._suggestionsBox!.close();
        }
      }
      widget.onSuggestionsBoxToggle?.call(this._suggestionsBox!.isOpened);
    };

    this._effectiveFocusNode!.addListener(_focusNodeListener);
    this._keyboardVisibilitySubscription = _keyboardVisibility?.listen((bool isVisible) {
      if (widget.hideSuggestionsOnKeyboardHide && !isVisible) {
        _effectiveFocusNode!.unfocus();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((duration) {
      if (mounted) {
        this._initOverlayEntry();
        this._suggestionsBox!.resize();
        if (this._effectiveFocusNode!.hasFocus) {
          this._suggestionsBox!.open();
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final scrollableState = Scrollable.maybeOf(context);
    if (scrollableState != null) {
      _scrollPosition = scrollableState.position;
      _scrollPosition!.removeListener(_scrollResizeListener);
      _scrollPosition!.isScrollingNotifier.addListener(_scrollResizeListener);
    }
  }

  void _scrollResizeListener() {
    bool isScrolling = _scrollPosition!.isScrollingNotifier.value;
    _resizeOnScrollTimer?.cancel();
    if (isScrolling) {
      _resizeOnScrollTimer = Timer.periodic(_resizeOnScrollRefreshRate, (timer) {
        _suggestionsBox!.resize();
      });
    } else {
      _suggestionsBox!.resize();
    }
  }

  void _initOverlayEntry() {
    this._suggestionsBox!.overlayEntry = OverlayEntry(builder: (context) {
      void giveTextFieldFocus() {
        _effectiveFocusNode?.requestFocus();
        _areSuggestionsFocused = false;
      }

      void onSuggestionFocus() {
        if (!_areSuggestionsFocused) {
          _areSuggestionsFocused = true;
        }
      }

      final suggestionsList = SuggestionsList<T>(
        suggestionsBox: _suggestionsBox,
        decoration: widget.suggestionsBoxDecoration,
        debounceDuration: widget.debounceDuration,
        intercepting: widget.intercepting,
        controller: this._effectiveController,
        loadingBuilder: widget.loadingBuilder,
        scrollController: widget.scrollController,
        noItemsFoundBuilder: widget.noItemsFoundBuilder,
        errorBuilder: widget.errorBuilder,
        transitionBuilder: widget.transitionBuilder,
        suggestionsCallback: widget.suggestionsCallback,
        paginatedSuggestionsCallback: widget.paginatedSuggestionsCallback,
        animationDuration: widget.animationDuration,
        animationStart: widget.animationStart,
        getImmediateSuggestions: widget.getImmediateSuggestions,
        onSuggestionSelected: (T selection) {
          if (!widget.keepSuggestionsOnSuggestionSelected) {
            this._effectiveFocusNode!.unfocus();
            this._suggestionsBox!.close();
          }
          widget.onSuggestionSelected(selection);
        },
        itemBuilder: widget.itemBuilder,
        itemSeparatorBuilder: widget.itemSeparatorBuilder,
        layoutArchitecture: widget.layoutArchitecture,
        direction: _suggestionsBox!.direction,
        hideOnLoading: widget.hideOnLoading,
        hideOnEmpty: widget.hideOnEmpty,
        hideOnError: widget.hideOnError,
        keepSuggestionsOnLoading: widget.keepSuggestionsOnLoading,
        minCharsForSuggestions: widget.minCharsForSuggestions,
        keyboardSuggestionSelectionNotifier: _keyboardSuggestionSelectionNotifier,
        shouldRefreshSuggestionFocusIndexNotifier: _shouldRefreshSuggestionsFocusIndex,
        giveTextFieldFocus: giveTextFieldFocus,
        onSuggestionFocus: onSuggestionFocus,
        onKeyEvent: _onKeyEvent,
        hideKeyboardOnDrag: widget.hideKeyboardOnDrag,
        displayAllSuggestionWhenTap: widget.displayAllSuggestionWhenTap,
      );

      double w = _suggestionsBox!.textBoxWidth;
      if (widget.suggestionsBoxDecoration.constraints != null) {
        if (widget.suggestionsBoxDecoration.constraints!.minWidth != 0.0 && widget.suggestionsBoxDecoration.constraints!.maxWidth != double.infinity) {
          w = (widget.suggestionsBoxDecoration.constraints!.minWidth + widget.suggestionsBoxDecoration.constraints!.maxWidth) / 2;
        } else if (widget.suggestionsBoxDecoration.constraints!.minWidth != 0.0 && widget.suggestionsBoxDecoration.constraints!.minWidth > w) {
          w = widget.suggestionsBoxDecoration.constraints!.minWidth;
        } else if (widget.suggestionsBoxDecoration.constraints!.maxWidth != double.infinity && widget.suggestionsBoxDecoration.constraints!.maxWidth < w) {
          w = widget.suggestionsBoxDecoration.constraints!.maxWidth;
        }
      }

      final Widget compositedFollower = CompositedTransformFollower(
        link: this._layerLink,
        showWhenUnlinked: false,
        offset: Offset(widget.suggestionsBoxDecoration.offsetX, _suggestionsBox!.direction == AxisDirection.down ? _suggestionsBox!.textBoxHeight + widget.suggestionsBoxVerticalOffset : -widget.suggestionsBoxVerticalOffset),
        child: _suggestionsBox!.direction == AxisDirection.down
            ? suggestionsList
            : FractionalTranslation(
                translation: const Offset(0.0, -1.0),
                child: suggestionsList,
              ),
      );
      return MediaQuery.of(context).accessibleNavigation
          ? Semantics(
              container: true,
              child: Align(
                alignment: Alignment.topLeft,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: w),
                  child: compositedFollower,
                ),
              ),
            )
          : Positioned(
              width: w,
              child: compositedFollower,
            );
    });
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: this._layerLink,
      child: PointerInterceptor(
        intercepting: widget.intercepting,
        child: TextField(
            focusNode: this._effectiveFocusNode,
            controller: this._effectiveController,
            decoration: widget.textFieldConfiguration.decoration,
            style: widget.textFieldConfiguration.style,
            textAlign: widget.textFieldConfiguration.textAlign,
            enabled: widget.textFieldConfiguration.enabled,
            keyboardType: widget.textFieldConfiguration.keyboardType,
            autofocus: widget.textFieldConfiguration.autofocus,
            inputFormatters: widget.textFieldConfiguration.inputFormatters,
            autocorrect: widget.textFieldConfiguration.autocorrect,
            maxLines: widget.textFieldConfiguration.maxLines,
            textAlignVertical: widget.textFieldConfiguration.textAlignVertical,
            minLines: widget.textFieldConfiguration.minLines,
            maxLength: widget.textFieldConfiguration.maxLength,
            maxLengthEnforcement: widget.textFieldConfiguration.maxLengthEnforcement,
            obscureText: widget.textFieldConfiguration.obscureText,
            onChanged: widget.textFieldConfiguration.onChanged,
            onSubmitted: widget.textFieldConfiguration.onSubmitted,
            onEditingComplete: widget.textFieldConfiguration.onEditingComplete,
            onTap: widget.textFieldConfiguration.onTap,
            onTapOutside: widget.textFieldConfiguration.onTapOutside,
            scrollPadding: widget.textFieldConfiguration.scrollPadding,
            textInputAction: widget.textFieldConfiguration.textInputAction,
            textCapitalization: widget.textFieldConfiguration.textCapitalization,
            keyboardAppearance: widget.textFieldConfiguration.keyboardAppearance,
            cursorWidth: widget.textFieldConfiguration.cursorWidth,
            cursorRadius: widget.textFieldConfiguration.cursorRadius,
            cursorColor: widget.textFieldConfiguration.cursorColor,
            mouseCursor: widget.textFieldConfiguration.mouseCursor,
            textDirection: widget.textFieldConfiguration.textDirection,
            enableInteractiveSelection: widget.textFieldConfiguration.enableInteractiveSelection,
            readOnly: widget.hideKeyboard,
            autofillHints: widget.textFieldConfiguration.autofillHints),
      ),
    );
  }
}
