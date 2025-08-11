import 'package:flutter/material.dart';
import 'sign_in_screen.dart';
import 'sign_up_screen.dart';
import 'package:my_project/colors.dart';

class AuthScreen extends StatelessWidget {
  final VoidCallback? onAuthSuccess;

  const AuthScreen({super.key, this.onAuthSuccess});

  List<Map<String, dynamic>> getCategories(Size screenSize) => [
        {
          'icon': 'assets/images/car.jpg',
          'size': screenSize.width * 0.3,
          'top': screenSize.height * 0.2,
          'left': screenSize.width * 0.05,
        },
        {
          'icon': 'assets/images/artwork.jpg',
          'size': screenSize.width * 0.3,
          'top': screenSize.height * 0.32,
          'left': screenSize.width * 0.9,
        },
        {
          'icon': 'assets/images/Yacht.jpg',
          'size': screenSize.width * 0.2,
          'top': screenSize.height * 0.08,
          'left': screenSize.width * 0.4,
        },
        {
          'icon': 'assets/images/watch.jpg',
          'size': screenSize.width * 0.35,
          'top': screenSize.height * 0.15,
          'left': screenSize.width * 0.7,
        },
        {
          'icon': 'assets/images/jewelry.jpg',
          'size': screenSize.width * 0.35,
          'top': screenSize.height * 0.3,
          'left': screenSize.width * 0.35,
        },
        {
          'icon': 'assets/images/sculpture.jpg',
          'size': screenSize.width * 0.26,
          'top': screenSize.height * 0.34,
          'left': screenSize.width * -0.1,
        },
      ];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final categories = getCategories(screenSize);

    return Scaffold(
      backgroundColor: const Color(0xFF9C27B0),
      body: Stack(
        children: [
          // Background circles pattern
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF410332), // Start Purple
                    Color(0xFF510440), // First transition
                    Color(0xFF61054E), // Second transition
                    Color(0xFF70055C), // Third transition
                    Color(0xFF800066), // End Purple
                  ],
                  stops: [0.0, 0.25, 0.5, 0.75, 1.0],
                ),
              ),
              child: Stack(
                children: [
                  ...List.generate(categories.length, (index) {
                    final category = categories[index];
                    return Positioned(
                      top: category['top'],
                      left: category['left'],
                      child: Container(
                        width: category['size'],
                        height: category['size'],
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          // color: Colors.black.withOpacity(0.3),
                          // border: Border.all(
                          //   color: Colors.white.withOpacity(0.2),
                          //   width: 1,
                          // ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              category['icon'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          // White overlay at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: screenSize.height * 0.4,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Estimate, store and manage your valuable items',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Enter a few details to proceed further',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Don't have an account",
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.7),
                                fontSize: 16,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignUpScreen(
                                      onAuthSuccess: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SignInScreen(
                                                onAuthSuccess: onAuthSuccess,
                                              ),
                                            ));
                                      },
                                    ),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.primaryColor,
                                padding: EdgeInsets.zero,
                              ),
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Already have an account',
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.7),
                                fontSize: 16,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignInScreen(
                                      onAuthSuccess: onAuthSuccess,
                                    ),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.primaryColor,
                                padding: EdgeInsets.zero,
                              ),
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: 80,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
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
}

// Custom painter for the circle pattern background
class CirclePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Add circles in a pattern
    final circles = [
      Offset(size.width * 0.2, size.height * 0.2),
      Offset(size.width * 0.8, size.height * 0.15),
      Offset(size.width * 0.5, size.height * 0.3),
      Offset(size.width * 0.15, size.height * 0.5),
      Offset(size.width * 0.7, size.height * 0.4),
    ];

    for (var center in circles) {
      canvas.drawCircle(center, 40, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
