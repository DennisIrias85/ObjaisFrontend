import 'package:flutter/material.dart';
import '../dashboard_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'set_preferences_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/blocs/collection/collection_bloc.dart'
    as collection_bloc;
import '../../models/boat.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/collection.dart';

class ChooseBoatCollectionScreen extends StatefulWidget {
  const ChooseBoatCollectionScreen({super.key});

  @override
  State<ChooseBoatCollectionScreen> createState() =>
      _ChooseBoatCollectionScreenState();
}

class _ChooseBoatCollectionScreenState
    extends State<ChooseBoatCollectionScreen> {
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadUserIdAndCollections();
  }

  Future<void> _loadUserIdAndCollections() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUserId = prefs.getString('user_id');
    });
    context
        .read<collection_bloc.CollectionBloc>()
        .add(collection_bloc.LoadCollections());
  }

  Future<void> _showCreateCollectionDialog() async {
    final nameController = TextEditingController();
    File? selectedImage;
    bool isUploading = false;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Create new collection'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () async {
                  if (isUploading) return;

                  final ImagePicker picker = ImagePicker();
                  final XFile? image =
                      await picker.pickImage(source: ImageSource.gallery);

                  if (image != null) {
                    setDialogState(() {
                      selectedImage = File(image.path);
                    });
                  }
                },
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    image: selectedImage != null
                        ? DecorationImage(
                            image: FileImage(selectedImage!), fit: BoxFit.cover)
                        : null,
                  ),
                  child: selectedImage == null
                      ? const Icon(Icons.add_photo_alternate_outlined,
                          size: 40, color: Colors.grey)
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Collection name',
                  hintText: 'Enter collection name',
                ),
              ),
              if (isUploading) ...[
                const SizedBox(height: 16),
                const CircularProgressIndicator(),
                const SizedBox(height: 8),
                const Text('Creating collection...'),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please enter a collection name')),
                  );
                  return;
                }

                if (selectedImage == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Please add a profile image for the collection')),
                  );
                  return;
                }

                setDialogState(() {
                  isUploading = true;
                });

                try {
                  context.read<collection_bloc.CollectionBloc>().add(
                        collection_bloc.CreateCollection(
                          name: nameController.text.trim(),
                          imageFile: selectedImage,
                        ),
                      );

                  await Future.delayed(const Duration(milliseconds: 300));

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error creating collection: $e')),
                    );
                  }

                  setDialogState(() {
                    isUploading = false;
                  });
                }
              },
              child: const Text('Create Collection'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<collection_bloc.CollectionBloc,
        collection_bloc.CollectionState>(
      listener: (context, state) {
        if (state is collection_bloc.CollectionCreated) {
          _loadUserIdAndCollections();
        }

        if (state is collection_bloc.CollectionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        // 🔍 Debug print block
        if (state is collection_bloc.CollectionLoaded &&
            _currentUserId != null) {
          print('👤 Logged in as: $_currentUserId');
          for (final c in state.collections) {
            print('📦 Collection: ${c.name} | ownerId: ${c.ownerId}');
          }
        }
        // Filter the collections based on the current user's ID
        final filteredCollections =
            state is collection_bloc.CollectionLoaded && _currentUserId != null
                ? state.collections
                    .where((collection) => collection.ownerId == _currentUserId)
                    .toList()
                : [];

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
                          padding: const EdgeInsets.all(24.0),
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
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              const Text(
                                'How would you like to store your valuable item?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'You can store it as a standalone item, add it to an existing collection, or start a brand-new one—your choice, your style.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (state is collection_bloc.CollectionLoading ||
                            _currentUserId == null)
                          const Expanded(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        else if (state is collection_bloc.CollectionLoaded)
                          Expanded(
                            child: SingleChildScrollView(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Column(
                                children: [
                                  // Create new collection button
                                  InkWell(
                                    onTap: _showCreateCollectionDialog,
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[50],
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: Colors.grey[200]!),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 48,
                                            height: 48,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: const Icon(
                                              Icons.add,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          const Text(
                                            'Create new collection',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  // Register as single object option
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5F5F5),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        context
                                            .read<
                                                collection_bloc
                                                .CollectionBloc>()
                                            .add(
                                              collection_bloc.SelectCollection(
                                                collection_bloc.Collection(
                                                    id: 'single_object',
                                                    name: 'Single Object',
                                                    type: 'Boat',
                                                    ownerId:
                                                        _currentUserId ?? ''),
                                              ),
                                            );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: state.selectedCollection
                                                        ?.name ==
                                                    'Single Object'
                                                ? const Color(0xFF800080)
                                                : Colors.transparent,
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 48,
                                              height: 48,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF800080)
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: const Icon(
                                                Icons.star_outline_rounded,
                                                color: Color(0xFF800080),
                                                size: 28,
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Register this item as a standalone object',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(0xFF333333),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    'No collection required',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black
                                                          .withOpacity(0.6),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            if (state
                                                    .selectedCollection?.name ==
                                                'Single Object')
                                              const Icon(
                                                Icons.check_circle,
                                                color: Color(0xFF800080),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  // Existing collections
                                  ...filteredCollections
                                      .map(
                                        (collection) => Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 16),
                                          child: InkWell(
                                            onTap: () {
                                              context
                                                  .read<
                                                      collection_bloc
                                                      .CollectionBloc>()
                                                  .add(collection_bloc
                                                      .SelectCollection(
                                                          collection));
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[50],
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color:
                                                      state.selectedCollection ==
                                                              collection
                                                          ? const Color(
                                                              0xFF800080)
                                                          : Colors.grey[200]!,
                                                  width:
                                                      state.selectedCollection ==
                                                              collection
                                                          ? 2
                                                          : 1,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  if (collection.imageUrl !=
                                                      null)
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      child: Image.network(
                                                        collection.imageUrl!,
                                                        fit: BoxFit.cover,
                                                        width: 48,
                                                        height: 48,
                                                      ),
                                                    )
                                                  else
                                                    Container(
                                                      width: 48,
                                                      height: 48,
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[200],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                    ),
                                                  const SizedBox(width: 16),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          collection.name,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 4),
                                                        // Fix is here: use collection.boatCount
                                                        Text(
                                                          '${collection.boats.length} items',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.6),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  if (state
                                                          .selectedCollection ==
                                                      collection)
                                                    const Icon(
                                                      Icons.check_circle,
                                                      color: Color(0xFF800080),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ],
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: state is collection_bloc
                                              .CollectionLoaded &&
                                          state.selectedCollection != null
                                      ? () async {
                                          final prefs = await SharedPreferences
                                              .getInstance();
                                          await prefs.setString(
                                              'selected_collection_id',
                                              state.selectedCollection!.id);
                                          await prefs.setString(
                                              'selected_collection_name',
                                              state.selectedCollection!.name);
                                          final boat = GoRouterState.of(context)
                                              .extra as Map<String, dynamic>;
                                          print(boat);
                                          print("@@@@@@@@@@@");
                                          print(boat['boat']?.boatImage);
                                          if (mounted) {
                                            context.go('/preferences',
                                                extra: {'boat': boat['boat']});
                                          }
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF410332),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    'Next',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
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
          ),
        );
      },
    );
  }
}
