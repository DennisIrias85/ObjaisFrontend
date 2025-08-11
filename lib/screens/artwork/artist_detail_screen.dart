import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/profile_model.dart';
import '../../blocs/profile/profile_bloc.dart';
import '../../repositories/profile_repository.dart';
import 'package:my_project/colors.dart';

class ArtistDetailScreen extends StatelessWidget {
  final ProfileModel owner;

  const ArtistDetailScreen({
    super.key,
    required this.owner,
  });

  @override
  Widget build(BuildContext context) {
    final user = owner.user;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                  ? Image.network(
                      user.avatarUrl!,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.person, size: 100),
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.fullname,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              '@${user.username}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                                ? NetworkImage(user.avatarUrl!)
                                : null,
                        child: user.avatarUrl == null || user.avatarUrl!.isEmpty
                            ? const Icon(Icons.person, size: 30)
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Following Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              user.following.toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Following',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        BlocBuilder<ProfileBloc, ProfileState>(
                          builder: (context, state) {
                            final isFollowing =
                                state is ProfileLoaded && state.isFollowing;
                            return ElevatedButton.icon(
                              onPressed: () {
                                context
                                    .read<ProfileBloc>()
                                    .add(FollowProfile());
                              },
                              icon: Icon(
                                isFollowing
                                    ? Icons.person
                                    : Icons.person_add_outlined,
                                color: Colors.white,
                              ),
                              label: Text(isFollowing ? 'Following' : 'Follow'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('About Artist'),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      children: [
                        if (user.dateOfBirth != null) ...[
                          _buildDetailRow('Date of Birth', user.dateOfBirth!),
                          const Divider(),
                        ],
                        if (user.gender != null) ...[
                          _buildDetailRow('Gender', user.gender!),
                          const Divider(),
                        ],
                        if (user.address != null && user.address!.isNotEmpty)
                          _buildDetailRow('Location', user.address!),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Contact Information'),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      children: [
                        _buildContactRow(Icons.email, user.email),
                        const Divider(),
                        if (user.phone != null && user.phone!.isNotEmpty) ...[
                          _buildContactRow(Icons.phone, user.phone!),
                          const Divider(),
                        ],
                        if (user.address != null && user.address!.isNotEmpty)
                          _buildContactRow(Icons.location_on, user.address!),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Artworks'),
                  const SizedBox(height: 12),
                  if (owner.artworks.isNotEmpty)
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: owner.artworks.length,
                      itemBuilder: (context, index) {
                        final artwork = owner.artworks[index];
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
                                          borderRadius:
                                              const BorderRadius.vertical(
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
                                              size: 40,
                                              color: Colors.grey[400]),
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
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: const Center(
                        child: Text(
                          'No artworks available',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
