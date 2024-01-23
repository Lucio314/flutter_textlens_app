// ignore_for_file: use_build_context_synchronously, avoid_print, prefer_const_constructors, sort_child_properties_last

import 'dart:async';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_textlens_app/TextExtractionPage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  final List<CameraDescription> cameras;

  const HomePage({Key? key, required this.cameras}) : super(key: key);

  Future<void> _pickImageFromGallery(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      print('Image sélectionnée: ${pickedFile.path}');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TextExtractionPage(imagePath: pickedFile.path),
        ),
      );
    } else {
      print('Aucune image sélectionnée.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Text Snap App",
          style: GoogleFonts.satisfy(
              fontSize: 30, fontWeight: FontWeight.normal, color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          CustomPaint(
            painter: CirclesPainter(),
            child: Container(),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Text Snap!",
                  style: GoogleFonts.satisfy(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlueAccent,
                  ),
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/camera',
                            arguments: cameras);
                      },
                      child: Icon(Icons.camera_alt),
                      backgroundColor: Colors.lightBlueAccent.withOpacity(0.4),
                    ),
                    FloatingActionButton(
                      onPressed: () => _pickImageFromGallery(context),
                      child: Icon(Icons.photo_library),
                      backgroundColor: Colors.lightBlueAccent.withOpacity(0.4),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CirclesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255).withOpacity(1)
      ..style = PaintingStyle.stroke;

    var random = Random();

    for (int i = 0; i < 20; i++) {
      double x = random.nextDouble() * size.width;
      double y = random.nextDouble() * size.height;

      double radius = random.nextDouble() * 80 + 10; // Rayon entre 10 et 40

      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    final paint1 = Paint()
      ..color = Color.fromARGB(255, 255, 255, 255).withOpacity(0.98)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 12; i++) {
      double x = random.nextDouble() * size.width;
      double y = random.nextDouble() * size.height;

      double radius = random.nextDouble() * 80 + 10; //entre 10 et 90

      canvas.drawCircle(Offset(x, y), radius, paint1);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
   
    throw UnimplementedError();
  }
}
