import 'package:bricd_up/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'widgets/post_field.dart';
import 'widgets/post_data.dart';

class Forum extends StatefulWidget {
  const Forum({super.key});

  @override
  State<Forum> createState() => _Forum();
}

class _Forum extends State<Forum> {

  final TextEditingController _postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryGreen,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PostField(
                hintText: 'Hello Fellow Gym Goers...',
                controller: _postController,
              ),
               const SizedBox(
                height: 10,
              ),
               ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBeige,
                  elevation: 0, 
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 10,
                  ),
                ),
                onPressed: () {}, 
               child: const Text('Post')
               ),
              const SizedBox(height: 30,),
              Text('Posts'),
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: PostData(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: PostData(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: PostData(),
              ),
            ],
          ),
        ),
      ),
    );
  } 
}