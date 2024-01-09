

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectfirst/Models/Posts.dart';

Future<List<Post>> getPosts()async {
  List<Post> posts=[];
    QuerySnapshot postsStream = await FirebaseFirestore.instance
      .collection("Posts")
      .orderBy('TimeStamp', descending: false)
      .get();
    for (var element in postsStream.docs) {
      Map<String, dynamic> map = element.data() as Map<String, dynamic>;
      Post post= Post.fromMap(map);
      post.id = element.id;
      posts.add(post);
    }
  return posts;

}