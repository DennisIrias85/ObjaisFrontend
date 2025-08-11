import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/art_service.dart';
import '../widgets/custom_app_bar.dart';
import 'art_detail_screen.dart';
import '../models/art_data.dart';
import 'loading_screen.dart';
import '../services/image_upload_service.dart';
import 'listing/visual_matches_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/image_upload/image_upload_bloc.dart';
import '../blocs/matches/matches_bloc.dart';
import 'package:my_project/colors.dart';

class EstimationSelectionScreen extends StatefulWidget {
  const EstimationSelectionScreen({super.key});

  @override
  State<EstimationSelectionScreen> createState() =>
      _EstimationSelectionScreenState();
}

class _EstimationSelectionScreenState extends State<EstimationSelectionScreen> {
  final ArtService _artService = ArtService();
  final ImageUploadService _imageUploadService = ImageUploadService();
  String _selectedItem = 'Artwork'; // Default selection

  final Map<String, Map<String, dynamic>> _items = {
    'Artwork': {
      'icon': Icons.palette,
      'title': 'Single Artwork',
      'subtitle': 'or art collection',
    },
    'Boat': {
      'icon': Icons.directions_boat,
      'title': 'Yacht',
      'subtitle': 'Estimate your boat value',
    },
  };

  @override
  void initState() {
    super.initState();
    _loadSelectedItem();
  }

  Future<void> _loadSelectedItem() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedItem = prefs.getString('selected_item') ?? 'Artwork';
    });
  }

  Future<void> _saveSelectedItem(String item) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_item', item);
  }

  Future<void> _takePicture() async {
    try {
      final cameras = await availableCameras();
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CameraScreen(
              camera: cameras[0],
              onImageCaptured: (File imageFile) {
                context.read<ImageUploadBloc>().add(
                      UploadImageEvent(imageFile),
                    );
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error accessing camera: $e')));
      }
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        final imageFile = File(image.path);

        context.read<ImageUploadBloc>().add(UploadImageEvent(imageFile));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
      }
    }
  }

  Widget _buildOptionCard(String itemKey) {
    final item = _items[itemKey]!;
    final isSelected = _selectedItem == itemKey;
    final isDisabled = itemKey == 'Car';

    return GestureDetector(
      onTap: isDisabled
          ? null
          : () async {
              setState(() {
                _selectedItem = itemKey;
              });
              await _saveSelectedItem(itemKey);
            },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDisabled
              ? Colors.grey.withOpacity(0.1)
              : isSelected
                  ? Colors.white.withOpacity(0.2)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDisabled
                ? Colors.grey.withOpacity(0.3)
                : isSelected
                    ? Colors.white
                    : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              item['icon'] as IconData,
              color: isDisabled ? Colors.grey : Colors.white,
              size: 32,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'] as String,
                  style: TextStyle(
                    color: isDisabled ? Colors.grey : Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  item['subtitle'] as String,
                  style: TextStyle(
                    color: isDisabled
                        ? Colors.grey.withOpacity(0.7)
                        : Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const Spacer(),
            if (isSelected && !isDisabled)
              const Icon(Icons.check_circle, color: Colors.white, size: 24),
            if (isDisabled)
              const Icon(Icons.lock, color: Colors.white, size: 24),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ImageUploadBloc, ImageUploadState>(
      listener: (context, state) {
        if (state is ImageUploadSuccess) {
          if (state.matches.length == 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(
                      'No matches found. Please try again or upload another image')),
            );
          } else {
            context.read<MatchesBloc>().add(SetMatches(state.matches));
            print(state.matches);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const VisualMatchesScreen(),
              ),
            );
          }
        } else if (state is ImageUploadError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("There was an error processing the image")),
          );
        }
      },
      builder: (context, state) {
        if (state is ImageUploadLoading) {
          return const LoadingScreen();
        }
        return Scaffold(
          appBar: const CustomAppBar(),
          backgroundColor: Colors.grey[100],
          body: SafeArea(
            child: Padding(
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
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 20.0,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            SizedBox(
                              width: double.infinity,
                              child: const Text(
                                'Which valuable objects would you like to estimate?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                            // Options
                            ..._items.keys
                                .map(
                                  (itemKey) => Column(
                                    children: [
                                      _buildOptionCard(itemKey),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                )
                                .toList(),
                            const Spacer(),
                            // Take a photo button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: state is ImageUploadLoading
                                    ? null
                                    : _takePicture,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: const Text(
                                  'TAKE A PHOTO',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // OR text
                            const Center(
                              child: Text(
                                'OR',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Upload a photo button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: state is ImageUploadLoading
                                    ? null
                                    : _pickImageFromGallery,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: const Text(
                                  'UPLOAD A PHOTO',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
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
            ),
          ),
        );
      },
    );
  }
}

// Camera Screen for taking photos
class CameraScreen extends StatefulWidget {
  final CameraDescription camera;
  final Function(File) onImageCaptured;

  const CameraScreen({
    super.key,
    required this.camera,
    required this.onImageCaptured,
  });

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      final imageFile = File(image.path);

      if (mounted) {
        Navigator.pop(context); // Close camera screen
        widget.onImageCaptured(imageFile);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error taking picture: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePicture,
        child: const Icon(Icons.camera),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
