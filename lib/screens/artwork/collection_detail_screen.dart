import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/art_data.dart';
import '../art_detail_screen.dart';
import '../filter_screen.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../services/art_service.dart';
import '../../blocs/signin/signin_bloc.dart';
import '../auth_screen.dart';
import '../search/search_screen.dart';

class CollectionDetailScreen extends StatefulWidget {
  final collection;

  const CollectionDetailScreen({super.key, required this.collection});

  @override
  State<CollectionDetailScreen> createState() => _CollectionDetailScreenState();
}

class _CollectionDetailScreenState extends State<CollectionDetailScreen> {
  final ArtService _artService = ArtService();
  final Map<String, bool> _likedArtworks = {};

  Future<void> _handleLike(String artworkId) async {
    final signinState = context.read<SigninBloc>().state;

    if (!signinState.isSuccess || signinState.token == null) {
      // User is not signed in, show auth screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AuthScreen(
            onAuthSuccess: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchScreen(),
                ),
              );
            },
          ),
        ),
      );
      return;
    }

    try {
      await _artService.likeArtwork(artworkId);
      setState(() {
        _likedArtworks[artworkId] = !(_likedArtworks[artworkId] ?? false);
        // Update the likes count in the artwork
        final artwork =
            widget.collection.artworks.firstWhere((art) => art.id == artworkId);
        final currentLikes = int.tryParse(artwork.likes ?? '0') ?? 0;
        artwork.likes = (_likedArtworks[artworkId] ?? false)
            ? (currentLikes + 1).toString()
            : (currentLikes - 1).toString();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to like artwork: $e')),
      );
    }
  }

  static final List<ArtData> sampleArtData = [];

  Widget _buildCollectionHeader(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: const NetworkImage('https://placekitten.com/100/100'),
      //     fit: BoxFit.cover,
      //   ),
      // ),
      color: Colors.grey[100],
      child: Column(
        children: [
          Stack(
            children: [
              // Background Image or Color
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.collection.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Back Button
              Positioned(
                top: 50,
                left: 16,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_outlined),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
              // Profile Picture in top right
              // Positioned(
              //   top: 50,
              //   right: 16,
              //   child: CircleAvatar(
              //     radius: 20,
              //     backgroundColor: Colors.grey[300],
              //     backgroundImage: const NetworkImage(
              //       'https://placekitten.com/100/100', // Placeholder profile image
              //     ),
              //   ),
              // ),
            ],
          ),
          // Collection Logo/Avatar
          Transform.translate(
            offset: const Offset(0, -40),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
              ),
              child: CircleAvatar(
                radius: 40,
                backgroundImage:
                    NetworkImage(widget.collection.owner?.avatarUrl ?? ''),
              ),
            ),
          ),
          // Collection Name and Username
          Text(
            widget.collection.name,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          // Creator info
          Text(
            'created by ${widget.collection.owner?.username}',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          // Stats Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStat(
                    widget.collection.artworks.length.toString(), 'Items'),
                _buildStat(
                    widget.collection.artworks
                        .fold(0.0,
                            (sum, artwork) => sum + double.parse(artwork.price))
                        .toString(),
                    'Volume',
                    isVolume: true),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Filter Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                TextButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => DraggableScrollableSheet(
                        initialChildSize: 0.91,
                        maxChildSize: 0.91,
                        minChildSize: 0.5,
                        builder: (context, scrollController) =>
                            const FilterScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.filter_list),
                  label: const Text('Filters'),
                  style: TextButton.styleFrom(foregroundColor: Colors.black),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.sort),
                  label: const Text('Date added'),
                  style: TextButton.styleFrom(foregroundColor: Colors.black),
                ),
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label, {bool isVolume = false}) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isVolume)
              const Padding(
                padding: EdgeInsets.only(right: 4),
                child: Text(
                  '\$',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print(widget.collection.owner?.username);
    final results = widget.collection.artworks;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildCollectionHeader(context)),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.5,
                    ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final art = results[index];
                      return Card(
                        elevation: 4,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ArtDetailScreen(),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(4),
                                  ),
                                  child: Image.network(
                                    art.imageUrl,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (
                                      context,
                                      child,
                                      loadingProgress,
                                    ) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      art.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '\$${art.price}',
                                          style: TextStyle(
                                            color: Colors.green[700],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        GestureDetector(
                                          onTap: () => _handleLike(art.id),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.favorite,
                                                size: 16,
                                                color: Colors.grey,
                                              ),
                                              Text(art.likes),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }, childCount: results.length),
                  ),
                ),
              ],
            ),
          ),
          BottomNavBar(
            currentIndex: 2, // Gallery tab
            onTap: (index) {
              // Navigation is now handled in BottomNavBar widget
            },
          ),
        ],
      ),
    );
  }
}
