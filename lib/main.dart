// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously, sort_child_properties_last, library_private_types_in_public_api

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_textlens_app/splash_screen.dart';
import 'package:flutter_textlens_app/camera_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  List<CameraDescription> cameras = await availableCameras();

  runApp(MyApp(
    cameras: cameras,
  ));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  const MyApp({Key? key, required this.cameras}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Text Snap App',
      theme: ThemeData(
        primaryColor: Colors.lightBlueAccent,
        scaffoldBackgroundColor: Colors.blue,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.lightBlue.withOpacity(0.4),
        ),
      ),
      home: SplashScreen(cameras: cameras),
      routes: {
        '/camera': (context) => CameraScreen(cameras: cameras),
        '/splah':(context)=> SplashScreen(cameras: cameras)
      },
    );
  }
}




