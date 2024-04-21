import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:navigation_app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set the orientation to portrait only
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const App());
}
