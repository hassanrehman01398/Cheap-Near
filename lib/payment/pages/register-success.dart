import 'package:cheapnear/payment/app-state.dart';
import 'package:cheapnear/payment/router/pages_config.dart';
import 'package:cheapnear/states/authState.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterSuccessPage extends StatefulWidget {
  @override
  _RegisterSellerState createState() => _RegisterSellerState();
}

class _RegisterSellerState extends State<RegisterSuccessPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PageConfiguration routeArgs = ModalRoute.of(context).settings.arguments as PageConfiguration;
    Map<String, dynamic> extras = routeArgs.extras as Map<String, dynamic>;
    final appState = Provider.of<AppState>(context, listen: false);
    final authstate = Provider.of<AuthState>(context, listen: false);
    Future.delayed(Duration(seconds: 1), () {
      appState.accountId = extras['account_id'];
      print("account id");
      print(appState.accountId);
      authstate.userModel.sellerId=appState.accountId;
      authstate.updateUserProfile(authstate.userModel);
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("Register as Seller"),
      ),
      body: Center(
        child: Text('Registration Successful'),
      ),
    );
  }
}
