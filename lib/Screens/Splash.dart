import 'package:flutter/material.dart';


class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SizedBox(
              height: 120,
              width: 200,
              child: Image.asset(
                "asset/seting-Logo-BP.png",
                fit: BoxFit.contain,
              )),
        ));
  }
}
