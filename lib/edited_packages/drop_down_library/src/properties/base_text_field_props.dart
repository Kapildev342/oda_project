// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:oda/edited_packages/drop_down_library/src/base_dropdown_search.dart';

abstract class BaseTextFieldProps {
  final TextEditingController? controller;
  final ContainerBuilder? containerBuilder;

  const BaseTextFieldProps({
    this.controller,
    this.containerBuilder,
  });
}
