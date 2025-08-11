import 'package:flutter/material.dart';
import '../dashboard_screen.dart';
import 'ready_to_publish_screen.dart';
import 'dart:io';
import 'package:my_project/colors.dart';

class SetPreferencesScreen extends StatefulWidget {
  final String itemName;
  final String description;
  final String creator;
  final String price;
  final String year;
  final File? itemImage;
  final String? estimatedImageUrl;
  final String collectionName;
  final String collectionId;
  final String birthCountry;
  final String size;
  final String yearBirth;
  final String auctionHouseResult;
  final String turnoverEvolution;
  final String worldRanking;
  final String category;
  final String subtype;
  const SetPreferencesScreen({
    super.key,
    required this.itemName,
    required this.description,
    required this.creator,
    required this.price,
    required this.year,
    this.itemImage,
    this.estimatedImageUrl,
    required this.collectionName,
    required this.collectionId,
    required this.birthCountry,
    required this.size,
    required this.yearBirth,
    required this.auctionHouseResult,
    required this.turnoverEvolution,
    required this.worldRanking,
    required this.category,
    required this.subtype,
  });

  @override
  State<SetPreferencesScreen> createState() => _SetPreferencesScreenState();
}

class _SetPreferencesScreenState extends State<SetPreferencesScreen> {
  bool _isPublic = true;

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
            Container(
              padding: const EdgeInsets.only(top: 40, bottom: 10, left: 10),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logotwo.png',
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                // margin: const EdgeInsets.only(top: 40),
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
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const DashboardScreen(),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black87,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              side: const BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
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
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          const Text(
                            'Set preferences',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'But each one takes a different approach and\nmakes different tradeoffs.',
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
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Status',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: ListTile(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Private',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Switch(
                                      value: _isPublic,
                                      onChanged: (value) {
                                        setState(() {
                                          _isPublic = value;
                                        });
                                      },
                                      activeColor: AppColors.primaryColor,
                                    ),
                                    const Text(
                                      'Public',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ReadyToPublishScreen(
                                      itemName: widget.itemName,
                                      description: widget.description,
                                      creator: widget.creator,
                                      price: widget.price,
                                      year: widget.year,
                                      itemImage: widget.itemImage,
                                      estimatedImageUrl:
                                          widget.estimatedImageUrl,
                                      collectionName: widget.collectionName,
                                      collectionId: widget.collectionId,
                                      birthCountry: widget.birthCountry,
                                      size: widget.size,
                                      yearBirth: widget.yearBirth,
                                      auctionHouseResult:
                                          widget.auctionHouseResult,
                                      turnoverEvolution:
                                          widget.turnoverEvolution,
                                      worldRanking: widget.worldRanking,
                                      category: widget.category,
                                      isPublic: _isPublic,
                                      subtype: widget.subtype,
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Next',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
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
}
