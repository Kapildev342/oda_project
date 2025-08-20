// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:oda/edited_packages/drop_down_library/src/base_dropdown_search.dart';
import 'package:oda/edited_packages/drop_down_library/src/popups/props/autocomplete_props.dart';
import 'package:oda/edited_packages/drop_down_library/src/popups/props/bottom_sheet_props.dart';
import 'package:oda/edited_packages/drop_down_library/src/popups/props/dialog_props.dart';
import 'package:oda/edited_packages/drop_down_library/src/popups/props/menu_props.dart';
import 'package:oda/edited_packages/drop_down_library/src/popups/props/modal_bottom_sheet_props.dart';
import 'package:oda/edited_packages/drop_down_library/src/widgets/props/base_popup_props.dart';
import 'package:oda/edited_packages/drop_down_library/src/widgets/props/text_field_props.dart';

class MultiSelectionPopupProps<T> extends BasePopupProps<T> {
  ///dialog mode props
  final DialogProps dialogProps;

  ///BottomSheet mode props
  final BottomSheetProps bottomSheetProps;

  ///ModalBottomSheet mode props
  final ModalBottomSheetProps modalBottomSheetProps;

  ///Menu mode props
  final MenuProps menuProps;

  ///Menu mode props
  final AutocompleteProps autoCompleteProps;

  const MultiSelectionPopupProps.menu({
    this.menuProps = const MenuProps(),
    TextFieldProps super.searchFieldProps = const TextFieldProps(),
    super.fit,
    super.suggestionsProps,
    super.scrollbarProps,
    super.listViewProps,
    super.searchDelay,
    super.itemClickProps,
    super.showSearchBox,
    super.title,
    super.disableFilter,
    super.cacheItems,
    super.itemBuilder,
    super.disabledItemFn,
    super.onDismissed,
    super.emptyBuilder,
    super.errorBuilder,
    super.loadingBuilder,
    super.showSelectedItems,
    super.containerBuilder,
    super.constraints = const BoxConstraints(maxHeight: 350),
    super.interceptCallBacks,
    super.infiniteScrollProps,
    super.onItemsLoaded,
    //multi selection props
    super.onItemAdded,
    super.onItemRemoved,
    super.checkBoxBuilder,
    super.validationBuilder,
    super.textDirection = TextDirection.ltr,
  })  : bottomSheetProps = const BottomSheetProps(),
        dialogProps = const DialogProps(),
        autoCompleteProps = const AutocompleteProps(),
        modalBottomSheetProps = const ModalBottomSheetProps(),
        super(mode: PopupMode.menu);

  const MultiSelectionPopupProps.autocomplete({
    this.autoCompleteProps = const AutocompleteProps(),
    TextFieldProps super.searchFieldProps = const TextFieldProps(),
    super.fit,
    super.suggestionsProps,
    super.scrollbarProps,
    super.listViewProps,
    super.searchDelay,
    super.itemClickProps,
    super.showSearchBox,
    super.title,
    super.disableFilter,
    super.cacheItems,
    super.itemBuilder,
    super.disabledItemFn,
    super.onDismissed,
    super.emptyBuilder,
    super.errorBuilder,
    super.loadingBuilder,
    super.showSelectedItems,
    super.containerBuilder,
    super.constraints = const BoxConstraints(maxHeight: 350),
    super.interceptCallBacks,
    super.infiniteScrollProps,
    super.onItemsLoaded,
    //multi selection props
    super.onItemAdded,
    super.onItemRemoved,
    super.checkBoxBuilder,
    super.validationBuilder,
    super.textDirection = TextDirection.ltr,
  })  : bottomSheetProps = const BottomSheetProps(),
        dialogProps = const DialogProps(),
        menuProps = const MenuProps(),
        modalBottomSheetProps = const ModalBottomSheetProps(),
        super(mode: PopupMode.autocomplete);

  const MultiSelectionPopupProps.dialog({
    this.dialogProps = const DialogProps(),
    TextFieldProps super.searchFieldProps = const TextFieldProps(),
    super.fit,
    super.suggestionsProps,
    super.scrollbarProps,
    super.listViewProps,
    super.searchDelay,
    super.itemClickProps,
    super.showSearchBox,
    super.title,
    super.disableFilter,
    super.cacheItems,
    super.itemBuilder,
    super.disabledItemFn,
    super.onDismissed,
    super.emptyBuilder,
    super.errorBuilder,
    super.loadingBuilder,
    super.showSelectedItems,
    super.containerBuilder,
    super.constraints = const BoxConstraints(
      minWidth: 500,
      maxWidth: 500,
      maxHeight: 600,
    ),
    super.interceptCallBacks,
    super.infiniteScrollProps,
    super.onItemsLoaded,
    //multi selection props
    super.onItemAdded,
    super.onItemRemoved,
    super.checkBoxBuilder,
    super.validationBuilder,
    super.textDirection = TextDirection.ltr,
  })  : bottomSheetProps = const BottomSheetProps(),
        menuProps = const MenuProps(),
        autoCompleteProps = const AutocompleteProps(),
        modalBottomSheetProps = const ModalBottomSheetProps(),
        super(mode: PopupMode.dialog);

  const MultiSelectionPopupProps.bottomSheet({
    this.bottomSheetProps = const BottomSheetProps(),
    TextFieldProps super.searchFieldProps = const TextFieldProps(),
    super.fit,
    super.suggestionsProps,
    super.scrollbarProps,
    super.listViewProps,
    super.searchDelay,
    super.itemClickProps,
    super.showSearchBox,
    super.title,
    super.disableFilter,
    super.cacheItems,
    super.itemBuilder,
    super.disabledItemFn,
    super.onDismissed,
    super.emptyBuilder,
    super.errorBuilder,
    super.loadingBuilder,
    super.showSelectedItems,
    super.containerBuilder,
    super.constraints = const BoxConstraints(maxHeight: 500),
    super.interceptCallBacks,
    super.infiniteScrollProps,
    super.onItemsLoaded,
    //multi selection props
    super.onItemAdded,
    super.onItemRemoved,
    super.checkBoxBuilder,
    super.validationBuilder,
    super.textDirection = TextDirection.ltr,
  })  : menuProps = const MenuProps(),
        dialogProps = const DialogProps(),
        autoCompleteProps = const AutocompleteProps(),
        modalBottomSheetProps = const ModalBottomSheetProps(),
        super(mode: PopupMode.bottomSheet);

  const MultiSelectionPopupProps.modalBottomSheet({
    this.modalBottomSheetProps = const ModalBottomSheetProps(),
    TextFieldProps super.searchFieldProps = const TextFieldProps(),
    super.fit,
    super.suggestionsProps,
    super.scrollbarProps,
    super.listViewProps,
    super.searchDelay,
    super.itemClickProps,
    super.showSearchBox,
    super.title,
    super.disableFilter,
    super.cacheItems,
    super.itemBuilder,
    super.disabledItemFn,
    super.onDismissed,
    super.emptyBuilder,
    super.errorBuilder,
    super.loadingBuilder,
    super.showSelectedItems,
    super.containerBuilder,
    super.constraints = const BoxConstraints(maxHeight: 500),
    super.interceptCallBacks,
    super.infiniteScrollProps,
    super.onItemsLoaded,
    //multi selection props
    super.onItemAdded,
    super.onItemRemoved,
    super.checkBoxBuilder,
    super.validationBuilder,
    super.textDirection = TextDirection.ltr,
  })  : menuProps = const MenuProps(),
        bottomSheetProps = const BottomSheetProps(),
        dialogProps = const DialogProps(),
        autoCompleteProps = const AutocompleteProps(),
        super(
            mode: PopupMode.modalBottomSheet);
}

class PopupProps<T> extends BasePopupProps<T> {
  ///dialog mode props
  final DialogProps dialogProps;

  ///BottomSheet mode props
  final BottomSheetProps bottomSheetProps;

  ///ModalBottomSheet mode props
  final ModalBottomSheetProps modalBottomSheetProps;

  ///Menu mode props
  final MenuProps menuProps;

  ///Menu mode props
  final AutocompleteProps autoCompleteProps;

  const PopupProps.menu({
    this.menuProps = const MenuProps(),
    TextFieldProps super.searchFieldProps = const TextFieldProps(),
    super.fit,
    super.suggestionsProps,
    super.scrollbarProps,
    super.listViewProps,
    super.searchDelay,
    super.itemClickProps,
    super.showSearchBox,
    super.title,
    super.disableFilter,
    super.cacheItems,
    super.itemBuilder,
    super.disabledItemFn,
    super.onDismissed,
    super.emptyBuilder,
    super.errorBuilder,
    super.loadingBuilder,
    super.showSelectedItems,
    super.containerBuilder,
    super.constraints = const BoxConstraints(maxHeight: 350),
    super.interceptCallBacks,
    super.infiniteScrollProps,
    super.onItemsLoaded,
  })  : bottomSheetProps = const BottomSheetProps(),
        dialogProps = const DialogProps(),
        autoCompleteProps = const AutocompleteProps(),
        modalBottomSheetProps = const ModalBottomSheetProps(),
        super(mode: PopupMode.menu);

  const PopupProps.autocomplete({
    this.autoCompleteProps = const AutocompleteProps(),
    TextFieldProps super.searchFieldProps = const TextFieldProps(),
    super.fit,
    super.suggestionsProps,
    super.scrollbarProps,
    super.listViewProps,
    super.searchDelay,
    super.itemClickProps,
    super.showSearchBox,
    super.title,
    super.disableFilter,
    super.cacheItems,
    super.itemBuilder,
    super.disabledItemFn,
    super.onDismissed,
    super.emptyBuilder,
    super.errorBuilder,
    super.loadingBuilder,
    super.showSelectedItems,
    super.containerBuilder,
    super.constraints = const BoxConstraints(maxHeight: 350),
    super.interceptCallBacks,
    super.infiniteScrollProps,
    super.onItemsLoaded,
  })  : bottomSheetProps = const BottomSheetProps(),
        dialogProps = const DialogProps(),
        menuProps = const MenuProps(),
        modalBottomSheetProps = const ModalBottomSheetProps(),
        super(mode: PopupMode.autocomplete);

  const PopupProps.dialog({
    this.dialogProps = const DialogProps(),
    TextFieldProps super.searchFieldProps = const TextFieldProps(),
    super.fit = FlexFit.tight,
    super.suggestionsProps,
    super.scrollbarProps,
    super.listViewProps,
    super.searchDelay,
    super.itemClickProps,
    super.showSearchBox,
    super.title,
    super.disableFilter,
    super.cacheItems,
    super.itemBuilder,
    super.disabledItemFn,
    super.onDismissed,
    super.emptyBuilder,
    super.errorBuilder,
    super.loadingBuilder,
    super.showSelectedItems,
    super.containerBuilder,
    super.constraints = const BoxConstraints(
      minWidth: 500,
      maxWidth: 500,
      maxHeight: 600,
    ),
    super.interceptCallBacks,
    super.infiniteScrollProps,
    super.onItemsLoaded,
  })  : bottomSheetProps = const BottomSheetProps(),
        menuProps = const MenuProps(),
        autoCompleteProps = const AutocompleteProps(),
        modalBottomSheetProps = const ModalBottomSheetProps(),
        super(mode: PopupMode.dialog);

  const PopupProps.modalBottomSheet({
    this.modalBottomSheetProps = const ModalBottomSheetProps(),
    TextFieldProps super.searchFieldProps = const TextFieldProps(),
    super.fit = FlexFit.tight,
    super.suggestionsProps,
    super.scrollbarProps,
    super.listViewProps,
    super.searchDelay,
    super.itemClickProps,
    super.showSearchBox,
    super.title,
    super.disableFilter,
    super.cacheItems,
    super.itemBuilder,
    super.disabledItemFn,
    super.onDismissed,
    super.emptyBuilder,
    super.errorBuilder,
    super.loadingBuilder,
    super.showSelectedItems,
    super.containerBuilder,
    super.constraints = const BoxConstraints(maxHeight: 500),
    super.interceptCallBacks,
    super.infiniteScrollProps,
    super.onItemsLoaded,
  })  : menuProps = const MenuProps(),
        autoCompleteProps = const AutocompleteProps(),
        dialogProps = const DialogProps(),
        bottomSheetProps = const BottomSheetProps(),
        super(
            mode: PopupMode.modalBottomSheet);

  const PopupProps.bottomSheet({
    this.bottomSheetProps = const BottomSheetProps(),
    TextFieldProps super.searchFieldProps = const TextFieldProps(),
    super.fit = FlexFit.tight,
    super.suggestionsProps,
    super.scrollbarProps,
    super.listViewProps,
    super.searchDelay,
    super.itemClickProps,
    super.showSearchBox,
    super.title,
    super.disableFilter,
    super.cacheItems,
    super.itemBuilder,
    super.disabledItemFn,
    super.onDismissed,
    super.emptyBuilder,
    super.errorBuilder,
    super.loadingBuilder,
    super.showSelectedItems,
    super.containerBuilder,
    super.constraints = const BoxConstraints(maxHeight: 500),
    super.interceptCallBacks,
    super.infiniteScrollProps,
    super.onItemsLoaded,
  })  : menuProps = const MenuProps(),
        autoCompleteProps = const AutocompleteProps(),
        modalBottomSheetProps = const ModalBottomSheetProps(),
        dialogProps = const DialogProps(),
        super(mode: PopupMode.bottomSheet);
}
