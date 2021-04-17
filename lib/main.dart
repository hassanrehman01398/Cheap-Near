import 'package:cheapnear/screens/splash_screen.dart';
import 'package:cheapnear/states/appState.dart';
import 'package:cheapnear/states/authState.dart';
import 'package:cheapnear/states/chats/chatState.dart';
import 'package:cheapnear/states/searchState.dart';
import 'package:cheapnear/states/servicesState.dart';
import 'package:cheapnear/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AppState>(create: (_) => AppState()),
          ChangeNotifierProvider<AuthState>(create: (_) => AuthState()),
          ChangeNotifierProvider<ChatState>(create: (_) => ChatState()),

          ChangeNotifierProvider<Servicestate>(create: (_) => Servicestate()),
          ChangeNotifierProvider<SearchState>(create: (_) => SearchState()),

          ChangeNotifierProvider(create: (_) => ThemeNotifier())
        ],

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


