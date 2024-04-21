import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navigation_app/navigation_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation App',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFF8F0),
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: GoogleFonts.gothicA1().fontFamily,
              bodyColor: const Color(0xFF104547),
              displayColor: const Color(0xFF174547),
            ),
        colorScheme: const ColorScheme.light(
          primary: Color.fromARGB(255, 170, 93, 4),
          secondary: Color(0xFF174547),
          tertiary: Color(0xFF68A691),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFFFFF8F0),
          centerTitle: true,
          iconTheme: IconThemeData(
            color: const Color(0xFF174547),
            shadows: [
              Shadow(
                color: const Color(0xFF174547).withOpacity(0.4),
                blurRadius: 2,
                offset: const Offset(1, 2),
              ),
            ],
          ),
        ),
      ),
      home: const NavigationPage(),
    );
  }
}
