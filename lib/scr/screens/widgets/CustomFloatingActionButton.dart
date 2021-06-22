import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';

class CustomFloatingActionButton extends StatefulWidget {
  const CustomFloatingActionButton(
      {@required this.labelText,
      @required this.backgroundColor,
      @required this.onPressed,
      @required this.heroTag});
  final GestureTapCallback? onPressed;
  final String? heroTag;
  final String? labelText;
  final Color? backgroundColor;

  @override
  _CustomFloatingActionButtonState createState() =>
      _CustomFloatingActionButtonState();
}

class _CustomFloatingActionButtonState
    extends State<CustomFloatingActionButton> {
  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: NeumorphicStyle(
          surfaceIntensity: 0.7,
          depth: 5,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(0.0)),
          shape: NeumorphicShape.flat,
          lightSource: LightSource.left,
          color: widget.backgroundColor,
          shadowLightColor: widget.backgroundColor,
          intensity: 0.9),
      child: Container(
        height: 30,
        child: FloatingActionButton.extended(
          heroTag: widget.heroTag,
          onPressed: widget.onPressed,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          label: Text(widget.labelText!),
          backgroundColor: widget.backgroundColor,
        ),
      ),
    );
  }
}
