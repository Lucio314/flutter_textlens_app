// Nouveau fichier text_extraction_page.dart

// ignore_for_file: file_names, prefer_interpolation_to_compose_strings, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class TextExtractionPage extends StatelessWidget {
  final String imagePath;

  const TextExtractionPage({Key? key, required this.imagePath}) : super(key: key);

  Future<String> extractText() async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final textRecognizer = GoogleMlKit.vision.textRecognizer();
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    String extractedText = '';
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        extractedText += line.text + '\n';
      }
    }

    textRecognizer.close();

    return extractedText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Text Extraction')),
      body: FutureBuilder<String>(
        future: extractText(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: Text(snapshot.data ?? 'Aucun texte extrait.'),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
