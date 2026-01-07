import 'package:flutter/material.dart';
import 'package:medconnect_app/signupScreen.dart';
import 'package:medconnect_app/signInScreen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  bool isSignUpSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Image with dark overlay
          SizedBox.expand(
            child: Image.asset(
              'assets/images/intro_BackGround.png',
              fit: BoxFit.cover,
              color: const Color.fromRGBO(0, 0, 0, 0.65),
              colorBlendMode: BlendMode.darken,
            ),
          ),

          // Centered card
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 360),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 34),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.98),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 30,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo
                    Image.asset(
                      "assets/images/logoPNG.png",
                      height: 50,
                      fit: BoxFit.contain,
                      color: Colors.black54,
                    ),
                    const SizedBox(height: 20),

                    // Intro text
                    const Text(
                      'Your Trusted Medical\nEquipment Marketplace',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 23.5,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Trusted By 5,000+ Medical Professionals',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Sign Up Button
                    _buildAuthButton(
                      text: 'Sign Up',
                      isSelected: isSignUpSelected,
                      onTap: () {
                        setState(() => isSignUpSelected = true);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SignUpScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 14),

                    // Sign In Button
                    _buildAuthButton(
                      text: 'Sign In',
                      isSelected: !isSignUpSelected,
                      onTap: () {
                        setState(() => isSignUpSelected = false);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SignInScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 30),

                    // Terms & Privacy
                    const Text(
                      'By Continuing You Agree To Our Terms Of Service And\nPrivacy Policy',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthButton({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: Container(
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF0066FF) : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0xFF0066FF), width: 2),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : const Color(0xFF0066FF),
            ),
          ),
        ),
      ),
    );
  }
}
