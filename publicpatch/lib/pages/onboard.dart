import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:publicpatch/pages/login.dart';

class OnboardingPage extends StatelessWidget {
  final String _backgroundPath = 'assets/images/Onboarding.jpg';
  final String _logoPath = 'assets/images/PPLogoThemed.png';

  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return onBoarding(context);
  }

  Container onBoarding(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.6),
              BlendMode.darken,
            ),
            child: Image.asset(
              _backgroundPath,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Image.asset(
                        _logoPath,
                        width: 200,
                        height: 200,
                      ),
                    ),
                    SizedBox(height: 40),
                    Text(
                      'See it, Snap it, Fix it!',
                      style: GoogleFonts.sourceSans3(
                        color: Colors.white,
                        fontSize: 24,
                        decoration: TextDecoration.none,
                        height: 1.2,

                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Empowering Citizens. Enhancing \nCommunities',
                    
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 16,
                        decoration: TextDecoration.none,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 40),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    backgroundColor: const Color.fromARGB(59, 7, 7, 7),
                    elevation: 0,
                  ),
                  child: Text(
                    'Get Started',
                    style: GoogleFonts.sourceSans3(
                      color: Colors.white,
                      fontSize: 18,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
