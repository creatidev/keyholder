import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';

class CustomRoundedButton extends StatefulWidget {
  const CustomRoundedButton(
      {@required this.onPressed,
      @required this.heroTag,
      this.labelText,
      this.backgroundColor,
      this.intensity,
      this.shadowLightColor,
      this.textColor});

  final GestureTapCallback? onPressed;
  final String? heroTag;
  final String? labelText;
  final Color? backgroundColor;
  final int? intensity;
  final Color? shadowLightColor;
  final Color? textColor;
  @override
  _CustomRoundedButtonState createState() => _CustomRoundedButtonState();
}

class _CustomRoundedButtonState extends State<CustomRoundedButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        height: 80,
        width: 80,
        child: Neumorphic(
          style: NeumorphicStyle(
            shape: NeumorphicShape.convex,
            boxShape: NeumorphicBoxShape.circle(),
            depth: 9,
            lightSource: LightSource.topLeft,
            color: widget.backgroundColor,
          ),
          child: Text(widget.labelText!),
        ),
      ),
    );
  }
}
