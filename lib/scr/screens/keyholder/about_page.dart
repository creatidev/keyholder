import 'package:digitalkeyholder/scr/config/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:package_info/package_info.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );
  CustomColors _colors = new CustomColors();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        //color: Colors.deepPurpleAccent,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 300,
              //color: Colors.deepPurple,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  NeumorphicText(
                    '${_packageInfo.appName}',
                    style: NeumorphicStyle(
                      color: _colors.textColor(context),
                      intensity: 0.7,
                      depth: 1,
                      shadowLightColor: _colors.shadowTextColor(context),
                    ),
                    textStyle: NeumorphicTextStyle(
                      fontSize: 16,
                    ),
                  ),
                  NeumorphicText(
                    'Versión ${_packageInfo.version}',
                    style: NeumorphicStyle(
                      color: _colors.textColor(context),
                      intensity: 0.7,
                      depth: 1,
                      shadowLightColor: _colors.shadowTextColor(context),
                    ),
                    textStyle: NeumorphicTextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Image.asset('assets/logo_footer.png', width: 250),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.copyright, size: 14, color: Colors.orange,),
                      NeumorphicText(
                        dotenv.get('NAME'),
                        style: NeumorphicStyle(
                          color: _colors.textColor(context),
                          intensity: 0.7,
                          depth: 1,
                          shadowLightColor: _colors.shadowTextColor(context),
                        ),
                        textStyle: NeumorphicTextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  NeumorphicText(
                    'Terminos y condiciones',
                    style: NeumorphicStyle(
                      color: _colors.textColor(context),
                      intensity: 0.7,
                      depth: 1,
                      shadowLightColor: _colors.shadowTextColor(context),
                    ),
                    textStyle: NeumorphicTextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
