import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:arya_ediga_app_1v/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:arya_ediga_app_1v/login.dart';
import 'package:arya_ediga_app_1v/navigation.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
          initialData: null,
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Arya Ediga App',
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        home: AnimatedSplashScreen(
          splash: './assets/images/arya_ediga_logo.png',
          duration: 1500,
          splashTransition: SplashTransition.fadeTransition,
          backgroundColor: Colors.white,
          nextScreen: AuthenticationWrapper(),
        ),
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();

    if (user != null) {
      return Navigation();
    }

    return Login();
  }
}
