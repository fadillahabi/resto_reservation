import 'package:flutter/material.dart';
import 'package:ppkd_flutter/constant/app_color.dart';
import 'package:ppkd_flutter/models/menu_model.dart';
import 'package:ppkd_flutter/view/login_register/login_screen.dart';
import 'package:ppkd_flutter/view/login_register/register_screen.dart';
import 'package:ppkd_flutter/view/main/main_screen.dart';
import 'package:ppkd_flutter/view/main/profile_screen.dart';
import 'package:ppkd_flutter/view/menu/add_menu.dart';
import 'package:ppkd_flutter/view/menu/detail_menu.dart';
import 'package:ppkd_flutter/view/menu/edit_menu.dart';
import 'package:ppkd_flutter/view/menu/menu_screen.dart';
import 'package:ppkd_flutter/view/open/choose_screen.dart';
import 'package:ppkd_flutter/view/open/splash_screen.dart';
import 'package:ppkd_flutter/view/open/welcome_screen.dart';
import 'package:ppkd_flutter/view/reserve/add_reservation.dart';
import 'package:ppkd_flutter/view/reserve/reservation_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        '/': (context) => SplashScreen(),
        '/detail_menu': (context) {
          final menu = ModalRoute.of(context)!.settings.arguments as MenuModel;
          return DetailMenuPage(menu: menu);
        },
        LoginScreen.id: (context) => LoginScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        MainScreen.id: (context) => MainScreen(),
        ProfileScreen.id: (context) => ProfileScreen(),
        ChooseScreen.id: (context) => ChooseScreen(),
        AddMenu.id: (context) => AddMenu(),
        AddReservationPage.id: (context) => AddReservationPage(),
        EditMenuPage.id: (context) {
          final menu = ModalRoute.of(context)!.settings.arguments as MenuModel;
          return EditMenuPage(menu: menu);
        },
        MenuScreen.id: (context) => MenuScreen(),
        ReservationScreen.id: (context) => ReservationScreen(),
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
