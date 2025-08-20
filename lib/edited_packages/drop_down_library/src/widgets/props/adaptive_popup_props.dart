// Project imports:
import 'package:oda/edited_packages/drop_down_library/src/popups/props/material_popup_props.dart';
import 'cupertino_popup_props.dart';

class AdaptiveMultiSelectionPopupProps<T> {
  ///Cupertino popup props
  final MultiSelectionPopupProps<T> materialProps;

  ///material mode props
  final CupertinoMultiSelectionPopupProps<T> cupertinoProps;

  const AdaptiveMultiSelectionPopupProps({
    this.materialProps = const MultiSelectionPopupProps.menu(),
    this.cupertinoProps = const CupertinoMultiSelectionPopupProps.menu(),
  });
}

class AdaptivePopupProps<T> {
  ///Cupertino popup props
  final PopupProps<T> materialProps;

  ///material mode props
  final CupertinoPopupProps<T> cupertinoProps;

  const AdaptivePopupProps({
    this.materialProps = const PopupProps.menu(),
    this.cupertinoProps = const CupertinoPopupProps.menu(),
  });
}
