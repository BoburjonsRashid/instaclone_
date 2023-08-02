import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/services/db_service.dart';

import '../model/post_model.dart';
import '../services/utils_service.dart';

class LikePage extends StatefulWidget {
  const LikePage({super.key});

  @override
  State<LikePage> createState() => _LikePageState();
}

class _LikePageState extends State<LikePage> {
  bool isLoading = false;
  List<Post> items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiLoadLike();
  }

  void _apiLoadLike() {
    setState(() {
      isLoading = true;
    });
    DBService.loadLikes().then((value) => {_reLoadPost(value)});
  }

  void _reLoadPost(List<Post> posts) {
    setState(() {
      items = posts;
      isLoading = false;
    });
  }

  void _apiPostUnLike(Post post) {
    setState(() {
      isLoading = true;
      post.liked = false;
    });
    DBService.likePost(post, false).then((value) => {_apiLoadLike()});
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'Likes',
            style: TextStyle(
              fontSize: 30,
              fontFamily: 'Billabong',
            ),
          ),
        ),
        body: Stack(
          children: [
            ListView.builder(
                itemCount: items.length,
                itemBuilder: (ctx, index) {
                  return _itemOfPost(items[index]);
                }),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : SizedBox.shrink(),
          ],
        ));
  }
  _dialogRemovePost(Post post) async {
    var result = await Utils.dialogCommon(
        context, "Insta Clone", "Do you want to remove this post?", false);
    if (result != null && result) {
      setState(() {
        isLoading = true;
      });
      DBService.removePost(post).then((value) => {
        _apiLoadLike(),
      });
    }
  }



  Widget _itemOfPost(Post post) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          //  Divider(),
          //user info
          Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: post.img_user!.isEmpty
                              ? Image(
                                  image:
                                      AssetImage("assets/images/ic_person.png"),
                                  width: 40,
                                  height: 40,
                                )
                              : Image.network(
                                  post.img_user!,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                )),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.fullname!,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black), // TextStyle
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(post.date!,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                              )),
                        ],
                      ), //
                    ],
                  ),
                  post.mine
                      ?SizedBox.shrink(): IconButton(
                          onPressed: () {_dialogRemovePost(post);}, icon: Icon(Icons.more_horiz))

                ],
              )),
          //post image
          SizedBox(
            height: 2,
          ),
          CachedNetworkImage(
            width: MediaQuery.of(context).size.width,
            imageUrl: post.img_post!,
            placeholder: (context, url) => Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
            fit: BoxFit.cover,
          ),
          //like share
          Row(
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        _apiPostUnLike(post);
                      },
                      icon: post.liked
                          ? Icon(
                              EvaIcons.heart,
                              color: Colors.red,
                            )
                          : Icon(
                              EvaIcons.heartOutline,
                              color: Colors.black,
                            )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        EvaIcons.share,
                      )),
                ],
              )
            ],
          ),
          //caption
          Container(
            margin: EdgeInsets.only(right: 10, top: 3, left: 10),
            width: MediaQuery.of(context).size.width,
            child: RichText(
              softWrap: true,
              overflow: TextOverflow.visible,
              text: TextSpan(
                  text: "${post.caption}",
                  style: TextStyle(color: Colors.black)),
            ),
          ),
          SizedBox(
            height: 15,
          )
        ],
      ),
    );
  }
}
