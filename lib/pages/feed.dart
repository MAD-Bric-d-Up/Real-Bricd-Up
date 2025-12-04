import 'package:bricd_up/constants/app_colors.dart';
import 'package:flutter/material.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {

  late Future<List<Images>> _friendPosts;
  bool _isLoading = false;

  void initState() {
    super.initState();
    // _friendPosts = UserRepo.instance.getFriendPosts(Firebase.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryGreen,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              
              // Generate All Posts
              FutureBuilder<List<Images>>(
                future: _friendPosts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(),);
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'),);
                  } else if (snapshot.hasData) {
                    List<Images> posts = snapshot.data!;
                    return _buildFriendPosts(posts);
                  } else {
                    return const Center();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFriendPosts() {
    if (_isLoading)
  }
}