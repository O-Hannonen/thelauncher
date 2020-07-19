import 'package:flutter/material.dart';
import 'dart:math' as math;

enum Style {
  concave,
  flat,
  convex,
  emboss,
}

/// Builds a animated container with neumorphic design pattern.
/// You can customize desing with `style` property. If you want
/// to control how much the container pops up you can change `bevel`.
class NeumorphicContainer extends StatelessWidget {
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
  const NeumorphicContainer({
    Key key,
    @required this.child,
    this.bevel = 10.0,
    this.style = Style.flat,
    this.alignment = Alignment.center,
    this.width,
    this.height,
    this.borderRadius,
    this.padding = const EdgeInsets.all(10.0),
    this.margin = const EdgeInsets.all(10.0),
    this.shape = BoxShape.rectangle,
    this.backgroundColor,
  }) : super(key: key);

  Color _adjustColor(Color baseColor, double amount) {
    Map<String, int> colors = {
      'r': baseColor.red,
      'g': baseColor.green,
      'b': baseColor.blue
    };

    colors = colors.map((key, value) {
      if (value + amount < 0) {
        return MapEntry(key, 0);
      }
      if (value + amount > 255) {
        return MapEntry(key, 255);
      }
      return MapEntry(key, (value + amount).floor());
    });
    return Color.fromRGBO(colors['r'], colors['g'], colors['b'], 1);
  }

  Gradient _getFlatGradients(Color baseColor, double depth) => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          baseColor,
          baseColor,
        ],
      );

  Gradient _getConcaveGradients(Color baseColor, double depth) =>
      LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          _adjustColor(baseColor, 0 - depth),
          _adjustColor(baseColor, depth),
        ],
      );

  Gradient _getConvexGradients(Color baseColor, double depth) => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          _adjustColor(baseColor, depth),
          _adjustColor(baseColor, 0 - depth),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final Color color = backgroundColor ?? Theme.of(context).backgroundColor;
    Color colorValue = color;
    final bool emboss = style == Style.emboss;

    List<BoxShadow> shadows = [
      BoxShadow(
        color: _adjustColor(color, bevel * 2),
        offset: Offset(-bevel / 2, -bevel / 2),
        blurRadius: bevel / 2,
      ),
      BoxShadow(
        color: _adjustColor(color, -bevel * 2),
        offset: Offset(bevel / 2, bevel / 2),
        blurRadius: bevel / 2,
      ),
    ];

    if (emboss) {
      shadows = [
        BoxShadow(
          color: _adjustColor(color, bevel),
          offset: Offset(bevel / 4, bevel / 4),
          blurRadius: bevel / 4,
        ),
        BoxShadow(
          color: _adjustColor(color, 0 - bevel),
          offset: Offset(0 - bevel / 6, 0 - bevel / 6),
          blurRadius: bevel / 6,
        ),
      ];

      colorValue = _adjustColor(colorValue, 0 - bevel / 2);
    }

    Gradient gradient;
    switch (style) {
      case Style.concave:
        gradient = _getConcaveGradients(colorValue, bevel);
        break;
      case Style.convex:
        gradient = _getConvexGradients(colorValue, bevel);
        break;
      case Style.emboss:
      case Style.flat:
        gradient = _getFlatGradients(colorValue, bevel);
        break;
    }

    return AnimatedContainer(
      alignment: alignment,
      width: width,
      height: height,
      duration: Duration(
        milliseconds: 100,
      ),
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        shape: shape,
        borderRadius: shape == BoxShape.circle
            ? null
            : borderRadius ?? BorderRadius.circular(15.0),
        gradient: gradient,
        boxShadow: shadows,
      ),
      child: child,
    );
  }
}
