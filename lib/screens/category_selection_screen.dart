import 'package:flutter/material.dart';
import 'estimation_selection_screen.dart';
import '../widgets/custom_app_bar.dart';
import 'package:my_project/colors.dart';
import '../models/collection.dart';
import '../models/artwork.dart';
import '../models/boat.dart';
import '../services/api_service.dart';
import 'package:go_router/go_router.dart';
import 'admin_moderation_screen.dart';

class CategorySelectionScreen extends StatefulWidget {
  const CategorySelectionScreen({super.key});

  @override
  State<CategorySelectionScreen> createState() =>
      _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  final List<Map<String, dynamic>> categories = [
    {
      'icon': 'assets/images/car.jpg',
      'size': 100.0,
      'top': 50.0,
      'left': 0.1,
    }, // 10% from left
    {
      'icon': 'assets/images/artwork.jpg',
      'size': 120.0,
      'top': 160.0,
      'left': 0.75,
    }, // 60% from left
    {
      'icon': 'assets/images/Yacht.jpg',
      'size': 90.0,
      'top': 5.0,
      'left': 0.35,
    }, // 15% from left
    {
      'icon': 'assets/images/watch.jpg',
      'size': 110.0,
      'top': 60.0,
      'left': 0.55,
    }, // 70% from left
    {
      'icon': 'assets/images/painting.png',
      'size': 130.0,
      'top': 150.0,
      'left': 0.3,
    }, // 50% from left
    {
      'icon': 'assets/images/sculpture.jpg',
      'size': 105.0,
      'top': 160.0,
      'left': 0,
    }, // 20% from left
  ];

  List<Collection> topCollections = [];
  List<Artwork> topArtworks = [];
  List<Boat> topBoats = [];
  bool isLoading = true;
  String? errorMessage;
  final ApiService _apiService = ApiService();
  String _selectedCurrency = 'EUR';
  String _selectedRegion = 'Europe';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      print('Loading collections...');
      final collections = await _apiService.getTopCollections();
      print('Collections loaded: ${collections.length}');
      final artworks = await _apiService.getTopArtworks();
      print('Artworks loaded: ${artworks.length}');
      final boats = await _apiService.getTopBoats();
      print('Boats loaded: ${boats.length}');
      setState(() {
        topCollections = collections;
        topBoats = boats;
        topArtworks = artworks;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load data. Please try again later.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ElevatedButton(
                    onPressed: () {
                      context.go('/admin'); // Make sure this route exists
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                            color: AppColors.primaryColor,
                            width: 2), // Pink border
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Admin Moderation',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.0),
                      gradient: const LinearGradient(
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
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20),
                          Container(
                            height: 300,
                            width: double.infinity,
                            child: Stack(
                              clipBehavior: Clip.hardEdge,
                              children: [
                                ...List.generate(categories.length, (index) {
                                  final category = categories[index];
                                  final leftPosition =
                                      screenWidth * category['left'];

                                  return Positioned(
                                    top: category['top'],
                                    left: leftPosition,
                                    child: Container(
                                      width: category['size'],
                                      height: category['size'],
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black.withOpacity(0.3),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.2),
                                          width: 1,
                                        ),
                                      ),
                                      child: Container(
                                        margin: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color:
                                                Colors.white.withOpacity(0.3),
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
                          const SizedBox(height: 20),
                          const Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: const Text(
                              'AI-powered platform designed to estimate and manage valuable objects',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 200,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const EstimationSelectionScreen(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Text(
                                    'Free Estimation',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (isLoading)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  ),
                )
              else if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadData,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              else ...[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildTopCollections(),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildTopArtworks(),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildTopBoats(),
                ),
                const SizedBox(height: 24),
                _buildRegionSection(),
                _buildFollowUsSection(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopCollections() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Top Collections',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: topCollections.length,
          itemBuilder: (context, listIndex) {
            final collection = topCollections[listIndex];

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Card(
                color: Colors.grey[100],
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  tileColor: Colors.grey[100],
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          '${listIndex + 1}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      collection.imageUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                collection.imageUrl!,
                                fit: BoxFit.cover,
                                width: 60,
                                height: 60,
                              ),
                            )
                          : Icon(Icons.image,
                              size: 40, color: Colors.grey[400]),
                    ],
                  ),
                  title: Text(
                    collection.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          '${collection.type == 'Artwork' ? collection.artworkCount : collection.boatCount} items'),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTopArtworks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Top Artworks',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 300,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: topArtworks.length,
            itemBuilder: (context, index) {
              final artwork = topArtworks[index];
              return Container(
                width: MediaQuery.of(context).size.width - 120,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: artwork.imageUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                artwork.imageUrl!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            )
                          : Icon(Icons.image,
                              size: 40, color: Colors.grey[400]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      artwork.title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.favorite,
                            color: AppColors.primaryColor, size: 16),
                        Text('${artwork.likesCount ?? 0}'),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTopBoats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Top Yachts',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 300,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: topBoats.length,
            itemBuilder: (context, index) {
              final boat = topBoats[index];
              return Container(
                width: MediaQuery.of(context).size.width - 120,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: boat.imageUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                boat.imageUrl!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            )
                          : Icon(Icons.directions_boat,
                              size: 40, color: Colors.grey[400]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      boat.safeBrand,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.favorite,
                            color: AppColors.primaryColor, size: 16),
                        Text('${boat.likesCount ?? 0}'),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRegionSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Select Region'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: const Text('Europe'),
                                onTap: () {
                                  setState(() {
                                    _selectedRegion = 'Europe';
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                              // Add more regions here in the future
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Region - $_selectedRegion',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.keyboard_arrow_down, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "The world's first marketplace for collectibles and\nnon-fungible tokens NFTs",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedCurrency =
                          _selectedCurrency == 'EUR' ? 'USD' : 'EUR';
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Currency - $_selectedCurrency',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.keyboard_arrow_down, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.dark_mode_outlined),
                  onPressed: () {
                    // Handle dark mode toggle
                  },
                  color: Colors.black87,
                  iconSize: 24,
                  padding: const EdgeInsets.all(12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFollowUsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        children: [
          const Text(
            'Follow us',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialButton('assets/images/facebook.png', () {}),
              _buildSocialButton('assets/images/google.png', () {}),
              _buildSocialButton('assets/images/twitter.png', () {}),
              IconButton(
                icon: const Icon(Icons.link),
                onPressed: () {},
                iconSize: 28,
                color: AppColors.primaryColor,
              ),
              IconButton(
                icon: const Icon(Icons.business),
                onPressed: () {},
                iconSize: 28,
                color: AppColors.primaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(String iconPath, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: 40,
          height: 40,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Image.asset(
            iconPath,
            width: 24,
            height: 24,
          ),
        ),
      ),
    );
  }
}
