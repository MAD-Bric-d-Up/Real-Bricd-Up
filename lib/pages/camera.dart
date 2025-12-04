import 'dart:io';

import 'package:bricd_up/constants/app_colors.dart';
import 'package:bricd_up/services/firestore_service.dart';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:developer';

class Camera extends StatefulWidget {
  final CameraDescription camera;

  const Camera({super.key, required this.camera});

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  late List<CameraDescription> _cameras;
  bool _isLoading = true;



  @override
  void initState() {
    super.initState();
    _loadCameras();
      _controller = CameraController(
        widget.camera,
        ResolutionPreset.medium,
      );
    _initializeControllerFuture = _controller.initialize();
  }

  Future<void> _loadCameras() async {
    try {
      final cameras = await availableCameras();

      setState(() {
        _cameras = cameras;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        print('Camera Error.');
        _isLoading = false;
      });
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
      backgroundColor: AppColors.primaryGreen,
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CameraPreview(_controller),

                  const SizedBox(height: 32.0),

                  FloatingActionButton(
                    onPressed: _takePicture,
                    heroTag: 'camera-fab',
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.camera_alt, color: Colors.black,)
                  )
                ],
              )
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      )
    );
  }

  void _takePicture() async {
    try {

      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      final Uint8List imageData = await image.readAsBytes();

      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => DisplayPictureScreen(
            imagePath: image.path,
            data: imageData,
          ),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final Uint8List data;

  const DisplayPictureScreen({super.key, required this.imagePath, required this.data});

  // void _submitPicture() async {
  //   String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
  //
  //   Reference storageRef = FirebaseStorage.instance.ref();
  //   FirebaseAuth.instance.authStateChanges().listen((User? user) async {
  //     if (user == null) return;
  //     Reference referenceDirImages = storageRef.child('images/${user.uid}');
  //     Reference imageToUpload = referenceDirImages.child('$uniqueFileName.jpg');
  //     await imageToUpload.putData(data, SettableMetadata(contentType: "image/jpeg"));
  //
  //     final downloadUrl = await imageToUpload.getDownloadURL();
  //
  //     FirestoreService.instance.createImageDatabaseEntry(user.uid, downloadUrl);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    if(kIsWeb) {
      return Scaffold(
        backgroundColor: AppColors.primaryGreen,
        appBar: AppBar(title: Text('Upload Picture?')),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:
            <Widget>[
              Image.network(imagePath),
              const SizedBox(height: 32.0),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [FilledButton(
                  onPressed: () {Navigator.pop(context);},
                  style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.white)),
                  child: Text("Cancel", style: TextStyle(color: Colors.black),)
              ),
              FilledButton(
                onPressed: () {
                  String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

                  Reference storageRef = FirebaseStorage.instance.ref();
                  FirebaseAuth.instance.authStateChanges().listen((User? user) async {
                    if (user == null) return;
                    Reference referenceDirImages = storageRef.child('images/${user.uid}');
                    Reference imageToUpload = referenceDirImages.child('$uniqueFileName.jpg');
                    await imageToUpload.putData(data, SettableMetadata(contentType: "image/jpeg"));

                    final downloadUrl = await imageToUpload.getDownloadURL();

                    FirestoreService.instance.createImageDatabaseEntry(user.uid, downloadUrl);
                  });
                  Navigator.pop(context);
                },
                style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.green)),
                child: Text("Submit"),
              )
              ]),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(title: Text('Upload Picture?')),
        body:
        Image.file(File(imagePath)),
      );
    }
  }
}