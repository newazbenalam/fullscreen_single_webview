import 'package:flutter/material.dart';
import 'package:fullscreen_single_webview/features/home/presentation/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fullscreen WebViews',
      theme: ThemeData(scaffoldBackgroundColor: Colors.black),
      home: const WebviewPage(),
    );
  }
}
