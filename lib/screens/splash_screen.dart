import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  final VoidCallback onComplete;

  const SplashScreen({super.key, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    // Start navigation timer
    Future.delayed(const Duration(seconds: 5), onComplete);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF410332),
          // gradient: LinearGradient(
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          //   colors: [
          //     Color(0xFF410332), // Start Purple
          //     Color(0xFF510440), // First transition
          //     Color(0xFF61054E), // Second transition
          //     Color(0xFF70055C), // Third transition
          //     Color(0xFF800066), // End Purple
          //   ],
          //   stops: [0.0, 0.25, 0.5, 0.75, 1.0],
          // ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Cloud with arrow image
                  Container(
                    width: double.infinity,
                    height: 180,
                    child: ClipRRect(
                      child: Image.asset(
                        'assets/images/1.png',
                        height: 180,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  // Text
                  const Text(
                    'Take a Photo, get an estimation from AI !',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 60),
                  // Loading indicator
                  const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
