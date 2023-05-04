import 'package:blackcoffer/auth/otp_page.dart';
import 'package:blackcoffer/auth/signIn.dart';
import 'package:blackcoffer/screens/home_page.dart';
import 'package:blackcoffer/screens/video_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/home': (context) => const HomePage(),
        '/otp': (context) => const OTP(),
        '/signIn': (context) => SignIn(),
        '/videoPage': (context) => VideoPage(),
      },
      initialRoute:
          FirebaseAuth.instance.currentUser != null ? '/home' : '/videoPage',
      title: 'Flutter Demo',
      theme: ThemeData.light(useMaterial3: true),
    );
  }
}


