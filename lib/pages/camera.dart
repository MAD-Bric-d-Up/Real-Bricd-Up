import 'dart:convert';
import 'dart:io';

import 'package:bricd_up/constants/app_colors.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

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

      print('${image?.path}');

      if(image == null) return;

      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

      Reference storageRef = FirebaseStorage.instance.ref();
      Reference referenceDirImages = storageRef.child('images');

      Reference imageToUpload = referenceDirImages.child('${uniqueFileName}.jpg');

      imageToUpload.putFile(File(image.path));

      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => DisplayPictureScreen(
            imagePath: image.path,
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


  const DisplayPictureScreen({super.key, required this.imagePath});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}