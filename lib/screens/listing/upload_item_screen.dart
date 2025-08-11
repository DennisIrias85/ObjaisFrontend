import 'package:flutter/material.dart';
import '../dashboard_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'item_details_screen.dart';
import 'package:my_project/colors.dart';

class UploadItemScreen extends StatefulWidget {
  final String? estimatedImage;
  final String? estimatedTitle;
  final String? estimatedDescription;
  final String? estimatedYear;
  final String? estimatedPrice;
  final String? estimatedCreator;
  final String? estimatedCategory;
  final String? estimatedSize;
  final String? estimatedBirthCountry;
  final String? estimatedAuctionHouseResult;
  final String? estimatedTurnoverEvolution;
  final String? estimatedWorldRanking;
  final String? estimatedYearBirth;
  final String? estimatedSubType;
  const UploadItemScreen({
    super.key,
    this.estimatedImage,
    this.estimatedPrice,
    this.estimatedTitle,
    this.estimatedDescription,
    this.estimatedYear,
    this.estimatedCreator,
    this.estimatedCategory,
    this.estimatedSize,
    this.estimatedBirthCountry,
    this.estimatedAuctionHouseResult,
    this.estimatedTurnoverEvolution,
    this.estimatedWorldRanking,
    this.estimatedYearBirth,
    this.estimatedSubType,
  });

  @override
  State<UploadItemScreen> createState() => _UploadItemScreenState();
}

class _UploadItemScreenState extends State<UploadItemScreen> {
  File? _selectedFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.estimatedImage != null && widget.estimatedImage!.isNotEmpty)
      Container(
        height: 200,
        width: double.infinity,
        child: Image.network(
          widget.estimatedImage!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Placeholder(),
        ),
      );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedFile = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            // Container(padding: const EdgeInsets.only(top: 20)),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 10),
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
                                  builder: (context) => const DashboardScreen(),
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
                            'Upload Item',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'They all serve the same purpose, but each\none takes a different',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                width: double.infinity,
                                height: 300,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey[300]!,
                                    width: 2,
                                  ),
                                ),
                                child: _selectedFile != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          12,
                                        ),
                                        child: Image.file(
                                          _selectedFile!,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : widget.estimatedImage != null
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            child: Image.network(
                                              widget.estimatedImage!,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.cloud_upload,
                                                size: 48,
                                                color: Colors.grey[400],
                                              ),
                                              const SizedBox(height: 16),
                                              Text(
                                                'Drag and drop your file here',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                'or click to browse',
                                                style: TextStyle(
                                                  color: Colors.grey[400],
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Supported formats: JPG, PNG, GIF\nMax file size: 10MB',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
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
                              onPressed: _isLoading
                                  ? null
                                  : () {
                                      if (_selectedFile != null ||
                                          widget.estimatedImage != null) {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (
                                              context,
                                            ) =>
                                                ItemDetailsScreen(
                                                    itemImage: _selectedFile,
                                                    estimatedTitle:
                                                        widget.estimatedTitle,
                                                    estimatedDescription: widget
                                                        .estimatedDescription,
                                                    estimatedYear:
                                                        widget.estimatedYear,
                                                    estimatedCreator:
                                                        widget.estimatedCreator,
                                                    estimatedPrice:
                                                        widget.estimatedPrice,
                                                    estimatedImage:
                                                        widget.estimatedImage,
                                                    estimatedCategory: widget
                                                        .estimatedCategory,
                                                    estimatedSize:
                                                        widget.estimatedSize,
                                                    estimatedBirthCountry: widget
                                                        .estimatedBirthCountry,
                                                    estimatedAuctionHouseResult:
                                                        widget
                                                            .estimatedAuctionHouseResult,
                                                    estimatedTurnoverEvolution:
                                                        widget
                                                            .estimatedTurnoverEvolution,
                                                    estimatedWorldRanking: widget
                                                        .estimatedWorldRanking,
                                                    estimatedYearBirth: widget
                                                        .estimatedYearBirth,
                                                    estimatedSubType: widget
                                                        .estimatedSubType),
                                          ),
                                        );
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 0,
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text(
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
  }
}

class DragDropArea extends StatefulWidget {
  final Function(File) onFilePicked;
  final File? selectedFile;
  final VoidCallback onTap;
  final VoidCallback onCamera;

  const DragDropArea({
    super.key,
    required this.onFilePicked,
    required this.selectedFile,
    required this.onTap,
    required this.onCamera,
  });

  @override
  State<DragDropArea> createState() => _DragDropAreaState();
}

class _DragDropAreaState extends State<DragDropArea> {
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: DragTarget<String>(
        onWillAccept: (data) {
          setState(() => _isDragging = true);
          return true;
        },
        onAccept: (data) {
          setState(() => _isDragging = false);
          widget.onFilePicked(File(data));
        },
        onLeave: (data) => setState(() => _isDragging = false),
        builder: (context, candidateData, rejectedData) {
          return Container(
            decoration: BoxDecoration(
              color: _isDragging ? Colors.grey[100] : Colors.grey[50],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isDragging ? Colors.purple : Colors.grey[200]!,
                width: _isDragging ? 2 : 1,
              ),
            ),
            child: widget.selectedFile != null
                ? _buildSelectedFilePreview()
                : _buildUploadPrompt(),
          );
        },
      ),
    );
  }

  Widget _buildSelectedFilePreview() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            widget.selectedFile!,
            height: 200,
            width: 200,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          widget.selectedFile!.path.split('/').last,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        TextButton(
          onPressed: widget.onTap,
          child: const Text('Choose different file'),
        ),
      ],
    );
  }

  Widget _buildUploadPrompt() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.cloud_upload_outlined,
            size: 40,
            color: Colors.grey[400],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Drag your item to upload',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'PNG, GIF, WebP, JPEG . Maximum\nfile size 100 Mb.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.6)),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: widget.onTap,
              icon: const Icon(Icons.photo_library),
              label: const Text('Gallery'),
            ),
            const SizedBox(width: 16),
            TextButton.icon(
              onPressed: widget.onCamera,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Camera'),
            ),
          ],
        ),
      ],
    );
  }
}
