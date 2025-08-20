// Project imports:
import 'package:oda/edited_packages/drop_down_library/src/base_dropdown_search.dart';
import 'widgets/props/cupertino_popup_props.dart';

class CupertinoDropdownSearch<T> extends BaseDropdownSearch<T> {
  CupertinoDropdownSearch({
    CupertinoPopupProps<T> popupProps = const CupertinoPopupProps.menu(),
    super.key,
    super.selectedItem,
    super.mode = Mode.form,
    super.autoValidateMode,
    super.onSelected,
    super.items,
    super.dropdownBuilder,
    super.suffixProps,
    super.clickProps,
    super.enabled,
    super.filterFn,
    super.itemAsString,
    super.compareFn,
    super.onBeforeChange,
    super.onBeforePopupOpening,
    //form properties
    super.onSaved,
    super.validator,
    super.decoratorProps,
  }) : super(
          popupProps: popupProps,
          uiMode: UiMode.cupertino,
          groupId: popupProps.autoCompleteProps.groupId,
        );

  CupertinoDropdownSearch.multiSelection({
    CupertinoMultiSelectionPopupProps<T> popupProps =
        const CupertinoMultiSelectionPopupProps.menu(),
    super.key,
    super.mode = Mode.form,
    super.autoValidateMode,
    super.items,
    super.suffixProps,
    super.clickProps,
    super.enabled = true,
    super.filterFn,
    super.itemAsString,
    super.compareFn,
    super.selectedItems,
    super.selectedItemsScrollProps,
    super.onSelected,
    super.onBeforeChange,
    super.onBeforePopupOpening,
    super.dropdownBuilder,
    //form properties
    super.onSaved,
    super.validator,
    super.decoratorProps,
  }) : super.multiSelection(
          popupProps: popupProps,
          uiMode: UiMode.cupertino,
          groupId: popupProps.autoCompleteProps.groupId,
        );
}
