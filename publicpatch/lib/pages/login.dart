import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ionicons/ionicons.dart';
import 'package:publicpatch/components/BackgroundImage.dart';
import 'package:publicpatch/components/CustomFormInput.dart';
import 'package:publicpatch/pages/signup.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GoogleSignIn _googleSignIn = GoogleSignIn(clientId: '615305001620-6bod31ttr7o0qr8o2c8onn1cah6gpq4a.apps.googleusercontent.com',
    scopes: ['openid', 'email', 'profile']);
  }

 

  Row iconsRow() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(
            Ionicons.logo_facebook,
            color: Colors.white,
            size: 20,
          ),
          Padding(padding: EdgeInsets.only(left: 30)),
          Icon(
            Ionicons.logo_google,
            color: Colors.white,
            size: 20,
          ),
          Padding(padding: EdgeInsets.only(left: 30)),
          Icon(
            Ionicons.logo_instagram,
            color: Colors.white,
            size: 20,
          ),
        ]);
  }
  

  SizedBox loginButton() {
    return SizedBox(
        width: 251,
        height: 50,
        child: Container(
      
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFFFF9509), Color(0xFFFE2042)]),
              borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: Text(
              'Log In',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ));
  }
  Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const SignUpPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    
    },
    transitionDuration: const Duration(milliseconds: 600),
  );
}
 
  
  
}


