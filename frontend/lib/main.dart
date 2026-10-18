import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pc_no_s/feature/Home/home_page.dart';
import 'package:pc_no_s/feature/Todo/todo_page.dart';

import 'core/storage/shared_prefs.dart';
import 'feature/Auth/auth_page.dart';
import 'feature/Symptoms/symptoms_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const pcNOsApp());
}

class pcNOsApp extends StatelessWidget {
  const pcNOsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: Colors.pinkAccent,
        textTheme: GoogleFonts.poppinsTextTheme(),
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthPage(),
        '/symptoms': (context) => const SymptomsPage(),
        '/home': (context) => HomePage(),
        "/todo": (context) => TodoPage()
      },
    );
  }
}
