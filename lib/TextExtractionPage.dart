// ignore_for_file: file_names, prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:share/share.dart';
import 'package:translator/translator.dart';

class TextExtractionPage extends StatelessWidget {
  final String imagePath;

  const TextExtractionPage({Key? key, required this.imagePath})
      : super(key: key);

  Future<String> extractText() async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final textRecognizer = GoogleMlKit.vision.textRecognizer();
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    String extractedText = '';
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        extractedText += '${line.text}\n';
      }
    }

    textRecognizer.close();

    return extractedText;
  }

  Future<String> translateText(String text, String targetLanguage) async {
    final translator = GoogleTranslator();
    final translation =
        await translator.translate(text, from: 'auto', to: targetLanguage);
    return translation.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Extraction'),
        actions: [
          IconButton(
            icon: Icon(Icons.copy),
            onPressed: () async {
              final text = await extractText();
              Clipboard.setData(ClipboardData(text: text));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Texte copié dans le presse-papiers')),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () async {
              final text = await extractText();
              Share.share(text);
            },
          ),
          IconButton(
            icon: Icon(Icons.translate),
            onPressed: () async {
              final text = await extractText();
              final translatedText = await translateText(text, 'fr'); // Remplacez 'fr' par la langue cible souhaitée
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Texte traduit'),
                    content: Text(translatedText),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<String>(
        future: extractText(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: 200.0, // Ajustez la hauteur maximale selon vos besoins
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.blue,
                    width: 2.0,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      snapshot.data ?? 'Aucun texte extrait.',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
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
