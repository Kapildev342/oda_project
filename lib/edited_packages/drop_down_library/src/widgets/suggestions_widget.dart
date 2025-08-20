// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:oda/edited_packages/drop_down_library/dropdown_search.dart';
import 'package:oda/edited_packages/drop_down_library/src/utils.dart';
import 'package:oda/edited_packages/drop_down_library/src/widgets/custom_chip.dart';
import 'package:oda/edited_packages/drop_down_library/src/widgets/custom_wrap.dart';
import 'custom_scroll_view.dart';

class SuggestionsWidget<T> extends StatelessWidget {
  final SuggestionsProps<T> props;
  final List<T> dropdownItems;
  final bool Function(T item) isSelectedItemFn;
  final bool Function(T item) isDisabledItemFn;
  final String Function(T item) itemAsString;
  final ValueChanged<T>? onClick;
  final UiToApply uiToApply;

  const SuggestionsWidget({
    super.key,
    this.onClick,
    required this.dropdownItems,
    required this.props,
    required this.isSelectedItemFn,
    required this.isDisabledItemFn,
    required this.itemAsString,
    required this.uiToApply,
  });

  @override
  Widget build(BuildContext context) {
    if (!props.showSuggestions || props.items == null) {
      return const SizedBox.shrink();
    }

    final suggestedItems = props.items!(dropdownItems);
    //pass items to builder even if it's empty, letting user decide what to do in that case
    if (props.builder != null) {
      return props.builder!(suggestedItems);
    }

    if (dropdownItems.isEmpty || suggestedItems.isEmpty) {
      return const SizedBox.shrink();
    }

    final lItemProps = props.itemProps ?? const SuggestedItemProps();
    if (lItemProps.containerBuilder != null) {
      return lItemProps.containerBuilder!(
          context, suggestionsWidget(lItemProps, suggestedItems));
    }

    return Container(
      constraints: const BoxConstraints(maxHeight: 100),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: suggestionsWidget(lItemProps, suggestedItems),
    );
  }

  Widget suggestionsWidget(
      SuggestedItemProps lItemProps, List<T> suggestedItems) {
    return CustomSingleScrollView(
      scrollProps: lItemProps.scrollProps,
      child: CustomWrap(
        props: lItemProps.wrapProps,
        children: suggestedItems.map((s) {
          final isEnabled = !isDisabledItemFn(s);
          final isSelected = isSelectedItemFn(s);
          return CustomChip(
            label: Text(itemAsString(s)),
            props: ChipProps(
              onPressed:
                  onClick != null && isEnabled ? () => onClick!(s) : null,
              isEnabled: isEnabled,
              selected: isSelected,
              showCheckmark: isSelected,
              shape: uiToApply == UiToApply.cupertino
                  ? const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18)))
                  : null,
            ).merge(lItemProps.chipProps),
          );
        }).toList(),
      ),
    );
  }
}
