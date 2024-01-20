import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'camera_screen.dart';


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
      title: 'Text Recognition App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(cameras: cameras),
      routes: {
        '/camera': (context) => CameraScreen(cameras: cameras),
      },
    );
  }
}
class HomePage extends StatelessWidget {
  final List<CameraDescription> cameras;

  const HomePage({Key? key, required this.cameras}) : super(key: key);

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Vous pouvez maintenant utiliser pickedFile.path pour accéder au chemin de l'image sélectionnée
      print('Image sélectionnée: ${pickedFile.path}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Bienvenue sur la HomePage!"),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/camera', arguments: cameras);
              },
              icon: Icon(Icons.camera),
              label: Text("Aller à la caméra"),
              style: ElevatedButton.styleFrom(primary: Colors.blue),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickImageFromGallery,
              icon: Icon(Icons.photo),
              label: Text("Sélectionner une photo"),
              style: ElevatedButton.styleFrom(primary: Colors.orange),
            ),
          ],
        ),
      ),
    );
  }
}