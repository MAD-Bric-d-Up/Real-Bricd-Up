import 'package:flutter/material.dart';

class PostData extends StatelessWidget {
  const PostData({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Stu Dent'),
            Text('student1@cpp.edu'),
            const SizedBox(
              height: 10,
            ),
             Text('Gym bro blah blah blah weights protein gains rahhhhhhhhhhhhhhhhh'
            ),
            Row(
              children: [
                IconButton(
                  onPressed: (){}, 
                  icon: Icon(Icons.thumb_up),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.message),
                  ),
              ],
            )
          ],
        ),
      );
  }
}