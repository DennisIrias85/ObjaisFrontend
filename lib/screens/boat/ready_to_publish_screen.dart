import 'package:flutter/material.dart';
import 'package:my_project/screens/auth_screen.dart';
import '../dashboard_screen.dart';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../blocs/boat/boat_bloc.dart';
import '../../models/boat.dart';
import '../../services/boat_storage_service.dart';
import '../../screens/listing/visual_matches_screen.dart';
import '../../screens/category_selection_screen.dart';
import '../../screens/estimation_selection_screen.dart';
import 'dart:convert';
import '../../services/http_client.dart' as myHttp;

class ReadyToPublishMyScreen extends StatefulWidget {
  const ReadyToPublishMyScreen({
    super.key,
  });

  @override
  State<ReadyToPublishMyScreen> createState() => _ReadyToPublishMyScreenState();
}

class _ReadyToPublishMyScreenState extends State<ReadyToPublishMyScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BoatBloc, BoatState>(
      listener: (context, state) {
        if (state is BoatCreated) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Item Pending Approval'),
                content: const Text(
                  'Your item has been submitted for approval. You will be notified once it is approved.',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog first

                      // Small delay before navigating
                      Future.delayed(const Duration(milliseconds: 300), () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const CategorySelectionScreen(),
                          ),
                        );
                      });
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else if (state is BoatError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is BoatCreating) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Creating yacht...')),
          );
        }
      },
      child: BlocBuilder<BoatBloc, BoatState>(
        builder: (context, state) {
          final extra = GoRouterState.of(context).extra as Map<String, dynamic>;
          final boat = extra['boat'];
          print(boat.boatImage);
          print(boat.imageUrl);
          print(boat.model);
          print(boat.brand);
          print(boat.engineDetails);
          print(boat.price);
          final isPublic = extra['isPublic'];

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
                    padding:
                        const EdgeInsets.only(top: 40, bottom: 10, left: 10),
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
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                const Text(
                                  'Ready to publish?',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'You are about to publish this Yacht, which is currently set to ${isPublic ? 'Public' : 'Private'}.',
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: BorderRadius.circular(12),
                                      border:
                                          Border.all(color: Colors.grey[200]!),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        if (boat.imageUrl != null)
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Image.network(
                                              boat.imageUrl!,
                                              width: double.infinity,
                                              height: 300,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        else if (boat.boatImage != null)
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Image.file(
                                              boat.boatImage!,
                                              width: double.infinity,
                                              height: 300,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        const SizedBox(height: 16),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    boat.model,
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 3,
                                                  ),
                                                  Text(
                                                    'from ${boat.brand}',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black
                                                          .withOpacity(0.6),
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          boat.engineDetails,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Colors.black.withOpacity(0.6),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Type: ${boat.category}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Text(
                                              'Year: ${boat.yearBuilt}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '\$${boat.price}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFFFA00D9),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        final prefs = await SharedPreferences
                                            .getInstance();
                                        final collectionId = prefs.getString(
                                                'selected_collection_id') ??
                                            '';

                                        // Dispatch BoatBloc event (keep this)
                                        context
                                            .read<BoatBloc>()
                                            .add(CreateBoatEvent(
                                              imageUrl: boat.imageUrl ?? '',
                                              itemImage: boat.boatImage,
                                              model: boat.model,
                                              brand: boat.brand,
                                              horsePower: boat.engineDetails,
                                              price: boat.price,
                                              year: boat.yearBuilt,
                                              category: boat.category,
                                              collectionId: collectionId,
                                              isPublic: isPublic,
                                            ));

                                        // ✅ Send to moderation collection via HTTP
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF410332),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: const Text(
                                        'Publish',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                ],
                              ),
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
        },
      ),
    );
  }
}
