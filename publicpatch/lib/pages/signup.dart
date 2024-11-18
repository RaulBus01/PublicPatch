import 'package:flutter/material.dart';
import 'package:publicpatch/components/BackgroundImage.dart';
import 'package:publicpatch/components/CustomFormInput.dart';
import 'package:publicpatch/entity/User.dart';
import 'package:publicpatch/pages/home.dart';
import 'package:publicpatch/pages/login.dart';
import 'package:publicpatch/service/user_Service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:publicpatch/service/user_secure.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _userService = UserService();
  bool _isLoading = false;

  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final user = User(
          username: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        );

        final error = _validateFormInput(user);
        if (error.isNotEmpty) {
          Fluttertoast.showToast(
              backgroundColor: Colors.red,
              msg: error,
              gravity: ToastGravity.TOP);
          return;
        }

        final result = await _userService.createUser(user);
        if (result.isNotEmpty) {
          await UserSecureStorage.saveToken(result);
          Fluttertoast.showToast(
              msg: 'Account created successfully', gravity: ToastGravity.TOP);
        
          Navigator.pushReplacement(context, _createRoute('home'));
        } else {
          Fluttertoast.showToast(
              backgroundColor: Colors.red,
              msg: result,
              gravity: ToastGravity.TOP);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Backgroundimage(imagePath: 'assets/images/Login.jpg', opacity: 0.8),
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 150)),
                    Text(
                      'Sign Up',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(padding: EdgeInsets.only(top: 40)),
                    CustomFormInput(
                      controller: _nameController,
                      title: 'Full Name',
                      preFixIcon: Icons.person,
                    ),
                    Padding(padding: EdgeInsets.only(top: 15)),
                    CustomFormInput(
                      controller: _emailController,
                      title: 'Email',
                      preFixIcon: Icons.mail_outline,
                    ),
                    Padding(padding: EdgeInsets.only(top: 15)),
                    CustomFormInput(
                      controller: _passwordController,
                      title: 'Password',
                      obscureText: true,
                      preFixIcon: Icons.lock_outline,
                    ),
                    Padding(padding: EdgeInsets.only(top: 40)),
                    SizedBox(
                      width: 251,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          backgroundColor: Colors.transparent,
                        ),
                        onPressed: _isLoading ? null : _handleSignUp,
                        child: _isLoading
                            ? CircularProgressIndicator()
                            : Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      Color(0xFFFF9509),
                                      Color(0xFFFE2042)
                                    ]),
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
                              ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 50)),
                    Padding(padding: EdgeInsets.only(top: 90)),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context, _createRoute('login'));
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  String _validateFormInput(User user) {
    if (user.username.isEmpty || user.email.isEmpty || user.password.isEmpty) {
      return 'Please fill all fields';
    }
    if (user.username.length < 5) {
      return 'Username must be at least 5 characters';
    }
    if (!user.email.contains('@') ||
        !user.email.contains('.') ||
        user.email.length < 5) {
      return 'Invalid email address';
    }
    if (user.password.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return '';
  }

  Route _createRoute(String route) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          route == 'login' ? LoginPage() : HomePage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 600),
    );
  }
}
