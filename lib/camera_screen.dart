// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_print, library_private_types_in_public_api

import 'dart:io';

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
  late XFile _capturedImage;

  @override
  void initState() {
    super.initState();

    if (widget.cameras.isNotEmpty) {
      _controller = CameraController(
        widget.cameras[0],
        ResolutionPreset.max,
        enableAudio: false,
      );
      _initializeControllerFuture = _initializeController();
    } else {
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
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            // Capture une image et sauvegarde la référence dans _capturedImage
            _capturedImage = await _controller.takePicture();

            // Affiche une boîte de dialogue pour permettre à l'utilisateur de voir la photo et décider s'il veut extraire le texte
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Voulez-vous extraire le texte ?'),
                  content: Image.file(File(_capturedImage.path)),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Ferme la boîte de dialogue
                      },
                      child: Text('Annuler'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigue vers la page de traitement de texte avec l'image capturée
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TextExtractionPage(imagePath: _capturedImage.path),
                          ),
                        );
                      },
                      child: Text('Extraire'),
                    ),
                  ],
                );
              },
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
