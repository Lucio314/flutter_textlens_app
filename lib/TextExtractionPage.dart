// ignore_for_file: file_names, library_private_types_in_public_api, prefer_const_literals_to_create_immutables, sort_child_properties_last, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:share/share.dart';
import 'package:translator/translator.dart';

class TextExtractionPage extends StatefulWidget {
  final String imagePath;

  const TextExtractionPage({Key? key, required this.imagePath})
      : super(key: key);

  @override
  _TextExtractionPageState createState() => _TextExtractionPageState();
}

class _TextExtractionPageState extends State<TextExtractionPage> {
  late Future<String> extractedText;

  @override
  void initState() {
    super.initState();
    extractedText = extractText();
  }

  Future<String> extractText() async {
    final inputImage = InputImage.fromFilePath(widget.imagePath);
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

  void showTranslationDialog(String translatedText) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Texte traduit'),
          content: Text(translatedText),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choisir la langue de traduction'),
          content: Column(
            children: [
              // Replace the following DropdownButton with your preferred way of selecting the language
              DropdownButton<String>(
                items: [
                  const DropdownMenuItem(
                    child: Text('Français'),
                    value: 'fr',
                  ),
                  const DropdownMenuItem(
                    child: Text('Anglais'),
                    value: 'en',
                  ),
                  const DropdownMenuItem(
                    child: Text('Espagnol'),
                    value: 'es',
                  ),
                ],
                onChanged: (value) {
                  Navigator.of(context).pop(value);
                },
                hint: const Text('Sélectionner la langue'),
              ),
            ],
          ),
        );
      },
    ).then((selectedLanguage) {
      if (selectedLanguage != null) {
        translateAndShow(selectedLanguage);
      }
    });
  }

  void translateAndShow(String targetLanguage) async {
    final text = await extractedText;
    final translatedText = await translateText(text, targetLanguage);
    showTranslationDialog(translatedText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Extraction'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () async {
              final text = await extractedText;
              Clipboard.setData(ClipboardData(text: text));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Texte copié dans le presse-papiers')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              final text = await extractedText;
              Share.share(text);
            },
          ),
          IconButton(
            icon: const Icon(Icons.translate),
            onPressed: () {
              showLanguageDialog();
            },
          ),
        ],
      ),
      body: FutureBuilder<String>(
        future: extractedText,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                constraints: const BoxConstraints(
                  maxHeight: 1200.0,
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
                      style: const TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
