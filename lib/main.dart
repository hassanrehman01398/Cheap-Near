import 'package:cheapnear/screens/splash_screen.dart';
import 'package:cheapnear/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ThemeNotifier(),
        child: Consumer<ThemeNotifier>(
          builder: (context,notifier,child){
            return MaterialApp(
              title: 'Cheapnear',
              debugShowCheckedModeBanner: false,
              theme: notifier.darkTheme ? light : dark,
              home: SplashScreen(),
            );
          },
        ),
    );
  }
}


