import 'package:file_converter/pages/History%20Files/history_page.dart';
import 'package:file_converter/pages/HomePage/home_page.dart';
import 'package:file_converter/pages/SignupPage/registration_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:file_converter/pages/IntroPage/intro_page.dart';
import 'package:file_converter/pages/LoginPage/login_page.dart';
import 'package:file_converter/utils/routes.dart';
import 'package:file_converter/widgets/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/Account Setting/account_settings_page.dart';
import 'pages/Cloud Files/cloud_files.dart';

bool show = true;
bool loggedIn = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  show = prefs.getBool('INTRODUCTION') ?? true;
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: MyTheme.lightTheme,
      darkTheme: MyTheme.darkTheme,
      initialRoute: MyRoutes.loginRoute,
      routes: {
        MyRoutes.introRoute: (context) => IntroPage(),
        MyRoutes.loginRoute: (context) => const LoginPage(),
        MyRoutes.registrationRoute: (context) => const RegistrationPage(),
        MyRoutes.homeRoute: (context) => const HomePage(),
        MyRoutes.accountSettingsRoute: (context) => const AccountSettingsPage(),
        MyRoutes.processedFiles: (context) => const HistoryPage(),
        MyRoutes.firebaseFiles: (context) => const CloudFiles(),
      },
    );
  }
}
