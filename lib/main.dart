import 'package:flutter/material.dart';
import 'package:ppkd_flutter/constant/app_color.dart';
import 'package:ppkd_flutter/view/login_screen.dart';
import 'package:ppkd_flutter/view/main_screen.dart';
import 'package:ppkd_flutter/view/profile_screen.dart';
import 'package:ppkd_flutter/view/register_screen.dart';
import 'package:ppkd_flutter/view/splash_screen.dart';
import 'package:ppkd_flutter/view/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: {
        '/': (context) => SplashScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        MainScreen.id: (context) => MainScreen(),
        ProfileScreen.id: (context) => ProfileScreen(),
      },
      title: 'Resto Reservation',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColor.blackMain,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // home: const LoginScreen(),
    );
  }
}
