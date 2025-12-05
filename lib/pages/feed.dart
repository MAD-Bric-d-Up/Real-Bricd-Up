import 'package:bricd_up/constants/app_colors.dart';
import 'package:bricd_up/models/post.dart';
import 'package:bricd_up/repository/user_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {

  late Future<List<Post>> _friendPosts;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _friendPosts = UserRepo.instance.getFriendPosts(FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryGreen,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              
              // Generate All Posts
              FutureBuilder<List<Post>>(
                future: _friendPosts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(),);
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'),);
                  } else if (snapshot.hasData) {
                    List<Post> posts = snapshot.data!;
                    final double screenHeight = MediaQuery.sizeOf(context).height;
                    return _buildFriendPosts(posts, screenHeight);
                  } else {
                    return const Center();
                  }
                },
              ),

              const SizedBox(height: 8.0,),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.stop_circle_outlined),

                  Text(
                    "You've reached the end of your feed!",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFriendPosts(List<Post> posts, double screenHeight) {

    if (_isLoading) {
      return SizedBox(
        width: 50.0,
        height: 50.0,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: posts.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final post = posts[index];
          return Container(
            padding: const EdgeInsets.symmetric(
              vertical: 2.0
            ),
            decoration: BoxDecoration(
              // border: Border.symmetric(
              //   horizontal: BorderSide(
              //     color: Colors.black87,
              //     width: 1.5,
              //   )
              // )
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Column(
                children: [
                  // data above picture
                  Row(
                    children: [
                      Align(
                        alignment: AlignmentGeometry.topLeft,
                        child: Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.black,
                              width: 0.0,
                            )
                          ),
                          child: Icon(Icons.person),
                        ),
                      ),

                      const SizedBox(width: 8.0,),

                      Text(
                        post.username,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white
                        ),
                      ),

                      const Spacer(),

                      Text(
                        post.formattedTime,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      )
                      

                    ],
                  ),

                  const SizedBox(height: 8.0,),

                  // picture
                  if (post.imageURL.isNotEmpty)
                    Image.network(
                      post.imageURL,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return SizedBox(
                          height: 200,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        if (stackTrace != null) print(stackTrace);
                        return SizedBox(
                          height: 200,
                          child: Center(child: Icon(Icons.broken_image, size: 48)),
                        );
                      },
                    )
                  else
                    SizedBox(
                      height: 200,
                      child: Center(child: Icon(Icons.image_not_supported, size: 48)),
                    ),

                  const SizedBox(height: 4.0,),

                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          
                        }, 
                        icon: Icon(Icons.thumb_up),
                        color: Colors.white,
                      ),

                      IconButton(
                        onPressed: () {

                        },
                        icon: Icon(Icons.message),
                        color: Colors.white,
                      ),

                    ],
                  )
                  
                ],
              ),
            )
          );
        }
      );
    }
  }
}