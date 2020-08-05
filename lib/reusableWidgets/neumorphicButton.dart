import 'package:flutter/cupertino.dart';
import 'package:thelauncher/reusableWidgets/neumorphicContainer.dart';

class NeumorphicButton extends StatefulWidget {
  final Widget child;
  final double bevel;
  final Style style;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Alignment alignment;
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final BoxShape shape;
  final Color backgroundColor;
  final Function() onTap;
  final Function() onLongPress;
  final Function() onTapWhileDisabled;
  final bool isEnabled;
  NeumorphicButton({
    Key key,
    this.child,
    this.bevel = 10.0,
    this.style = Style.flat,
    this.padding = const EdgeInsets.all(10.0),
    this.margin = const EdgeInsets.all(10.0),
    this.alignment = Alignment.center,
    this.onTap,
    this.onLongPress,
    this.width,
    this.height,
    this.onTapWhileDisabled,
    this.isEnabled = true,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
    this.backgroundColor,
  }) : super(key: key);

  @override
  _NeumorphicButtonState createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicButton> {
  bool pressed = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        if (pressed == true) {
          return;
        }
        setState(() {
          pressed = true;
        });
      },
      onTapCancel: () {
        if (pressed == false) {
          return;
        }
        setState(() {
          pressed = false;
        });
      },
      onTapUp: (details) {
        if (pressed == false) {
          return;
        }
        setState(() {
          pressed = false;
        });
      },
      onLongPressStart: (details) {
        if (pressed == true) {
          return;
        }
        setState(() {
          pressed = true;
        });
      },
      onLongPressEnd: (details) {
        if (widget.onLongPress == null) {
          if (widget.onTap != null && widget.isEnabled) {
            widget.onTap();
          } else if (widget.onTapWhileDisabled != null && !widget.isEnabled) {
            widget.onTapWhileDisabled();
          }
        }
        if (pressed == false) {
          return;
        }
        setState(() {
          pressed = false;
        });
      },
      onTap: widget.isEnabled
          ? () async {
              if (pressed != true) {
                setState(() {
                  pressed = true;
                });
              }
              await Future.delayed(Duration(milliseconds: 100), () => null);
              if (pressed == true) {
                if (mounted) {
                  setState(() {
                    pressed = false;
                  });
                }
              }
              if (widget.onTap != null) {
                widget.onTap();
              }
            }
          : () {
              if (widget.onTapWhileDisabled != null) {
                widget.onTapWhileDisabled();
              }
            },
      onLongPress: widget.onLongPress,
      child: NeumorphicContainer(
        child: widget.child,
        bevel: widget.bevel * (pressed ? 0.5 : 1.0),
        style: widget.style,
        padding: widget.padding,
        margin: widget.margin,
        alignment: widget.alignment,
        width: widget.width,
        height: widget.height,
        borderRadius: widget.borderRadius,
        shape: widget.shape,
        backgroundColor: widget.backgroundColor,
      ),
    );
  }
}
