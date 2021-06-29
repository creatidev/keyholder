import 'package:digitalkeyholder/scr/config/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';

class Footer extends StatelessWidget {
  final String? text;
  final String? logo;
  final Color? textColor;
  final Function? funFooterLogin;

  Footer(
      {@required this.text,
      @required this.logo,
      @required this.funFooterLogin,
      @required this.textColor});

  @override
  Widget build(BuildContext context) {
    CustomColors _colors = new CustomColors();
    return Center(
      child: GestureDetector(
        onTap: funFooterLogin!(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NeumorphicText(
                text!,
                style: NeumorphicStyle(
                    color: _colors.iconsColor(context),
                    shape: NeumorphicShape.flat,
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                    shadowLightColor: _colors.shadowColor(context),
                    depth: 1.5,
                    intensity: 0.7),
                textStyle: NeumorphicTextStyle(
                  fontSize: 18, //customize size here

                  // AND others usual text style properties (fontFamily, fontWeight, ...)
                ),
              ),
              Image.asset(logo!, width: 100)
            ],
          ),
        ),
      ),
    );
  }
}
