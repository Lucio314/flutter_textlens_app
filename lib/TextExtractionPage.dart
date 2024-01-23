// Nouveau fichier text_extraction_page.dart

// ignore_for_file: file_names, prefer_interpolation_to_compose_strings, prefer_const_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class TextExtractionPage extends StatefulWidget {
  final String imagePath;

  const TextExtractionPage({Key? key, required this.imagePath})
      : super(key: key);

  @override
  _TextExtractionPageState createState() => _TextExtractionPageState();
}

class _TextExtractionPageState extends State<TextExtractionPage> {
  late TextEditingController _textEditingController;
  late Future<String> _textExtractionFuture;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _textExtractionFuture = extractText();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Future<String> extractText() async {
    final inputImage = InputImage.fromFilePath(widget.imagePath);
    final textRecognizer = GoogleMlKit.vision.textRecognizer();
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

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
        future: _textExtractionFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            _textEditingController.text = snapshot.data ?? '';
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _textEditingController,
                maxLines: null, // Permet un nombre illimité de lignes.
                expands:
                    true, // Fait en sorte que le champ de texte s'étende sur toute la hauteur disponible.
                textAlignVertical:
                    TextAlignVertical.top, // Alignement du texte en haut.
                decoration: InputDecoration(
                  hintText: 'Éditez le texte extrait...',
                  border: OutlineInputBorder(),
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
