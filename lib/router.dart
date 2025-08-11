import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/dashboard_screen.dart';
import 'screens/boat/boat_detail_screen.dart';
import 'screens/boat/choose_collection_screen.dart';
import 'screens/boat/set_preferences_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/sign_up_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/search/search_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/profile/profile_settings_screen.dart';
import 'screens/listing/item_type_selection_screen.dart';
import 'screens/boat/boat_detail_screen.dart';
import 'widgets/auth_guard.dart';
import 'screens/splash_screen.dart';
import 'screens/category_selection_screen.dart';
import 'package:camera/camera.dart';
import 'screens/boat/ready_to_publish_screen.dart';
import 'screens/estimation_selection_screen.dart';
import 'screens/loading_screen.dart';
import 'package:my_project/screens/admin_moderation_screen.dart';

import 'main.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        final cameras = state.extra as List<CameraDescription>? ?? [];
        return SplashScreenWrapper(cameras: cameras);
      },
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/boat-detail',
      builder: (context, state) => const BoatDetailInputScreen(),
    ),
    GoRoute(
      path: '/choose-collection',
      builder: (context, state) => const ChooseBoatCollectionScreen(),
    ),
    GoRoute(
      path: '/preferences',
      builder: (context, state) => const SetBoatPreferencesScreen(),
    ),
    GoRoute(
      path: '/sign-in',
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      path: '/sign-up',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => AuthGuard(child: const ProfileScreen()),
    ),
    GoRoute(
      path: '/profile-settings',
      builder: (context, state) =>
          AuthGuard(child: const ProfileSettingsScreen()),
    ),
    GoRoute(
      path: '/item-type-selection',
      builder: (context, state) =>
          AuthGuard(child: const ItemTypeSelectionScreen()),
    ),
    GoRoute(
      path: '/category-selection',
      builder: (context, state) => const CategorySelectionScreen(),
    ),
    GoRoute(
      path: '/ready-to-publish',
      builder: (context, state) => const ReadyToPublishMyScreen(),
    ),
    GoRoute(
      path: '/estimation-selection',
      builder: (context, state) => const EstimationSelectionScreen(),
    ),
    GoRoute(
      path: '/loading',
      builder: (context, state) => const LoadingScreen(),
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => AdminModerationScreen(),
    ),
    GoRoute(
      path: '/boat',
      builder: (context, state) => const BoatDetailInputScreen(),
    ),
  ],
);
