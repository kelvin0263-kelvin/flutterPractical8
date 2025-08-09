import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
//TODO - Create a file and an image picker instances

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _image;
  final picker = ImagePicker();
//TODO - Obtain profile image from the Gallery
  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  //TODO - Save the profile image into the app folder
  Future<void> savePicture() async {
    if (_image != null) {
      try {
// Save the image to a specific location
        final appDocDir = await getApplicationDocumentsDirectory();
        final newImagePath = '${appDocDir.path}/profile.png';
        await _image!.copy(newImagePath);
        print('File image copied successfully to $newImagePath');
      } catch (e) {
        print('File error copying image: $e');
      }
    } else {
      AlertDialog(
        title: const Text('Profile Image'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Profile Image'),
              Text('Profile Image file is missing.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    }
  }

  //TODO - Load profile image from the app folder
  Future<void> loadProfileImage() async {
// Get the application documents directory
    final appDocDir = await getApplicationDocumentsDirectory();
    final imagePath = '${appDocDir.path}/profile.png';
// Create the destination file path
    final file = File(imagePath);
    if (await file.exists()) {
      setState(() {
        _image = file;


        print('File path: $imagePath');
      });
    } else {
      print('File not found in $imagePath');
    }
  }
  @override
  void initState() {
    super.initState();
//TODO - Call the loadProfileImage method during app initialization stage
    loadProfileImage();
  }
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

//TODO - Construct the main UI
            _image == null
                ? Image.asset(
              'assets/profile.png',
              width: 150,
              height: 150,
            )
                : Image.file(
              _image!,
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 8.0,),
            IconButton(
              icon: const Icon(Icons.edit),
              color: Colors.grey,
              onPressed: () {
                getImageFromGallery();
              },
            ),
            const SizedBox(height: 8.0,),
            ElevatedButton(
              onPressed: () {
                savePicture();
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile image saved.')));
              },
              child: const Text('Save'),
            ),




          ],
        ),
      ),
    );
  }
}
