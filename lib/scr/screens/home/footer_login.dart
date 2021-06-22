import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';

class FooterLogin extends StatelessWidget {
  final String? text;
  final String? logo;
  final Color? textColor;
  final Function? funFooterLogin;

  FooterLogin(
      {@required this.text,
      @required this.logo,
      @required this.funFooterLogin,
      @required this.textColor});

  @override
  Widget build(BuildContext context) {
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
                text! + ' ',
                style: NeumorphicStyle(
                  depth: 4, //customize depth here
                  color: textColor, //customize color here
                ),
                textStyle: NeumorphicTextStyle(
                  fontSize: 18, //customize size here

                  // AND others usual text style properties (fontFamily, fontWeight, ...)
                ),
              ),
              Image.asset(logo!, width: 120)
            ],
          ),
        ),
      ),
    );
  }
}
