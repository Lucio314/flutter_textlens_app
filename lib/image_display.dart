// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';

class ImageDisplay extends StatelessWidget {
  final String imagePath;

  const ImageDisplay({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image Capturée')),
      body: Center(
        child: Image.file(File(imagePath)),
      ),
    );
  }
}
