import 'package:flutter/material.dart';
import '../../models/boat.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../screens/auth_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/signin/signin_bloc.dart';
import '../../blocs/boat/boat_bloc.dart';
import 'package:my_project/colors.dart';
import 'package:my_project/screens/boat/upload_item_screen.dart';
import 'package:intl/intl.dart';

class BoatDetailScreen extends StatelessWidget {
  const BoatDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BoatBloc, BoatState>(
      builder: (context, state) {
        if (state is BoatInitial) {
          return const Scaffold(
            body: Center(
              child: Text('No boat selected'),
            ),
          );
        }

        if (state is BoatLoaded) {
          final boat = state.boat;
          print(boat.brand);
          print(boat.model);
          print(boat.yearBuilt);
          print(boat.price);
          print(boat.engineDetails);
          print(boat.link);
          print('#########################');
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
                'Yacht Details',
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
                                boat.imageUrl ?? '',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              Text(
                                boat.safeModel,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 12),
                              // Description

                              const SizedBox(height: 24),
                              // Brand and Year Info
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Brand',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          boat.safeBrand,
                                          style: const TextStyle(
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
                                          'Year Built',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          boat.safeYear,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
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
                                            'Price',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            (boat.safePrice.isEmpty ||
                                                    boat.safePrice == 'null')
                                                ? 'Unknown'
                                                : NumberFormat.currency(
                                                    symbol: '\$',
                                                    decimalDigits: 0,
                                                    locale: 'en_US',
                                                  ).format(double.tryParse(
                                                        boat.safePrice) ??
                                                    0),
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
                                            'Type',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            boat.safeCategory,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
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
                                      'To edit the description or request a valuation, please upload this item to your account.',
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
                                                        UploadBoatItemScreen(
                                                      estimatedImage:
                                                          boat.imageUrl ?? '',
                                                      estimatedPrice:
                                                          boat.price,
                                                      estimatedModel:
                                                          boat.model,
                                                      estimatedEngineDetails:
                                                          boat.engineDetails,
                                                      estimatedYearBuilt:
                                                          boat.yearBuilt,
                                                      estimatedBrand:
                                                          boat.brand,
                                                      estimatedCategory:
                                                          boat.category,
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
                                                                UploadBoatItemScreen(
                                                              estimatedImage:
                                                                  boat.imageUrl ??
                                                                      '',
                                                              estimatedPrice:
                                                                  boat.price,
                                                              estimatedModel:
                                                                  boat.model,
                                                              estimatedEngineDetails:
                                                                  boat.engineDetails,
                                                              estimatedYearBuilt:
                                                                  boat.yearBuilt,
                                                              estimatedBrand:
                                                                  boat.brand,
                                                              estimatedCategory:
                                                                  boat.category,
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
                                                  Color(0xFF410332),
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
                                              'Upload Item to Your Account',
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

  String _getHorsePowerRange(String horsePower) {
    if (horsePower.isEmpty || horsePower == 'null') {
      return 'Unknown';
    }

    double hp = double.parse(horsePower);
    if (hp < 400) {
      return '<400HP';
    } else if (hp <= 1000) {
      return '400-1000HP';
    } else {
      return '>1000HP';
    }
  }
}
