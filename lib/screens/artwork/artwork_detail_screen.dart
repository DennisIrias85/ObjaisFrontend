import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/profile_model.dart';
import '../../blocs/profile/profile_bloc.dart';
import '../../blocs/signin/signin_bloc.dart';
import '../../services/art_service.dart';
import 'artist_detail_screen.dart';
import 'package:my_project/colors.dart';
import '../auth_screen.dart';
import '../search/search_screen.dart';

class ArtworkDetailScreen extends StatefulWidget {
  final Artwork artwork;

  const ArtworkDetailScreen({
    super.key,
    required this.artwork,
  });

  @override
  State<ArtworkDetailScreen> createState() => _ArtworkDetailScreenState();
}

class _ArtworkDetailScreenState extends State<ArtworkDetailScreen> {
  final ArtService _artService = ArtService();
  bool _isLiked = false;
  int _likesCount = 0;

  @override
  void initState() {
    super.initState();
    _likesCount = int.tryParse(widget.artwork.likes ?? '0') ?? 0;
    // Check if current user has liked the artwork
    final signinState = context.read<SigninBloc>().state;
    if (signinState.isSuccess && signinState.token != null) {
      _checkIfLiked();
    }
  }

  Future<void> _checkIfLiked() async {
    try {
      final hasLiked = await _artService.hasLikedArtwork(widget.artwork.id);
      if (mounted) {
        setState(() {
          _isLiked = hasLiked;
        });
      }
    } catch (e) {
      // If there's an error, we'll assume the user hasn't liked the artwork
      if (mounted) {
        setState(() {
          _isLiked = false;
        });
      }
    }
  }

  Future<void> _handleLike() async {
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
      await _artService.likeArtwork(widget.artwork.id);
      setState(() {
        _isLiked = !_isLiked;
        _likesCount = _isLiked ? _likesCount + 1 : _likesCount - 1;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to like artwork: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
                        decoration: BoxDecoration(color: Colors.grey[100]),
                        child: widget.artwork.imageUrl != null
                            ? Image.network(
                                widget.artwork.imageUrl,
                                fit: BoxFit.fill,
                              )
                            : const Center(
                                child: Icon(Icons.image, size: 100),
                              ),
                      ),

                      Positioned(
                          top: 10,
                          right: 30,
                          child: Container(
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: _handleLike,
                                  icon: Icon(
                                    _isLiked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: _isLiked ? Colors.red : Colors.black,
                                  ),
                                ),
                                Text(_likesCount.toString()),
                              ],
                            ),
                          )),
                      // Like Button
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and Price
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.artwork.title,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '\$${widget.artwork.estimation.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Description
                        Text(
                          widget.artwork.description,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Artist Info
                        if (widget.artwork.owner != null) ...[
                          GestureDetector(
                            onTap: () {
                              context.read<ProfileBloc>().add(LoadProfile());
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BlocBuilder<ProfileBloc, ProfileState>(
                                    builder: (context, state) {
                                      if (state is ProfileLoading) {
                                        return const Scaffold(
                                          body: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      }
                                      if (state is ProfileError) {
                                        return Scaffold(
                                          body: Center(
                                            child:
                                                Text('Error: ${state.message}'),
                                          ),
                                        );
                                      }
                                      if (state is ProfileLoaded) {
                                        return ArtistDetailScreen(
                                          owner: ProfileModel(
                                            user: state.profile.user,
                                            collections: [],
                                            artworks: [],
                                            totalValue: 0,
                                            totalArtworks: 0,
                                            totalCollections: 0,
                                          ),
                                        );
                                      }
                                      return const Scaffold(
                                        body: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: widget
                                                    .artwork.owner?.avatarUrl !=
                                                null &&
                                            widget.artwork.owner!.avatarUrl!
                                                .isNotEmpty
                                        ? NetworkImage(
                                            widget.artwork.owner!.avatarUrl!)
                                        : null,
                                    child: widget.artwork.owner?.avatarUrl ==
                                                null ||
                                            widget.artwork.owner!.avatarUrl!
                                                .isEmpty
                                        ? const Icon(Icons.person, size: 30)
                                        : null,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Artist',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          widget.artwork.owner!.fullname,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                        if (widget.artwork.owner?.username !=
                                            null) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            '@${widget.artwork.owner!.username}',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),
                        // Artwork Details Grid
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1.5,
                          children: [
                            _buildInfoSection(
                              'Year',
                              widget.artwork.year,
                              Icons.calendar_today,
                            ),
                            _buildInfoSection(
                              'Category',
                              widget.artwork.category,
                              Icons.category,
                            ),
                            _buildInfoSection(
                              'Size',
                              widget.artwork.size,
                              Icons.aspect_ratio,
                            ),
                            _buildInfoSection(
                              'Auction House Result',
                              widget.artwork.auctionHouseResult,
                              Icons.gavel,
                            ),
                            _buildInfoSection(
                              'Turnover Evolution',
                              widget.artwork.turnoverEvolution,
                              Icons.trending_up,
                            ),
                            _buildInfoSection(
                              'World Ranking',
                              widget.artwork.worldRanking,
                              Icons.leaderboard,
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
    String label,
    String value,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: Colors.grey[300],
              child: Icon(
                icon,
                size: 20,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSection(UserInfo owner) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contact Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildContactRow(Icons.email, owner.email),
          if (owner.phone != null && owner.phone!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildContactRow(Icons.phone, owner.phone!),
          ],
          if (owner.address != null && owner.address!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildContactRow(Icons.location_on, owner.address!),
          ],
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
