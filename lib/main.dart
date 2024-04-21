// import 'package:flutter/material.dart';
// import 'package:navigation_app/navigation_page.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Navigation App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const NavigationPage(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:navigation_app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set the orientation to portrait only
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const App());
}
