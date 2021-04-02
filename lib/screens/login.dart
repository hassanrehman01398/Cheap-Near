import 'package:cheapnear/animations/bottomAnimation.dart';
import 'package:cheapnear/screens/home.dart';
import 'package:cheapnear/screens/signup.dart';
import 'package:cheapnear/utils/constants.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool show = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.15,),
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
                    cursorColor: primary,
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
                    child: Text("Login",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w900),),
                  ),
                  onPressed: (){
                   Navigator.pop(context);
                   Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Signup()));
                    },
                    child: Text("Don't Have An Account? SignUp",style: TextStyle(color: primary,fontSize: 18,fontWeight: FontWeight.w900),))
              ],
            ),
          )
        ],
      ),
    );
  }
}
