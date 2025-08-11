import 'package:flutter/material.dart';
import '../screens/profile/profile_screen.dart';

import '../screens/dashboard_screen.dart';
import '../screens/listing/item_type_selection_screen.dart';
import '../screens/profile/profile_settings_screen.dart';
import '../screens/search/search_screen.dart';
import 'auth_guard.dart';
import 'package:my_project/colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  void _handleNavigation(BuildContext context, int index) {
    if (index == currentIndex) return; // Don't navigate if already on the page

    Widget? nextScreen;
    switch (index) {
      case 0: // Dashboard
        nextScreen = AuthGuard(child: const DashboardScreen());
        break;
      case 1: // Add Item
        nextScreen = AuthGuard(child: const ItemTypeSelectionScreen());
        break;
      case 2: // Gallery
        nextScreen = const SearchScreen();
        break;
      case 3: // Profile
        nextScreen = AuthGuard(child: const ProfileScreen());
        break;
      case 4: // Profile Settings
        nextScreen = AuthGuard(child: const ProfileSettingsScreen());
        break;
    }

    if (nextScreen != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => nextScreen!),
      );
    }

    onTap(index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => _handleNavigation(context, index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_to_photos),
            activeIcon: Icon(Icons.add_to_photos),
            label: 'Photo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            activeIcon: Icon(Icons.search),
            label: 'Gallery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            activeIcon: Icon(Icons.menu),
            label: 'Menu',
          ),
        ],
      ),
    );
  }
}
