import 'dart:async';

import 'package:cheapnear/animations/bottomAnimation.dart';
import 'package:cheapnear/helper/enum.dart';
import 'package:cheapnear/screens/home.dart';
import 'package:cheapnear/screens/login.dart';
import 'package:cheapnear/states/authState.dart';
import 'package:cheapnear/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

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
        Duration(seconds:8),
            (){
          var state = Provider.of<AuthState>(context, listen: false);
          // state.authStatus = AuthStatus.NOT_DETERMINED;
          state.getCurrentUser();
          // Navigator.pushReplacement(
          //     context, MaterialPageRoute(builder: (context) => Login()));
        }
    );
  }
Widget _body(){
    return SingleChildScrollView(
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
    );
}
  @override
  Widget build(BuildContext context) {


    var state = Provider.of<AuthState>(context);
    return Scaffold(
       body:  state.authStatus == AuthStatus.NOT_DETERMINED
           ? _body()
           : state.authStatus == AuthStatus.NOT_LOGGED_IN
           ? Login()
           : HomeScreen(),
    );
  }
}
