import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/art_data.dart';
import '../../models/profile_model.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../blocs/search/search_bloc.dart';
import '../../repositories/search_repository.dart';
import '../../screens/artwork/artwork_detail_screen.dart';
import '../../screens/artwork/collection_detail_screen.dart';
import 'package:my_project/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Send initial search event when screen loads
    context.read<SearchBloc>().add(SearchQueryChanged(query: ''));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reset state and trigger search when returning to the screen

    context.read<SearchBloc>().add(SearchQueryChanged(query: ''));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Image.asset(
          'assets/images/logonew.png',
          fit: BoxFit.contain,
          height: 32, // Appropriate height for app bar
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Text(
              'Explore Objects or Collections',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primaryColor,
            tabs: const [
              Tab(text: 'Artworks'),
              Tab(text: 'Yacht'),
              Tab(text: 'Collections'),
            ],
          ),
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildArtworksGrid(),
                _buildBoatsGrid(),
                _buildCollectionsGrid(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 2, // Search tab
        onTap: (index) {
          // Handle navigation
        },
      ),
    );
  }

  Widget _buildArtworksGrid() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is SearchError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        if (state is SearchResultsLoaded) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.artworks.length,
            itemBuilder: (context, index) {
              final artwork = state.artworks[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: artwork.imageUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            artwork.imageUrl!,
                            fit: BoxFit.cover,
                            width: 60,
                            height: 60,
                          ),
                        )
                      : Icon(Icons.image, size: 40, color: Colors.grey[400]),
                  title: Text(
                    artwork.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$${artwork.estimation.toStringAsFixed(2)}'),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.favorite_border),
                            onPressed: () {
                              // TODO: Implement like functionality
                            },
                          ),
                          Text('${artwork.likes}'),
                        ],
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ArtworkDetailScreen(artwork: artwork),
                      ),
                    ).then((_) {
                      // Reset the GoogleLensBloc state after returning from ArtDetailScreen
                      context
                          .read<SearchBloc>()
                          .add(SearchQueryChanged(query: ''));
                    });
                  },
                ),
              );
            },
          );
        }

        return const Center(child: Text('Start searching...'));
      },
    );
  }

  Widget _buildCollectionsGrid() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is SearchError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        if (state is SearchResultsLoaded) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.collections.length,
            itemBuilder: (context, index) {
              final collection = state.collections[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: collection.imageUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            collection.imageUrl!,
                            fit: BoxFit.cover,
                            width: 60,
                            height: 60,
                          ),
                        )
                      : Icon(Icons.collections,
                          size: 40, color: Colors.grey[400]),
                  title: Text(
                    collection.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                      '${collection.type == "Artwork" ? collection.artworks.length : collection.boats.length} items'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CollectionDetailScreen(collection: collection),
                      ),
                    );
                  },
                ),
              );
            },
          );
        }

        return const Center(child: Text('Start searching...'));
      },
    );
  }

  Widget _buildBoatsGrid() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is SearchError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        if (state is SearchResultsLoaded) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.boats.length,
            itemBuilder: (context, index) {
              final boat = state.boats[index];
              print(boat.imageUrl);
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: boat.imageUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            boat.imageUrl!,
                            fit: BoxFit.cover,
                            width: 60,
                            height: 60,
                          ),
                        )
                      : Icon(Icons.directions_boat,
                          size: 40, color: Colors.grey[400]),
                  title: Text(
                    '${boat.brand}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('\$${boat.price}'),
                    ],
                  ),
                  onTap: () {
                    // TODO: Implement boat detail screen navigation
                  },
                ),
              );
            },
          );
        }

        return const Center(child: Text('Start searching...'));
      },
    );
  }
}
