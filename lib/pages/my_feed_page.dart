import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/services/db_service.dart';

import '../model/post_model.dart';
import '../services/utils_service.dart';

class FeedPage extends StatefulWidget {
  final PageController? pageController;
  const FeedPage({super.key, this.pageController});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  bool isLoading = false;
  List<Post> items = [];

  _apiLoadFeeds() {
    setState(() {
      isLoading = true;
    });
    DBService.loadFeeds().then((value) => {
          _resLoadFeeds(value),
        });
  }

  _resLoadFeeds(List<Post> posts) {
    setState(() {
      items = posts;
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiLoadFeeds();
  }

  _apiPostLiked(Post post) async {
    setState(() {
      isLoading = true;
    });
    await DBService.likePost(post, true);
    setState(() {
      isLoading = false;
      post.liked = true;
    });
  }

  _apiPostUnLiked(post) async {
    setState(() {
      isLoading = true;
    });
    await DBService.likePost(post, false);
    setState(() {
      isLoading = false;
      post.liked = false;
    });
  }
  _dialogRemovePost(Post post) async {
    var result = await Utils.dialogCommon(
        context, "Insta Clone", "Do you want to remove this post?", false);
    if (result != null && result) {
      setState(() {
        isLoading = true;
      });
      DBService.removePost(post).then((value) => {
        _apiLoadFeeds(),
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'Instagram',
            style: TextStyle(
              fontSize: 30,
              fontFamily: 'Billabong',
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  widget.pageController!.animateToPage(2,
                      duration: Duration(microseconds: 200),
                      curve: Curves.easeIn);
                },
                icon: Icon(
                  Icons.camera_alt,
                  color: Color.fromRGBO(193, 53, 132, 1),
                ))
          ],
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

  Widget _itemOfPost(Post post) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          //  Divider(),
          //user info
          Container(
              padding: EdgeInsets.all(3),
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
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                post.img_user!,
                                width: 45,
                                height: 45,
                                fit: BoxFit.cover,
                              ),
                      ),
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

                      post.mine? SizedBox.shrink():IconButton(
                          onPressed: () {
                            _dialogRemovePost(post);
                          }, icon: Icon(Icons.more_horiz))

                ],
              )),
          //post image
          SizedBox(
            height: 8,
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
                        if (!post.liked) {
                          _apiPostLiked(post);
                        } else {
                          _apiPostUnLiked(post);
                        }
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
            margin: EdgeInsets.only(right: 10, top: 5, left: 10),
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
            height: 20,
          ),
          Container(width: double.infinity,height: 1,color: Colors.grey,)
        ],
      ),
    );
  }
}
