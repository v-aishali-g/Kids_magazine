// this page is for routing the app to different basic source pages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kids_magazine/delete.dart';
import 'admin.dart';
import 'register.dart';
import 'select.dart';
import 'welcome.dart';

class KidsMagazine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KidsMagazine',
      routes: {
        '/register': (context) => RegisterPage(),
        '/': (context) => WelcomePage(),
        '/select': (context) => SelectLanguage(),
        '/admin': (context) => AdminPage(),
        '/delete': (context) => DeleteAccountPage(),
      },
    );
  }
}
