import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speezu/core/assets/font_family.dart';
import 'package:speezu/core/theme/theme_bloc/theme_bloc.dart';
import 'package:speezu/core/utils/labels.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';
import 'package:speezu/presentation/auth/bloc/auth_state.dart';
import 'package:speezu/repositories/user_repository.dart';
import 'package:speezu/routes/route_names.dart';
import 'package:speezu/core/services/localStorage/my-local-controller.dart';
import 'package:speezu/core/utils/constants.dart';
import 'package:speezu/models/user_model.dart';
import 'package:speezu/widgets/app_cache_image.dart';

import '../../core/services/urls.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/theme_bloc/theme_event.dart';
import '../auth/bloc/auth_bloc.dart';
import '../auth/bloc/auth_event.dart';
import '../nav_bar_screen/bloc/nav_bar_bloc.dart';
import '../nav_bar_screen/bloc/nav_bar_event.dart';

class DrawerWidget extends StatelessWidget {
  DrawerWidget({super.key});

  /// Helper method to check if user is authenticated
  Future<bool> _isUserAuthenticated() async {
    final token = await LocalStorage.getData(key: AppKeys.authToken);
    return token != null && UserRepository().currentUser != null;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surface.withValues(alpha: 0.95),
            ],
          ),
        ),
        child: FutureBuilder<bool>(
          future: _isUserAuthenticated(),
          builder: (context, snapshot) {
            final isAuthenticated = snapshot.data ?? false;

            return Column(
              children: <Widget>[
                // Premium User Header
                _buildPremiumUserHeader(context, isAuthenticated),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),

                        // Navigation Section
                        _buildSectionHeader(context, Labels.navigation),
                        _buildPremiumTile(
                          context,
                          icon: Icons.home_rounded,
                          text: Labels.home,
                          gradient: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                          onTap: () {
                            context.read<NavBarBloc>().add(const SelectTab(2));
                            Navigator.pop(context);
                          },
                        ),
                        _buildPremiumTile(
                          context,
                          icon: CupertinoIcons.cube_box_fill,
                          text: Labels.products,
                          gradient: [Color(0xFFEC4899), Color(0xFFF43F5E)],
                          onTap: () {
                            context.read<NavBarBloc>().add(const SelectTab(0));
                            Navigator.pop(context);
                          },
                        ),
                        _buildPremiumTile(
                          context,
                          icon: Icons.map_rounded,
                          text: Labels.mapExplorer,
                          gradient: [Color(0xFF10B981), Color(0xFF059669)],
                          onTap: () {
                            context.read<NavBarBloc>().add(const SelectTab(1));
                            Navigator.pop(context);
                          },
                        ),
                        _buildPremiumTile(
                          context,
                          icon: Icons.shopping_bag_rounded,
                          text: Labels.myOrders,
                          gradient: [Color(0xFFF59E0B), Color(0xFFEF4444)],
                          onTap: () {
                            context.read<NavBarBloc>().add(const SelectTab(3));
                            Navigator.pop(context);
                          },
                        ),
                        _buildPremiumTile(
                          context,
                          icon: Icons.favorite_rounded,
                          text: Labels.favouriteFoods,
                          gradient: [Color(0xFFEF4444), Color(0xFFDC2626)],
                          onTap: () {
                            context.read<NavBarBloc>().add(const SelectTab(4));
                            Navigator.pop(context);
                          },
                        ),

                        const SizedBox(height: 10),

                        // Preferences Section
                        _buildSectionHeader(
                          context,
                          Labels.applicationPreferences,
                        ),
                        _buildPremiumTile(
                          context,
                          icon: Icons.help_outline_rounded,
                          text: Labels.helpAndSupport,
                          gradient: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                          onTap:
                              () => Navigator.pushNamed(
                                context,
                                RouteNames.faqsScreen,
                              ),
                        ),
                        if (isAuthenticated)
                          _buildPremiumTile(
                            context,
                            icon: Icons.settings_rounded,
                            text: Labels.settings,
                            gradient: [Color(0xFF6B7280), Color(0xFF4B5563)],
                            onTap:
                                () => Navigator.pushNamed(
                                  context,
                                  RouteNames.settingsScreen,
                                ),
                          ),
                        _buildPremiumTile(
                          context,
                          icon: Icons.translate_rounded,
                          text: Labels.languages,
                          gradient: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                          onTap:
                              () => Navigator.pushNamed(
                                context,
                                RouteNames.languagesScreen,
                              ),
                        ),
                        _buildThemeTile(context),

                        const SizedBox(height: 1),

                        // Account Section
                        if (isAuthenticated)
                          _buildLogoutTile(context)
                        else ...[
                          _buildSectionHeader(context, Labels.account),
                          _buildPremiumTile(
                            context,
                            icon: Icons.login_rounded,
                            text: Labels.login,
                            gradient: [Color(0xFF10B981), Color(0xFF059669)],
                            onTap: () {
                              Navigator.of(
                                context,
                              ).pushReplacementNamed(RouteNames.login);
                            },
                          ),
                          _buildPremiumTile(
                            context,
                            icon: Icons.person_add_alt_rounded,
                            text: Labels.register,
                            gradient: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                            onTap:
                                () => Navigator.pushReplacementNamed(
                                  context,
                                  RouteNames.signUp,
                                ),
                          ),
                        ],

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Premium User Header
  Widget _buildPremiumUserHeader(BuildContext context, bool isAuthenticated) {
    if (isAuthenticated) {
      return StreamBuilder<UserModel?>(
        stream: UserRepository().userStream,
        initialData: UserRepository().currentUser,
        builder: (context, snapshot) {
          final userData = snapshot.data?.userData;

          return Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.85),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar with border
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: AppCacheImage(
                        imageUrl: '$imageBaseUrl${userData?.profileImage}',
                        width: 72,
                        height: 72,
                        boxFit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Name
                Text(
                  userData?.name ?? 'User',
                  style: TextStyle(
                    fontFamily: FontFamily.fontsPoppinsSemiBold,
                    color: Colors.white,
                    fontSize: context.scaledFont(18),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 4),
                // Email with icon
                Row(
                  children: [
                    Icon(
                      Icons.email_rounded,
                      size: 14,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        userData?.email ?? '',
                        style: TextStyle(
                          fontFamily: FontFamily.fontsPoppinsRegular,
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: context.scaledFont(13),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    } else {
      // Guest Header
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
              Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacementNamed(RouteNames.login);
              },
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 36,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  child: Icon(
                    Icons.person_rounded,
                    size: 40,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              Labels.guest,
              style: TextStyle(
                fontFamily: FontFamily.fontsPoppinsSemiBold,
                color: Theme.of(context).colorScheme.onSecondary,
                fontSize: context.scaledFont(18),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tap to login or register',
              style: TextStyle(
                fontFamily: FontFamily.fontsPoppinsRegular,
                color: Theme.of(
                  context,
                ).colorScheme.onSecondary.withValues(alpha: 0.7),
                fontSize: context.scaledFont(13),
              ),
            ),
          ],
        ),
      );
    }
  }

  /// Section Header
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: FontFamily.fontsPoppinsSemiBold,
          color: Theme.of(context).colorScheme.primary,
          fontSize: context.scaledFont(12),
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  /// Premium Drawer Tile
  Widget _buildPremiumTile(
    BuildContext context, {
    required IconData icon,
    required String text,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                // Icon with gradient background
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors:
                          gradient
                              .map((c) => c.withValues(alpha: 0.15))
                              .toList(),
                    ),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: gradient.first.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Icon(icon, size: 15, color: gradient.first),
                ),
                const SizedBox(width: 14),
                // Text
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontFamily: FontFamily.fontsPoppinsRegular,
                      fontSize: context.scaledFont(12),
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // Arrow
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Theme Toggle Tile
  Widget _buildThemeTile(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            context.read<ThemeBloc>().add(
              SwitchThemeEvent(isDark ? AppThemeMode.light : AppThemeMode.dark),
            );
            Navigator.pop(context);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors:
                          isDark
                              ? [
                                Color(0xFFFCD34D).withValues(alpha: 0.15),
                                Color(0xFFF59E0B).withValues(alpha: 0.15),
                              ]
                              : [
                                Color(0xFF6366F1).withValues(alpha: 0.15),
                                Color(0xFF4F46E5).withValues(alpha: 0.15),
                              ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color:
                          isDark
                              ? Color(0xFFFCD34D).withValues(alpha: 0.2)
                              : Color(0xFF6366F1).withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                    size: 20,
                    color: isDark ? Color(0xFFF59E0B) : Color(0xFF6366F1),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    isDark ? Labels.lightMode : Labels.darkMode,
                    style: TextStyle(
                      fontFamily: FontFamily.fontsPoppinsRegular,
                      fontSize: context.scaledFont(14),
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Logout Tile with Bloc Consumer
  Widget _buildLogoutTile(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      builder:
          (context, state) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  context.read<AuthBloc>().add(LogOutUserEvent());
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.red.withValues(alpha: 0.05),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.red.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.logout_rounded,
                          size: 20,
                          color: Colors.red.shade700,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          Labels.logout,
                          style: TextStyle(
                            fontFamily: FontFamily.fontsPoppinsRegular,
                            fontSize: context.scaledFont(14),
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: Colors.red.shade700.withValues(alpha: 0.5),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      listener: (context, state) {
        if (state.logoutStatus == LogoutStatus.success) {
          Navigator.of(context).pushReplacementNamed(RouteNames.login);
        } else {
          Navigator.of(context).pop();
        }
      },
    );
  }
}
