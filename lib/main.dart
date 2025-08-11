import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'services/art_service.dart';
import 'models/art_data.dart';
import 'screens/splash_screen.dart';
import 'screens/category_selection_screen.dart';
import 'screens/art_detail_screen.dart';
import 'services/image_upload_service.dart';
import 'blocs/image_upload/image_upload_bloc.dart';
import 'blocs/google_lens/google_lens_bloc.dart';
import 'blocs/matches/matches_bloc.dart';
import 'package:my_project/providers/auth_provider.dart';
import 'package:my_project/screens/sign_up_screen.dart';
import 'package:my_project/blocs/signup/signup_bloc.dart';
import 'package:my_project/blocs/signin/signin_bloc.dart';
import 'blocs/collection/collection_bloc.dart';
import 'services/collection_service.dart';
import 'blocs/art_detail/art_detail_bloc.dart';
import 'blocs/profile/profile_bloc.dart';
import 'repositories/profile_repository.dart';
import 'screens/profile/profile_screen.dart';
import 'blocs/search/search_bloc.dart';
import 'blocs/boat/boat_bloc.dart';
import 'repositories/search_repository.dart';
import 'router.dart';

const String baseUrl =
    String.fromEnvironment('BASE_URL', defaultValue: 'NOT_DEFINED');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('🔥 BASE_URL from dart-define: $baseUrl');

  await dotenv.load(fileName: ".env");

  try {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      print('No cameras found on the device');
      runApp(MyApp(cameras: []));
    } else {
      runApp(MyApp(cameras: cameras));
    }
  } catch (e) {
    print('Error initializing cameras: $e');
    runApp(MyApp(cameras: []));
  }
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  const MyApp({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ImageUploadBloc(ImageUploadService()),
        ),
        BlocProvider(
          create: (context) => GoogleLensBloc(),
        ),
        BlocProvider(
          create: (context) => SignupBloc(),
        ),
        BlocProvider(
          create: (context) => SigninBloc(),
        ),
        BlocProvider(
          create: (context) => MatchesBloc(),
        ),
        BlocProvider(
          create: (context) => CollectionBloc(CollectionService()),
        ),
        BlocProvider(
          create: (context) => ArtDetailBloc(),
        ),
        BlocProvider(
          create: (context) => ProfileBloc(
            profileRepository: ProfileRepository(),
          ),
        ),
        BlocProvider(
          create: (context) => SearchBloc(searchRepository: SearchRepository()),
        ),
        BlocProvider(create: (context) => BoatBloc()),
      ],
      child: MaterialApp.router(
        title: 'Art Valuation App',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          useMaterial3: true,
          brightness: Brightness.light,
        ),
        routerConfig: router,
      ),
    );
  }
}

class SplashScreenWrapper extends StatefulWidget {
  final List<CameraDescription> cameras;

  const SplashScreenWrapper({super.key, required this.cameras});

  @override
  State<SplashScreenWrapper> createState() => _SplashScreenWrapperState();
}

class _SplashScreenWrapperState extends State<SplashScreenWrapper> {
  bool _showSplash = true;

  void _onSplashComplete() {
    setState(() {
      _showSplash = false;
    });
    context.go('/category-selection');
  }

  @override
  Widget build(BuildContext context) {
    return _showSplash
        ? SplashScreen(onComplete: _onSplashComplete)
        : CategorySelectionScreen();
  }
}

class LandingPage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const LandingPage({super.key, required this.cameras});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _isLoading = false;
  final ArtService _artService = ArtService();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      if (widget.cameras.isNotEmpty) {
        _controller = CameraController(
          widget.cameras[0],
          ResolutionPreset.high,
          enableAudio: false,
        );
        _initializeControllerFuture = _controller?.initialize();
        await _requestCameraPermission();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No camera found on this device'),
            ),
          );
        }
      }
    } catch (e) {
      print('Error initializing camera: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error initializing camera: $e'),
          ),
        );
      }
    }
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
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _processImage(File imageFile) async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Skip results screen and create mock data directly

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
      final image = await _controller!.takePicture();
      final imageFile = File(image.path);

      await _processImage(imageFile);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
          if (_controller != null)
            FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_controller!);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            )
          else
            const Center(
              child: Text('Camera not available'),
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
