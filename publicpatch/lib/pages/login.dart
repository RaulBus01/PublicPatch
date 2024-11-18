import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:ionicons/ionicons.dart';
import 'package:publicpatch/components/BackgroundImage.dart';
import 'package:publicpatch/components/CustomFormInput.dart';
import 'package:publicpatch/models/UserLogin.dart';
import 'package:publicpatch/pages/home.dart';
import 'package:publicpatch/pages/reports.dart';
import 'package:publicpatch/pages/signup.dart';
import 'package:publicpatch/service/user_Service.dart';
import 'package:publicpatch/service/user_secure.dart';
import 'package:publicpatch/utils/create_route.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _userService = UserService();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final user = UserLogin(
          email: _emailController.text,
          password: _passwordController.text,
        );

        var validate = ValidateUserLogin(user);

        if (validate != 'valid') {
          Fluttertoast.showToast(
              backgroundColor: Colors.red,
              msg: validate,
              gravity: ToastGravity.TOP);
          setState(() => _isLoading = false);
          return;
        }
        final result = await _userService.login(user);

        if (result.isNotEmpty) {
          await UserSecureStorage.saveToken(result);
          Fluttertoast.showToast(
              backgroundColor: Colors.green,
              msg: 'Logged in successfully',
              gravity: ToastGravity.TOP);
          Navigator.pushReplacement(
              context, CreateRoute.createRoute(const HomePage()));
        } else {
          Fluttertoast.showToast(
              backgroundColor: Colors.red,
              msg: 'User not found',
              gravity: ToastGravity.TOP);
        }
      } catch (e) {
        Fluttertoast.showToast(
            backgroundColor: Colors.red,
            msg: 'Error logging in',
            gravity: ToastGravity.TOP);
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
              child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 150)),
                Text(
                  'Log In',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold),
                ),
                Padding(padding: EdgeInsets.only(top: 40)),
                CustomFormInput(controller: _emailController, title: 'Email'),
                Padding(padding: EdgeInsets.only(top: 15)),
                CustomFormInput(
                    controller: _passwordController,
                    title: 'Password',
                    obscureText: true),
                Padding(padding: EdgeInsets.only(top: 40)),
                loginButton(context),
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
                    Navigator.pushReplacement(
                        context, CreateRoute.createRoute(const SignUpPage()));
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
            ),
          ))
        ])));
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

  SizedBox loginButton(context) {
    return SizedBox(
        width: 251,
        height: 50,
        child: ElevatedButton(
            onPressed: _isLoading ? null : _handleLogin,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shadowColor: Colors.transparent,
              backgroundColor: Colors.transparent,
            ),
            child: _isLoading
                ? CircularProgressIndicator()
                : Container(
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
                  )));
  }
}

String ValidateUserLogin(UserLogin user) {
  if (user.email.isEmpty) {
    return 'Email is required';
  }

  if (user.password.isEmpty) {
    return 'Password is required';
  }

  if (user.email.contains('@') == false) {
    return 'Email is invalid';
  }

  return 'valid';
}
