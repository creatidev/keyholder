import 'package:flutter/material.dart';

class OptionsPage extends StatefulWidget {
  const OptionsPage({Key? key}) : super(key: key);

  @override
  _OptionsPageState createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        color: Colors.deepPurpleAccent,
        height: 600,
        child: Column(
          children: [
            Center(child: Icon(Icons.pie_chart, size: 64.0, color: Colors.blue)),
            Center(child: Icon(Icons.pie_chart, size: 64.0, color: Colors.blue)),
          ],
        ),
      ),
    );
  }
}
