import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:together/utils/global.colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:together/view/homepage/homepage.dart';
import 'package:together/view/login/login.view.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

class SplashView extends StatelessWidget {
  SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset("assets/splash.json"),
          const SizedBox(height: 50),
          Text(
            'Together',
            style: GoogleFonts.kanit(
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 50,
              ),
            ),
          ),
          Text(
            'Meant to Unite',
            style: GoogleFonts.pacifico(
              textStyle: const TextStyle(
                color: Colors.white54,
                fontSize: 25,
              ),
            ),
          )
        ],
      ),
      nextScreen: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Lottie.asset('assets/haserror.json');
            } else if (snapshot.hasData) {
              return HomePage();
            } else {
              return const LoginView();
            }
          }),
      backgroundColor: GlobalColors.mainColor,
      splashIconSize: 600,
      duration: 6500,
      splashTransition: SplashTransition.decoratedBoxTransition,
      pageTransitionType: PageTransitionType.leftToRight,
    );
  }
}
