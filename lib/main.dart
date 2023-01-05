import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

//Screens
import './screens/authentication/auth_screen1.dart';
import './screens/authentication/auth_screen2.dart';
import './screens/splash_screen.dart';
import './screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Doc cloud',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      initialRoute: SplashScreen.routeName,
      defaultTransition: Transition.native,
      transitionDuration: const Duration(milliseconds: 300),
      getPages: [
        GetPage(name: AuthScreen1.routeName, page: () => const AuthScreen1()),
        GetPage(name: AuthScreen2.routeName, page: () => const AuthScreen2()),
        GetPage(name: SplashScreen.routeName, page: () => const SplashScreen()),
        GetPage(name: HomeScreen.routeName, page: () => const HomeScreen())
      ],
    );
  }
}
