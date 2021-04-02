import 'package:cheapnear/animations/bottomAnimation.dart';
import 'package:cheapnear/utils/constants.dart';
import 'package:cheapnear/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          WidgetAnimator(
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Consumer<ThemeNotifier>(
                builder: (context,notifier,child) => SwitchListTile(
                  activeColor: primary,
                  title: Text("Dark Mode",style: TextStyle(color: notifier.darkTheme ? primary:Colors.white,fontWeight: FontWeight.bold),),
                  onChanged: (val){
                    notifier.toggleTheme();
                    print(notifier.darkTheme);
                  },
                  value: !notifier.darkTheme,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
