import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/art_data.dart';
import '../../models/profile_model.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../blocs/profile/profile_bloc.dart';
import '../../repositories/profile_repository.dart';
import 'profile_settings_screen.dart';
import 'package:my_project/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    context.read<ProfileBloc>().add(LoadProfile());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ProfileError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${state.message}'),
            ),
          );
        }

        if (state is ProfileLoaded) {
          print(state.profile);
          return _buildProfileScreen(state);
        }

        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget _buildProfileScreen(ProfileLoaded state) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                // Header with background
                Container(
                  height: 280,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/users/profile_bg.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      children: [
                        // App Bar
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.arrow_back_ios_outlined,
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        // Profile Image
                        Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 24),
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 45,
                                  backgroundImage: state
                                              .profile.user.avatarUrl !=
                                          null
                                      ? NetworkImage(
                                          state.profile.user.avatarUrl!)
                                      : const AssetImage(
                                              'assets/images/default_avatar.png')
                                          as ImageProvider,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 16,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.verified,
                                  color: Color(0xFFFFA00D9),
                                  size: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Rest of the content
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Name
                      Text(
                        state.profile.user.fullname,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          state.profile.user.description ?? '',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Follow Button Row
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     ElevatedButton.icon(
                      //       onPressed: () {
                      //         context.read<ProfileBloc>().add(FollowProfile());
                      //       },
                      //       icon: Icon(
                      //         state.isFollowing
                      //             ? Icons.person
                      //             : Icons.person_add_outlined,
                      //         color: Colors.white,
                      //       ),
                      //       label: Text(
                      //           state.isFollowing ? 'Following' : 'Follow'),
                      //       style: ElevatedButton.styleFrom(
                      //         backgroundColor: AppColors.primaryColor,
                      //         foregroundColor: Colors.white,
                      //         padding: const EdgeInsets.symmetric(
                      //           horizontal: 24,
                      //           vertical: 12,
                      //         ),
                      //         shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(30),
                      //         ),
                      //       ),
                      //     ),
                      //     const SizedBox(width: 12),
                      //     Container(
                      //       decoration: BoxDecoration(
                      //         shape: BoxShape.circle,
                      //         border: Border.all(color: Colors.grey[300]!),
                      //       ),
                      //       child: IconButton(
                      //         icon: const Icon(Icons.share_outlined),
                      //         onPressed: () {},
                      //         color: Colors.black,
                      //       ),
                      //     ),
                      //     const SizedBox(width: 12),
                      //     Container(
                      //       decoration: BoxDecoration(
                      //         shape: BoxShape.circle,
                      //         border: Border.all(color: Colors.grey[300]!),
                      //       ),
                      //       child: IconButton(
                      //         icon: const Icon(Icons.more_horiz),
                      //         onPressed: () {},
                      //         color: Colors.black,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(height: 24),
                      // Stats Row
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[200]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStat(
                              state.profile.user.following.toString(),
                              'followers',
                            ),
                            _buildStatDivider(),
                            _buildStat(
                              state.profile.totalArtworks.toString(),
                              'Valuables objects',
                            ),
                            _buildStatDivider(),
                            _buildStat(
                              state.profile.totalCollections.toString(),
                              'Collection',
                            ),
                            _buildStatDivider(),
                            _buildStat(
                              state.profile.totalValue.toString(),
                              'Net Worth',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Tabs
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: AppColors.primaryColor,
                  tabs: const [
                    Tab(text: 'All'),
                    Tab(text: 'Collections'),
                  ],
                ),
                // Tab Content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildGridView(), // All
                      _buildCollectionsGridView(
                          state.profile.collections), // Collections
                    ],
                  ),
                ),
              ],
            ),
          ),
          BottomNavBar(
            currentIndex: 3, // Profile tab
            onTap: (index) {
              // Handle navigation
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(height: 24, width: 1, color: Colors.grey[300]);
  }

  Widget _buildGridView() {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is! ProfileLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: state.profile.artworks.length,
          itemBuilder: (context, index) {
            final artwork = state.profile.artworks[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        color: Colors.grey[200],
                      ),
                      child: artwork.imageUrl != null
                          ? ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              child: Image.network(
                                artwork.imageUrl!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            )
                          : Center(
                              child: Icon(Icons.image,
                                  size: 40, color: Colors.grey[400]),
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          artwork.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\$${artwork.estimation.toStringAsFixed(2)}',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCollectionsGridView(List<Collection> collections) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: collections.length,
      itemBuilder: (context, index) {
        final collection = collections[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    color: Colors.grey[200],
                  ),
                  child: collection.artworks.isNotEmpty &&
                          collection.imageUrl != null
                      ? ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: Image.network(
                            collection.imageUrl!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        )
                      : Center(
                          child: Icon(Icons.collections,
                              size: 40, color: Colors.grey[400]),
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      collection.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${collection.artworks.length} items',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
