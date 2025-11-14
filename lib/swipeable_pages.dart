import 'package:bricd_up/components/appbar.dart';
import 'package:bricd_up/components/navbar.dart';
import 'package:bricd_up/pages/camera.dart';
import 'package:bricd_up/pages/feed.dart';
import 'package:bricd_up/pages/forum.dart';
import 'package:bricd_up/pages/profile.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class SwipeablePages extends StatefulWidget {
  const SwipeablePages({super.key});

  @override
  State<SwipeablePages> createState() => _SwipeablePages();
}

class _SwipeablePages extends State<SwipeablePages> with SingleTickerProviderStateMixin {

  late TabController _tabController;
  final int _tabCount = 4;

  CameraDescription? _firstCamera;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabCount, vsync: this);
    _loadCameras();
  }

  Future<void> _loadCameras() async {
    try {
      final cameras = await availableCameras();

      setState(() {
        _firstCamera = cameras.first;
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
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: const CustomAppBar(),
        bottomNavigationBar: Navbar(tabController: _tabController),
        body: TabBarView(
          controller: _tabController,
          children: [
            Feed(),
            Forum(),
            Camera(camera: _firstCamera!,),
            Profile(),
          ]
        ),
      )
    );
  }
}