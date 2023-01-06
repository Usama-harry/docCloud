import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

//Screens
import 'views/authentication/auth_screen1.dart';
import 'views/authentication/auth_screen2.dart';
import 'views/splash_screen.dart';
import 'views/home_screen.dart';
import 'views/documents_screen.dart';

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
        fontFamily: 'Roboto',
      ),
      initialRoute: SplashScreen.routeName,
      defaultTransition: Transition.native,
      transitionDuration: const Duration(milliseconds: 300),
      getPages: [
        GetPage(name: AuthScreen1.routeName, page: () => const AuthScreen1()),
        GetPage(name: AuthScreen2.routeName, page: () => const AuthScreen2()),
        GetPage(name: SplashScreen.routeName, page: () => const SplashScreen()),
        GetPage(name: HomeScreen.routeName, page: () => HomeScreen()),
        GetPage(
          name: DocumentsScreen.routeName,
          page: () => const DocumentsScreen(),
        )
      ],
    );
  }
}
