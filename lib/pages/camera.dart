import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class Camera extends StatefulWidget {
  const Camera({super.key, required this.camera});

  final CameraDescription camera;

  @override
  CameraState createState() => CameraState();
}

class CameraState extends State<Camera> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    } catch (e) {
      print(e);
    }
  }

}