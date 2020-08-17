import 'package:flutter/material.dart';
import 'package:image_to_pdf/home_page.dart';
import 'package:animated_splash/animated_splash.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: AnimatedSplash(
        imagePath: 'lib/assets/splashPDF.png',
        home: HomePage(),
        duration: 2500,
        type: AnimatedSplashType.StaticDuration,
      ),
    );
  }
}
