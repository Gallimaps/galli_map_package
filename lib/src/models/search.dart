import 'package:flutter/material.dart';
import 'package:galli_map/src/models/auto_complete.dart';

class SearchClass {
  final String? searchHint;
  final double? searchHeight;
  final double? searchWidth;
  final double? fromRight;
  final double? fromLeft;
  final double? fromTop;
  final double? fromBottom;
  final double? borderRadius;
  final Color? iconColor;
  final Widget? backWidget;
  final Widget? suffixWidget;
  final Widget? closeWidget;
  final TextStyle? textStyle;
  final double? cursorHeight;
  final Color? cursorColor;
  final Function(AutoCompleteModel autoCompleteData)? onTapAutoComplete;

  SearchClass({
    this.searchHint = "Find Places",
    this.searchHeight,
    this.searchWidth,
    this.onTapAutoComplete,
    this.fromLeft,
    this.fromRight,
    this.fromTop,
    this.fromBottom,
    this.borderRadius,
    this.iconColor,
    this.backWidget,
    this.closeWidget,
    this.suffixWidget,
    this.textStyle,
    this.cursorHeight,
    this.cursorColor,
  });
}
