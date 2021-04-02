import 'dart:async';

import 'package:cheapnear/animations/bottomAnimation.dart';
import 'package:cheapnear/screens/login.dart';
import 'package:cheapnear/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
        Duration(seconds: 5),
            (){
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: SingleChildScrollView(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.center,
           children: [
             SizedBox(height: MediaQuery.of(context).size.height * 0.36,),
             WidgetAnimator(Image.asset("assets/logo.png",height: 150,width: 150,)),
             SizedBox(height: 30,),
             WidgetAnimator(SpinKitRipple(color: primary,))
           ],
         ),
       ),
    );
  }
}
