import 'package:flutter/material.dart';
import 'package:instaclone/model/post_model.dart';

import '../model/member_model.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({super.key});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  bool isLoading = false;
  int axisCount = 1;
  List<Post> items = [];


  String? fullname = "";
  String? email = "";
  String? img_url = "";
  int? count_posts = 0, count_followers = 0, count_following = 0;

  @override
  Widget build(BuildContext context) {
     return Container(
      child:img_url == null || img_url!.isEmpty
          ? Image(
        image: AssetImage(
            "assets/images/ic_person.png"),
        width: 70,
        height: 70,
        fit: BoxFit.cover,
      )
          : Image.network(
        img_url!,
        width: 70,
        height: 70,
        fit: BoxFit.cover,
      ),
    );
  }
}
