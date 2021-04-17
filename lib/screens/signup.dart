import 'dart:math';

import 'package:cheapnear/animations/bottomAnimation.dart';
import 'package:cheapnear/helper/constant.dart';
import 'package:cheapnear/helper/enum.dart';
import 'package:cheapnear/model/user.dart';
import 'package:cheapnear/screens/home.dart';
import 'package:cheapnear/screens/login.dart';
import 'package:cheapnear/states/authState.dart';
import 'package:cheapnear/utils/constants.dart';
import 'package:cheapnear/widgets/customWidgets.dart';
import 'package:cheapnear/widgets/newWidget/customLoader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool show = true;
  TextEditingController name=TextEditingController(),email=TextEditingController(),password=TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  CustomLoader loader;
  @override
  void initState() {

    loader = CustomLoader();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: ListView(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.10,),
          WidgetAnimator(Image.asset("assets/logo.png",height: 150,width: 150,)),
          SizedBox(height: 50,),
          WidgetAnimator(
            Padding(
              padding: const EdgeInsets.only(left:20.0,right: 20.0),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextField(
                    controller: name,
                    cursorColor: primary,
                    style: TextStyle(
                        color: primary
                    ),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.person),
                        hintText: "Enter your name",
                        labelStyle: TextStyle(
                            color: primary
                        )
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
          WidgetAnimator(
            Padding(
              padding: const EdgeInsets.only(left:20.0,right: 20.0),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextField(
                    cursorColor: primary,
                    controller: email,
                    style: TextStyle(
                        color: primary
                    ),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.mail),
                        hintText: "Enter your email",
                        labelStyle: TextStyle(
                            color: primary
                        )
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
          WidgetAnimator(
            Padding(
              padding: const EdgeInsets.only(left:20.0,right: 20.0),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextField(
                    controller: password,
                    obscureText: show,
                    cursorColor: primary,
                    style: TextStyle(
                        color: primary
                    ),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.security),
                        hintText: "Enter your password",
                        labelStyle: TextStyle(
                            color: primary
                        ),
                        suffixIcon: IconButton(
                          onPressed: (){
                            setState(() {
                              show = !show;
                            });
                          },
                          icon: Icon(show ? Icons.visibility_off : Icons.visibility),
                        )
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20,),
          WidgetAnimator(
            Padding(
              padding: const EdgeInsets.only(left:28.0,right: 28.0),
              child: RaisedButton(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  color: primary,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("SignUp",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w900),),
                  ),
                  onPressed: (){
                    _submitForm();

                  }),
            ),
          ),
          SizedBox(height: 50,),
          WidgetAnimator(
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap:(){
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));

                    },
                    child: Text("Have An Account? Login",style: TextStyle(color: primary,fontSize: 18,fontWeight: FontWeight.w900),))
              ],
            ),
          )
        ],
      ),
    );
  }


  void _submitForm() {
    if (email.text.isEmpty) {
      customSnackBar(_scaffoldKey, 'Please enter name');
      return;
    }
    if (email.text.length > 27) {
      customSnackBar(_scaffoldKey, 'Name length cannot exceed 27 character');
      return;
    }
    if (email.text == null ||
        email.text.isEmpty ||
        password.text == null ||
        password.text.isEmpty ||name.text==null||name.text.isEmpty) {
      customSnackBar(_scaffoldKey, 'Please fill form carefully');
      return;
    }

    loader.showLoader(context);
    var state = Provider.of<AuthState>(context, listen: false);
    Random random = new Random();
    int randomNumber = random.nextInt(8);

    UserModel user = UserModel(
      email: email.text.toLowerCase(),
      bio: 'Edit profile to update bio',
      // contact:  _mobileController.text,
      displayName:name.text,
      dob: DateTime(1950, DateTime.now().month, DateTime.now().day + 3)
          .toString(),
      location: 'Somewhere in universe',
      profilePic: dummyProfilePicList[randomNumber],
      isVerified: false,
    );
    state
        .signUp(
      user,
      password: password.text,
      scaffoldKey: _scaffoldKey,
    )
        .then((status) {
      print(status);
    }).whenComplete(
          () {
        loader.hideLoader();
        if (state.authStatus == AuthStatus.LOGGED_IN) {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
              HomeScreen()), (Route<dynamic> route) => false);

          // widget.loginCallback();
        }
      },
    );
  }
}
