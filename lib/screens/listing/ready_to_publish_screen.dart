import 'package:flutter/material.dart';
import 'package:my_project/screens/auth_screen.dart';
import '../dashboard_screen.dart';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/art_detail/art_detail_bloc.dart';
import '../../screens/listing/visual_matches_screen.dart';
import '../../screens/category_selection_screen.dart';
import '../../blocs/boat/boat_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReadyToPublishScreen extends StatefulWidget {
  final String itemName;
  final String description;
  final String creator;
  final String price;
  final String year;
  final File? itemImage;
  final String? estimatedImageUrl;
  final String collectionName;
  final bool isPublic;
  final String collectionId;
  final String birthCountry;
  final String size;
  final String yearBirth;
  final String auctionHouseResult;
  final String turnoverEvolution;
  final String worldRanking;
  final String category;
  final String subtype;
  const ReadyToPublishScreen({
    super.key,
    required this.itemName,
    required this.description,
    required this.creator,
    required this.price,
    required this.year,
    this.itemImage,
    this.estimatedImageUrl,
    required this.collectionName,
    required this.isPublic,
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
  State<ReadyToPublishScreen> createState() => _ReadyToPublishScreenState();
}

class _ReadyToPublishScreenState extends State<ReadyToPublishScreen> {
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
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CategorySelectionScreen(),
                        ),
                      );
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
            const SnackBar(content: Text('Creating boat...')),
          );
        }
      },
      child: Scaffold(
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
                                        const DashboardScreen(),
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
                              'You are about to publish this item as part of the ${widget.collectionName == 'Single Object' ? 'Standalone Object' : '${widget.collectionName} collection'}, which is currently set to ${widget.isPublic ? 'Public' : 'Private'}.',
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
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey[200]!),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (widget.itemImage != null)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.file(
                                          widget.itemImage!,
                                          width: double.infinity,
                                          height: 300,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    else if (widget.estimatedImageUrl != null)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                            widget.estimatedImageUrl!,
                                            fit: BoxFit.cover,
                                            width: 200,
                                            height: 400),
                                      ),

                                    const SizedBox(height: 16),
                                    // Item details
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
                                                widget.itemName,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 3,
                                              ),
                                              Text(
                                                'from ${widget.collectionName}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color:
                                                      Colors.black.withOpacity(
                                                    0.6,
                                                  ),
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Row(
                                        //   children: [
                                        //     const Icon(Icons.favorite_border),
                                        //     const SizedBox(width: 4),
                                        //     Text(
                                        //       '99',
                                        //       style: TextStyle(
                                        //         color: Colors.black.withOpacity(
                                        //           0.6,
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    // Additional details
                                    Text(
                                      widget.description,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black.withOpacity(0.6),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Creator: ${widget.creator}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Colors.black.withOpacity(0.6),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Text(
                                          'Year: ${widget.year}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Colors.black.withOpacity(0.6),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '\$${widget.price}',
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
                                    // 1. Send to BoatBloc (=> boats collection)
                                    context.read<BoatBloc>().add(
                                          CreateBoatEvent(
                                            imageUrl:
                                                widget.estimatedImageUrl ?? '',
                                            model: widget.itemName,
                                            brand: widget.creator,
                                            horsePower: widget.size,
                                            price: widget.price,
                                            year: widget.year,
                                            category: widget.category,
                                            collectionId: widget.collectionId,
                                            isPublic: widget.isPublic,
                                            itemImage: widget.itemImage,
                                          ),
                                        );

                                    // 2. Also send manually to moderation collection
                                    final moderationPayload = {
                                      "image": widget.estimatedImageUrl ?? '',
                                      "title": widget.itemName,
                                      "description": widget.description,
                                      "brand": widget.creator,
                                      "price": widget.price,
                                      "yearBuilt": widget.year,
                                      "category": widget.category,
                                      "collectionId": widget.collectionId,
                                      "isPublic": widget.isPublic.toString(),
                                    };

                                    try {
                                      //final response = await http.post(
                                      //Uri.parse(
                                      //  'http://18.206.227.2:8000/api/moderation'),
                                      //headers: {
                                      //'Content-Type': 'application/json'
                                      //},
                                      //body: jsonEncode(moderationPayload),
                                      //);

                                      //if (response.statusCode == 200 ||
                                      //  response.statusCode == 201) {
                                      //print('✅ Sent to moderation');
                                      //} else {
                                      //print(
                                      //  '❌ Failed to send to moderation: ${response.body}');
                                      //}
                                    } catch (e) {
                                      print(
                                          '❌ Error sending to moderation: $e');
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
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
      ),
    );
  }
}
