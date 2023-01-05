import 'package:flutter/material.dart';
import 'package:get/get.dart';

//Controller
import '../controllers/auth.dart';
//SCreens
import '../views/splash_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.8,
      child: Drawer(
        child: Column(
          children: [
            SizedBox(
              height: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top,
            ),
            drawerItemBuilder(
              Icons.person,
              'Profile',
              () {},
            ),
            drawerItemBuilder(
              Icons.share,
              'Tell a friend',
              () {},
            ),
            const Spacer(),
            drawerItemBuilder(
              Icons.logout,
              'Logout',
              () async {
                await authController.signOut();
                Get.offAllNamed(SplashScreen.routeName);
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget drawerItemBuilder(
    IconData icon,
    String title,
    Function() onPressed,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 12,
      ),
      child: InkWell(
        onTap: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 25,
            ),
            const SizedBox(width: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
