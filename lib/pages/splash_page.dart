import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/pages/signin_pages.dart';
import 'package:instaclone/services/auth_service.dart';


import '../services/log_service.dart';
import '../services/prefs_service.dart';
import 'home_page.dart';


class SplashPage extends StatefulWidget {
  static const String id = 'splash_page';
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initTimer();
    _initNotification();
  }

  _initNotification() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      LogService.d('User granted permission');
    } else {
      LogService.d('User declined or has not accepted permission');
    }
    _firebaseMessaging.getToken().then((value)async{
      String fcmToken=value.toString();
      Prefs.saveFCM(fcmToken);
      String token=await Prefs.loadFCM();
      LogService.i("FCM token:${token}");
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      String title = message.notification!.title.toString();
      String body = message.notification!.body.toString();
      LogService.i(title);
      LogService.i(body);
      LogService.i(message.data.toString());
      //
    });
  }


  initTimer(){
    Timer(Duration(seconds: 3),(){
      _callNextPage();
    });
  }
  _callNextPage(){
    if(AuthService.isLoggedIn()){
      Navigator.pushReplacementNamed(context, HomePage.id);
    }
    else{
      Navigator.pushReplacementNamed(context, SignInPage.id);
    }

  }

  _callSigninPage(){
    Navigator.pushReplacementNamed(context, SignInPage.id);
}
  _callHomePage(){
    Navigator.pushReplacementNamed(context, HomePage.id);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(193, 53, 132, 1),
                  Color.fromRGBO(131, 58, 180, 1),
            ])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
                child:Center(child:Text(
                  'Instagram',
                  style: TextStyle(
                      fontFamily: 'Billabong', color: Colors.white, fontSize: 50),
                ) ,) ),
            Text(
              'All rights reserved',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
