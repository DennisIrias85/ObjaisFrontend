import 'package:flutter/material.dart';
import '../models/art_data.dart';
import 'profile/profile_screen.dart';
import '../widgets/bottom_nav_bar.dart';
import '../screens/auth_screen.dart';
import '../screens/listing/upload_item_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/signin/signin_bloc.dart';
import '../screens/sign_in_screen.dart';
import '../blocs/art_detail/art_detail_bloc.dart';
import 'package:my_project/colors.dart';

class ArtDetailScreen extends StatelessWidget {
  const ArtDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArtDetailBloc, ArtDetailState>(
      builder: (context, state) {
        if (state is ArtDetailInitial) {
          return const Scaffold(
            body: Center(
              child: Text('No artwork selected'),
            ),
          );
        }

        if (state is ArtDetailLoaded) {
          final art = state.art;
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text(
                'About ArtWork',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            // Main Image
                            Container(
                              width: double.infinity,
                              height: 400,
                              decoration:
                                  BoxDecoration(color: Colors.grey[100]),
                              child: Image.network(
                                art.imageUrl,
                                fit: BoxFit.contain,
                              ),
                            ),
                            // Like Button
                            // Positioned(
                            //   top: 16,
                            //   right: 16,
                            //   child: Container(
                            //     padding: const EdgeInsets.symmetric(
                            //       horizontal: 12,
                            //       vertical: 6,
                            //     ),
                            //     decoration: BoxDecoration(
                            //       color: Colors.white,
                            //       borderRadius: BorderRadius.circular(20),
                            //     ),
                            //     child: Row(
                            //       mainAxisSize: MainAxisSize.min,
                            //       children: [
                            //         const Icon(Icons.favorite_border, size: 20),
                            //         const SizedBox(width: 4),
                            //         Text(
                            //           '68',
                            //           style: TextStyle(
                            //             fontWeight: FontWeight.bold,
                            //             color: Colors.grey[800],
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              Text(
                                art.artName,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 12),
                              // Description
                              Text(
                                art.description,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Creator and Year Info
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Artist Name',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        GestureDetector(
                                          onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const ProfileScreen(),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 12,
                                                backgroundColor:
                                                    Colors.grey[300],
                                                child: const Icon(
                                                  Icons.person,
                                                  size: 20,
                                                  color: Color(0xFFFFA00D9),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                art.artistName,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Type',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 12,
                                              backgroundColor: Colors.grey[300],
                                              child: const Icon(
                                                Icons.category,
                                                size: 20,
                                                color: Color(0xFFFFA00D9),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              art.category,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Artist Birth Country',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        GestureDetector(
                                          onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const ProfileScreen(),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 12,
                                                backgroundColor:
                                                    Colors.grey[300],
                                                child: const Icon(
                                                  Icons.person,
                                                  size: 20,
                                                  color: Color(0xFFFFA00D9),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                art.birthCountry,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'size',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 12,
                                              backgroundColor: Colors.grey[300],
                                              child: const Icon(
                                                Icons.category,
                                                size: 20,
                                                color: Color(0xFFFFA00D9),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              art.size,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'ARTIST YEAR OF BIRTH',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        GestureDetector(
                                          onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const ProfileScreen(),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 12,
                                                backgroundColor:
                                                    Colors.grey[300],
                                                child: const Icon(
                                                  Icons.person,
                                                  size: 20,
                                                  color: Color(0xFFFFA00D9),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                art.yearBirth,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              // Price Section
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFCFDBD5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'AIQuote estimated Price',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${art.price}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Year',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            art.year,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Market Analysis Section
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey[200]!),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Market Analysis',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Auction House Results',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                art.auctionHouseResult,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Turnover Evolution',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                art.turnoverEvolution,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'World Ranking',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          art.worldRanking,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                              Form(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 24),
                                    Text(
                                      'If you wish to modify description and/or valuation, please upload item to your account',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black.withOpacity(0.6),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    SizedBox(
                                      width: double.infinity,
                                      child:
                                          BlocBuilder<SigninBloc, SigninState>(
                                        builder: (context, signinState) {
                                          return ElevatedButton(
                                            onPressed: () {
                                              if (signinState.isSuccess &&
                                                  signinState.user != null) {
                                                // User is already signed in, go directly to UploadItemScreen
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        UploadItemScreen(
                                                      estimatedImage:
                                                          art.imageUrl,
                                                      estimatedPrice: art.price,
                                                      estimatedTitle:
                                                          art.artName,
                                                      estimatedDescription:
                                                          art.description,
                                                      estimatedYear: art.year,
                                                      estimatedCreator:
                                                          art.artistName,
                                                      estimatedCategory:
                                                          art.category,
                                                      estimatedSize: art.size,
                                                      estimatedBirthCountry:
                                                          art.birthCountry,
                                                      estimatedAuctionHouseResult:
                                                          art.auctionHouseResult,
                                                      estimatedTurnoverEvolution:
                                                          art.turnoverEvolution,
                                                      estimatedWorldRanking:
                                                          art.worldRanking,
                                                      estimatedYearBirth:
                                                          art.yearBirth,
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                // User is not signed in, go to AuthScreen
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AuthScreen(
                                                      onAuthSuccess: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                UploadItemScreen(
                                                              estimatedImage:
                                                                  art.imageUrl,
                                                              estimatedPrice:
                                                                  art.price,
                                                              estimatedTitle:
                                                                  art.artName,
                                                              estimatedDescription:
                                                                  art.description,
                                                              estimatedYear:
                                                                  art.year,
                                                              estimatedCreator:
                                                                  art.artistName,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.primaryColor,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 16,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                            ),
                                            child: const Text(
                                              'Upload item to your account',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                  ],
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
            bottomNavigationBar: BottomNavBar(
              currentIndex: 0,
              onTap: (index) {
                // Handle navigation based on index
                switch (index) {
                  case 0:
                    Navigator.pushNamed(context, '/home');
                    break;
                  case 1:
                    Navigator.pushNamed(context, '/search');
                    break;
                  case 2:
                    Navigator.pushNamed(context, '/upload');
                    break;
                  case 3:
                    Navigator.pushNamed(context, '/profile');
                    break;
                }
              },
            ),
          );
        }

        return const Scaffold(
          body: Center(
            child: Text('Unexpected state'),
          ),
        );
      },
    );
  }
}
