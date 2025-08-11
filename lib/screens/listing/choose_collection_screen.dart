import 'package:flutter/material.dart';
import '../dashboard_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'set_preferences_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/collection/collection_bloc.dart';
import '../../services/collection_service.dart';

class ChooseCollectionScreen extends StatefulWidget {
  final String itemName;
  final String description;
  final String creator;
  final String price;
  final String year;
  final File? itemImage;
  final String? estimatedImageUrl;
  final String birthCountry;
  final String size;
  final String yearBirth;
  final String auctionHouseResult;
  final String turnoverEvolution;
  final String worldRanking;
  final String category;
  final String subtype;

  const ChooseCollectionScreen({
    super.key,
    required this.itemName,
    required this.description,
    required this.creator,
    required this.price,
    required this.year,
    this.itemImage,
    this.estimatedImageUrl,
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
  State<ChooseCollectionScreen> createState() => _ChooseCollectionScreenState();
}

class _ChooseCollectionScreenState extends State<ChooseCollectionScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CollectionBloc>().add(LoadCollections());
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
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.gallery,
                  );

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
                            image: FileImage(selectedImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: selectedImage == null
                      ? const Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 40,
                          color: Colors.grey,
                        )
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
                setDialogState(() {
                  isUploading = true;
                });

                try {
                  context.read<CollectionBloc>().add(
                        CreateCollection(
                          name: nameController.text,
                          imageFile: selectedImage,
                        ),
                      );
                  if (mounted) {
                    Navigator.pop(context);
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error creating collection: $e')),
                    );
                    setDialogState(() {
                      isUploading = false;
                    });
                  }
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
    return BlocConsumer<CollectionBloc, CollectionState>(
      listener: (context, state) {
        if (state is CollectionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
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
                        if (state is CollectionLoading)
                          const Expanded(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        else if (state is CollectionLoaded)
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
                                        context.read<CollectionBloc>().add(
                                              SelectCollection(
                                                Collection(
                                                  id: 'single_object',
                                                  name: 'Single Object',
                                                  type: 'Artwork',
                                                ),
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
                                  ...state.collections
                                      .map(
                                        (collection) => Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 16),
                                          child: InkWell(
                                            onTap: () {
                                              context
                                                  .read<CollectionBloc>()
                                                  .add(SelectCollection(
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
                                                        8,
                                                      ),
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
                                                        Text(
                                                          '${collection.type == 'Artwork' ? collection.artworks?.length ?? 0 : collection.boats?.length ?? 0} items',
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
                                  onPressed: state is CollectionLoaded &&
                                          state.selectedCollection != null
                                      ? () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SetPreferencesScreen(
                                                itemName: widget.itemName,
                                                description: widget.description,
                                                creator: widget.creator,
                                                price: widget.price,
                                                year: widget.year,
                                                itemImage: widget.itemImage,
                                                estimatedImageUrl:
                                                    widget.estimatedImageUrl,
                                                collectionName: state
                                                    .selectedCollection!.name,
                                                collectionId: state
                                                    .selectedCollection!.id,
                                                birthCountry:
                                                    widget.birthCountry,
                                                size: widget.size,
                                                yearBirth: widget.yearBirth,
                                                auctionHouseResult:
                                                    widget.auctionHouseResult,
                                                turnoverEvolution:
                                                    widget.turnoverEvolution,
                                                worldRanking:
                                                    widget.worldRanking,
                                                category: widget.category,
                                                subtype: widget.subtype,
                                              ),
                                            ),
                                          );
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple,
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
