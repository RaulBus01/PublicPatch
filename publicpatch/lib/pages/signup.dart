import 'package:flutter/material.dart';
import 'package:publicpatch/components/BackgroundImage.dart';
import 'package:publicpatch/components/CustomFormInput.dart';
import 'package:publicpatch/pages/login.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        
        child: Scaffold(
            body: Stack(fit: StackFit.expand, children: [
          Backgroundimage(imagePath: 'assets/images/Login.jpg', opacity: 0.8),
          SingleChildScrollView(
              child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 200)),
              Text(
                'Sign Up',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold),
              ),
              Padding(padding: EdgeInsets.only(top: 40)),
              CustomFormInput(title: 'Full Name'),
              Padding(padding: EdgeInsets.only(top: 15)),
              CustomFormInput(title: 'Nickname'),
              Padding(padding: EdgeInsets.only(top: 15)),
              CustomFormInput(title: 'Email'),
              Padding(padding: EdgeInsets.only(top: 15)),
              CustomFormInput(title: 'Password', obscureText: true),
              Padding(padding: EdgeInsets.only(top: 40)),
              signupButton(),
              Padding(padding: EdgeInsets.only(top: 50)),
              Padding(padding: EdgeInsets.only(top: 100)),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context, _createRoute());
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: Text(
                  'Already have an account? Log In',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          )),
        ])));
  }

  SizedBox signupButton() {
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
                      'Sign Up',
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
    pageBuilder: (context, animation, secondaryAnimation) => const LoginPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(-1.0, 0.0);
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
