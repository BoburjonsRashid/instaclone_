import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/pages/signup_page.dart';


import '../services/auth_service.dart';
import 'home_page.dart';

class SignInPage extends StatefulWidget {
  static const String id = 'signin_page';

  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  var isLoading=false;
  var emailController=TextEditingController();
  var passwordController=TextEditingController();

  _callSignUpPage(){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return SignUpPage();
        },
      ),
    );
  }

  _doSignIn(){
   String email=emailController.text.toString().trim();
   String password=passwordController.text.toString().trim();
   if(email.isEmpty||password.isEmpty) return;
   setState(() {
     isLoading = true;
   });
   AuthService.signInUser(email, password).then((value) => {
     _responseSignIn(value!),
   });
  }

  _responseSignIn(User firebaseUser) {
    setState(() {
      isLoading = false;
    });
    Navigator.pushReplacementNamed(context, HomePage.id);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(193, 53, 132, 1),
                  Color.fromRGBO(131, 58, 180, 1),
            ])),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                    child:Column(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Instagram',
                          style: TextStyle(
                              fontFamily: 'Billabong',
                              color: Colors.white,
                              fontSize: 50),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          height: 50,
                          padding: EdgeInsets.only(left: 10,right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: Colors.white.withOpacity(0.2),

                          ),
                          child: TextField(
                            controller: emailController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Email',
                                hintStyle: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 17
                                )
                            ),
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.only(top: 10),
                          height: 50,
                          padding: EdgeInsets.only(top: 10,right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: Colors.white.withOpacity(0.2),

                          ),
                          child: TextField(
                            obscureText: true,
                            controller: passwordController,
                            style: TextStyle(color: Colors.white),

                            decoration: InputDecoration(

                                border: InputBorder.none,
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 17
                                )
                            ),
                          ),
                        ),

                        //signin button

                        GestureDetector(
                          onTap: (){
                            _doSignIn();
                          },
                          child:   Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 50,
                              padding: EdgeInsets.only(left: 10,right: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  border: Border.all(
                                      width: 2,
                                      color: Colors.white54
                                  )

                              ),
                              child:Center(
                                child: Text('Sign in',style: TextStyle(color: Colors.white,fontSize: 17),),
                              )
                          ),)

                      ],
                    )
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: (){_callSignUpPage();},
                        child:
                        Text(
                          "Sign Up",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),)
                    ],
                  ),
                ),

              ],
            ),
            isLoading?Center(child: CircularProgressIndicator(),):
                SizedBox.shrink()
          ],
        )
      ),
    );
  }
}
