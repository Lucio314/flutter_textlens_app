// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_print, library_private_types_in_public_api

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_textlens_app/TextExtractionPage.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraScreen({Key? key, required this.cameras}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    if (widget.cameras.isNotEmpty) {
      _controller = CameraController(
        widget.cameras[0],
        ResolutionPreset.medium,
        enableAudio: false, // Disable audio if not needed
      );
      _initializeControllerFuture = _initializeController();
    } else {
      // Gérer le cas où la liste des caméras est vide, par exemple, afficher un message d'erreur.
      print('Aucune caméra disponible.');
    }
  }

  Future<void> _initializeController() async {
    try {
      await _controller.initialize();
    } catch (e) {
      print('Erreur lors de l\'initialisation du contrôleur de caméra : $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Camera')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Modifiez la partie onPressed dans CameraScreen.dart

        onPressed: () async {
          try {
            await _initializeControllerFuture;
            XFile image = await _controller.takePicture();
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      TextExtractionPage(imagePath: image.path)),
            );
          } catch (e) {
            print(e);
          }
        },

        child: Icon(Icons.camera),
      ),
    );
  }
}
