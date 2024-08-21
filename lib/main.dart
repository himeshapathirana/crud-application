import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "CRUD APPLICATION",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey, // Use a predefined MaterialColor here
        scaffoldBackgroundColor: Colors.black12,
        primaryColor: const Color.fromARGB(255, 11, 27, 37),
        appBarTheme: const AppBarTheme(
          color: Color.fromARGB(255, 106, 133, 155),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 33, 73, 141),
            foregroundColor: const Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
