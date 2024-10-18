import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:publicpatch/components/BackgroundImage.dart';
import 'package:publicpatch/components/CustomFormInput.dart';
import 'package:publicpatch/pages/signup.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return
    GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: 
    Scaffold(
      
        body: Stack(fit: StackFit.expand, children: [
      Backgroundimage(imagePath: 'assets/images/Login.jpg', opacity: 0.8),
      SingleChildScrollView(
          child: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 200)),
          Text(
            'Log In',
            style: TextStyle(
                color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold),
          ),
          Padding(padding: EdgeInsets.only(top: 40)),
          CustomFormInput(title: 'Email'),
          Padding(padding: EdgeInsets.only(top: 15)),
          CustomFormInput(title: 'Password', obscureText: true),
          Padding(padding: EdgeInsets.only(top: 40)),
          loginButton(),
          Padding(padding: EdgeInsets.only(top: 40)),
          Text(
            'or log in with',
            style: TextStyle(color: Color(0xFF768196), fontSize: 16),
          ),
          Padding(padding: EdgeInsets.only(top: 50)),
          iconsRow(),
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
              'Don\'t have an account? Sign Up',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ))
    ]))

  );

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


