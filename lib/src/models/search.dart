import 'package:flutter/material.dart';
import 'package:galli_map/src/models/auto_complete.dart';

class SearchClass {
  final String? searchHint;
  final double? searchHeight;
  final double? searchWidth;
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
    this.iconColor,
    this.backWidget,
    this.closeWidget,
    this.suffixWidget,
    this.textStyle,
    this.cursorHeight,
    this.cursorColor,
  });
}
