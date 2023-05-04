import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:safarnama/screens/home.dart';
import 'package:safarnama/screens/perferences.dart';
import 'package:safarnama/utils/wrapper.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // late FirebaseMessaging messaging;
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool _passwordVisible = false;
  final TextEditingController phone = TextEditingController();
  String ph = '0';
  bool phValidated = false;
  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xfffb558b), Color(0xff505edc)],
  ).createShader(Rect.fromLTWH(0.0, 100.0, 200.0, 70.0));

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential> signInWithGoogle() async {
    GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    UserCredential authResult = await _auth.signInWithCredential(credential);
    return authResult;
  }

  @override
  void initState() {
    // messaging = FirebaseMessaging.instance;
    // messaging.getToken().then((value) {
    //   controller.saveToken(value);
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return themeWrapper(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/login.svg',
                height: 350,
                width: double.infinity,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Safarnama",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    foreground: Paint()..shader = linearGradient),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Travelling and Planning\nhas never been so easy!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: SvgPicture.asset(
                            "assets/google.svg",
                            height: 24,
                            width: 24,
                          ),
                        ),
                        const Text(
                          'Login with Google',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  ),
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    primary: Colors.white,
                    backgroundColor: Colors.grey.withOpacity(0.2),
                    onSurface: Colors.grey,
                  ),
                  onPressed: () {
                    // GetStorage().write("uid", "ojask2002@gmail.com");
                    // GetStorage().write("name", "ojas");
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute<void>(
                    //     builder: (BuildContext context) => const SelectPrefs(),
                    //   ),
                    // );
                    signInWithGoogle().then((value) {
                      GetStorage().write("uid", value.user?.email);
                      GetStorage().write("name", value.user?.displayName);
                      
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              const SelectPrefs(),
                        ),
                      );
                    }).catchError((err) => print(err));
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '\nYour one stop trip-advisor !',
                    style:
                        TextStyle(foreground: Paint()..shader = linearGradient),
                    // textAlign: TextAlign.end,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
