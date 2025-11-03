import 'package:bricd_up/pages/camera.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:bricd_up/pages/login.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();

  final firstCamera = cameras.first;

  runApp(MaterialApp(
      title: "Bric'd Up!",
      home: Login(),
    )
  );
}