import 'package:flutter/material.dart';
import '../dashboard_screen.dart';
import 'upload_item_screen.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../estimation_selection_screen.dart';
import 'package:my_project/colors.dart';
import 'package:go_router/go_router.dart';
import '../boat/upload_item_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemTypeSelectionScreen extends StatefulWidget {
  const ItemTypeSelectionScreen({super.key});

  @override
  State<ItemTypeSelectionScreen> createState() =>
      _ItemTypeSelectionScreenState();
}

class _ItemTypeSelectionScreenState extends State<ItemTypeSelectionScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  int _currentIndex = 1;

  final List<Map<String, dynamic>> categories = [
    {
      'title': 'Artwork',
      'icon': 'assets/images/artwork.jpg',
      'color': Color(0xFFFFA00D9),
    },
    {
      'title': 'Boat',
      'icon': 'assets/images/Yacht.jpg',
      'color': Color(0xFF61B3FF),
    },
    // {
    //   'title': 'Watch',
    //   'icon': 'assets/images/watch.jpg',
    //   'color': Color(0xFFFF6161),
    // },
    // {
    //   'title': 'Car',
    //   'icon': 'assets/images/car.jpg',
    //   'color': Color(0xFF61FFB7),
    // },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF410332),
              Color(0xFF510440),
              Color(0xFF61054E),
              Color(0xFF70055C),
              Color(0xFF800066),
            ],
            stops: [0.0, 0.25, 0.5, 0.75, 1.0],
          ),
        ),
        child: Column(
          children: [
            Container(padding: const EdgeInsets.only(top: 60)),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 40),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const EstimationSelectionScreen(),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black87,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              side: BorderSide(color: Colors.black, width: 1),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          const Text(
                            'Select Category',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'They all serve the same purpose, but each one takes a different.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          return _buildItemTypeCard(categories[index]);
                        },
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(12.0),
                    //   child: Column(
                    //     children: [
                    //       SizedBox(
                    //         width: double.infinity,
                    //         height: 56,
                    //         child: ElevatedButton(
                    //           onPressed: () {
                    //             Navigator.push(
                    //               context,
                    //               MaterialPageRoute(
                    //                 builder: (context) =>
                    //                     const UploadItemScreen(),
                    //               ),
                    //             );
                    //           },
                    //           style: ElevatedButton.styleFrom(
                    //             backgroundColor: Colors.deepPurple,
                    //             foregroundColor: Colors.white,
                    //             shape: RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.circular(30),
                    //             ),
                    //             elevation: 0,
                    //           ),
                    //           child: const Text(
                    //             'Next',
                    //             style: TextStyle(
                    //               fontSize: 18,
                    //               fontWeight: FontWeight.w600,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildItemTypeCard(Map<String, dynamic> category) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenHeight = MediaQuery.of(context).size.height;
        final cardHeight = screenHeight * 0.3;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: EdgeInsets.all(screenHeight * 0.01),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                height: cardHeight,
                decoration: BoxDecoration(
                  color: category['color'],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(category['icon'], fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 25),
              Text(
                category['title'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    SharedPreferences.getInstance().then((prefs) {
                      prefs.setString('selected_item', category['title']);
                    });
                    if (category['title'] == 'Artwork') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UploadItemScreen(),
                        ),
                      );
                    } else if (category['title'] == 'Boat') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UploadBoatItemScreen(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: category['color'],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Select',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width * 0.2, size.height * 0.2)
      ..lineTo(size.width * 0.8, size.height * 0.2)
      ..lineTo(size.width * 0.2, size.height * 0.8)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
