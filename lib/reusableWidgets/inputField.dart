import 'package:flutter/material.dart';
import 'package:thelauncher/reusableWidgets/neumorphicContainer.dart';

import '../main.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool autoFocus;
  final String hintText;
  final Function(String input) onSubmitted;
  final Function(String input) onChanged;
  final Function() onTap;
  final bool obscureText;
  final String title;
  final bool allowMultipleLines;
  final Color color;
  final Widget action;
  final bool readOnly;
  final bool showCursor;
  const InputField({
    Key key,
    this.controller,
    this.focusNode,
    this.hintText,
    this.onSubmitted,
    this.obscureText = false,
    this.onChanged,
    this.title,
    this.allowMultipleLines = false,
    this.onTap,
    this.action,
    this.color,
    this.readOnly = false,
    this.showCursor = true,
    this.autoFocus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeumorphicContainer(
      backgroundColor: color,
      bevel: 20.0,
      style: Style.emboss,
      margin: const EdgeInsets.all(15.0),
      alignment: Alignment.center,
      padding: EdgeInsets.zero,
      width: width(context),
      height: width(context) * 0.15,
      borderRadius: BorderRadius.circular(50.0),
      child: Material(
        color: Colors.transparent,
        child: TextField(
          onTap: () {
            if (onTap != null) {
              onTap();
            }
          },
          readOnly: readOnly,
          showCursor: showCursor,
          autofocus: autoFocus,
          obscureText: obscureText,
          controller: controller,
          maxLines: allowMultipleLines ? null : 1,
          focusNode: focusNode,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.0,
            decorationThickness: 0.0,
            decorationColor: Theme.of(context).accentColor,
          ),
          cursorColor: Theme.of(context).primaryColor,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 15.0,
            ),
            labelText: title != null ? title : "",
            labelStyle: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 15.0,
            ),
            border: InputBorder.none,
            hintText: hintText != null ? hintText : "",
            hintStyle: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 15.0,
            ),
          ),
          onSubmitted: onSubmitted,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
