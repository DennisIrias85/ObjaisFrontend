import 'package:flutter/material.dart';
import '../screens/auth_screen.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/signin/signin_bloc.dart';

import '../screens/dashboard_screen.dart';
import '../screens/listing/item_type_selection_screen.dart';
import '../screens/profile/profile_settings_screen.dart';
import '../screens/profile/profile_screen.dart';
import "../screens/search/search_screen.dart";
import 'auth_guard.dart';
import 'package:my_project/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: const BoxDecoration(color: Colors.white),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Menu Button
            // Logo
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 32, // Appropriate height for app bar
                    child: Image.asset(
                      'assets/images/logonew.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
            // Right side buttons
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchScreen(),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AuthGuard(child: const ItemTypeSelectionScreen()),
                      ),
                    );
                  },
                ),
                BlocBuilder<SigninBloc, SigninState>(
                  builder: (context, state) {
                    return IconButton(
                      icon: const Icon(Icons.person_outline),
                      onPressed: () {
                        if (state.isSuccess && state.token != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileScreen(),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AuthScreen(),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 8);
}
