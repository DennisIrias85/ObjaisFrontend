import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/art_data.dart';
import 'art_detail_screen.dart';
import 'package:my_project/colors.dart';

class LandingPage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const LandingPage({super.key, required this.cameras});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.cameras[0],
      ResolutionPreset.high,
      enableAudio: false,
    );
    _initializeControllerFuture = _controller.initialize();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isDenied) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Camera permission is required to take pictures'),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _processImage(File imageFile) async {
    try {
      setState(() {
        _isLoading = true;
      });

      if (mounted) {}

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error analyzing artwork: $e')));
      }
    }
  }

  Future<void> _takePicture() async {
    try {
      final status = await Permission.camera.status;
      if (!status.isGranted) {
        final result = await Permission.camera.request();
        if (!result.isGranted) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Camera permission is required to take pictures'),
              ),
            );
          }
          return;
        }
      }

      setState(() {
        _isLoading = true;
      });

      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      final imageFile = File(image.path);

      await _processImage(imageFile);
    } catch (e) {
      print('Error taking picture: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to take picture')));
      }
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        final imageFile = File(image.path);
        await _processImage(imageFile);
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_controller);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: SpinKitFadingCircle(color: Colors.white, size: 50.0),
              ),
            ),
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Using Emulator?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'To take a photo in the emulator:\n'
                    '1. Click the gallery icon (bottom left) to select an image\n'
                    '2. Or use the camera icon and select "File" in the camera window',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  heroTag: 'gallery',
                  onPressed: _isLoading ? null : _pickImageFromGallery,
                  child: const Icon(Icons.photo_library),
                ),
                FloatingActionButton(
                  heroTag: 'camera',
                  onPressed: _isLoading ? null : _takePicture,
                  child: const Icon(Icons.camera),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
