import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speezu/core/assets/font_family.dart';
import 'package:speezu/core/theme/theme_bloc/theme_bloc.dart';
import 'package:speezu/core/utils/labels.dart';
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

enum DeviceType { mobile, mediumTablet, largeTablet }

class DrawerWidget extends StatelessWidget {
  DrawerWidget({super.key});

  /// Helper method to check if user is authenticated
  Future<bool> _isUserAuthenticated() async {
    final token = await LocalStorage.getData(key: AppKeys.authToken);
    return token != null && UserRepository().currentUser != null;
  }

  /// Determine device type based on screen width
  DeviceType _getDeviceType(double width) {
    if (width < 600) return DeviceType.mobile;
    if (width < 900) return DeviceType.mediumTablet;
    return DeviceType.largeTablet;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final deviceType = _getDeviceType(constraints.maxWidth);
        final drawerWidth = _getDrawerWidth(deviceType);

        return SizedBox(
          width: drawerWidth,
          child: Drawer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).colorScheme.surface,
                    Theme.of(
                      context,
                    ).colorScheme.surface.withValues(alpha: 0.95),
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
                      _buildPremiumUserHeader(
                        context,
                        isAuthenticated,
                        deviceType,
                      ),

                      // Scrollable Content
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: _getSpacing(deviceType, 8)),

                              // For Tablets: Use Grid Layout
                              if (deviceType != DeviceType.mobile)
                                _buildTabletNavigationGrid(context, deviceType)
                              else
                                _buildMobileNavigationList(context),

                              SizedBox(height: _getSpacing(deviceType, 10)),

                              // Preferences Section
                              _buildSectionHeader(
                                context,
                                Labels.applicationPreferences,
                                deviceType,
                              ),

                              if (deviceType != DeviceType.mobile)
                                _buildTabletPreferencesGrid(
                                  context,
                                  isAuthenticated,
                                  deviceType,
                                )
                              else
                                _buildMobilePreferencesList(
                                  context,
                                  isAuthenticated,
                                ),

                              SizedBox(height: _getSpacing(deviceType, 1)),

                              // Account Section
                              if (isAuthenticated)
                                _buildLogoutTile(context, deviceType)
                              else
                                _buildAccountSection(context, deviceType),

                              SizedBox(height: _getSpacing(deviceType, 24)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  /// Get drawer width based on device type
  double _getDrawerWidth(DeviceType type) {
    switch (type) {
      case DeviceType.mobile:
        return 280;
      case DeviceType.mediumTablet:
        return 380;
      case DeviceType.largeTablet:
        return 450;
    }
  }

  /// Get spacing based on device type
  double _getSpacing(DeviceType type, double baseSize) {
    switch (type) {
      case DeviceType.mobile:
        return baseSize;
      case DeviceType.mediumTablet:
        return baseSize * 1.3;
      case DeviceType.largeTablet:
        return baseSize * 1.5;
    }
  }

  /// Get font size multiplier
  double _getFontMultiplier(DeviceType type) {
    switch (type) {
      case DeviceType.mobile:
        return 1.0;
      case DeviceType.mediumTablet:
        return 1.15;
      case DeviceType.largeTablet:
        return 1.25;
    }
  }

  /// Tablet Navigation Grid
  Widget _buildTabletNavigationGrid(
    BuildContext context,
    DeviceType deviceType,
  ) {
    final crossAxisCount = deviceType == DeviceType.largeTablet ? 2 : 2;

    final items = [
      _NavItem(
        Icons.home_rounded,
        Labels.home,
        [Color(0xFF6366F1), Color(0xFF8B5CF6)],
        () {
          context.read<NavBarBloc>().add(const SelectTab(2));
          Navigator.pop(context);
        },
      ),
      _NavItem(
        CupertinoIcons.cube_box_fill,
        Labels.products,
        [Color(0xFFEC4899), Color(0xFFF43F5E)],
        () {
          context.read<NavBarBloc>().add(const SelectTab(0));
          Navigator.pop(context);
        },
      ),
      _NavItem(
        Icons.map_rounded,
        Labels.mapExplorer,
        [Color(0xFF10B981), Color(0xFF059669)],
        () {
          context.read<NavBarBloc>().add(const SelectTab(1));
          Navigator.pop(context);
        },
      ),
      _NavItem(
        Icons.shopping_bag_rounded,
        Labels.myOrders,
        [Color(0xFFF59E0B), Color(0xFFEF4444)],
        () {
          context.read<NavBarBloc>().add(const SelectTab(3));
          Navigator.pop(context);
        },
      ),
      _NavItem(
        Icons.favorite_rounded,
        Labels.favouriteFoods,
        [Color(0xFFEF4444), Color(0xFFDC2626)],
        () {
          context.read<NavBarBloc>().add(const SelectTab(4));
          Navigator.pop(context);
        },
      ),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _getSpacing(deviceType, 12)),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: deviceType == DeviceType.largeTablet ? 1.4 : 1.2,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _buildTabletGridTile(context, item, deviceType);
        },
      ),
    );
  }

  /// Tablet Grid Tile
  Widget _buildTabletGridTile(
    BuildContext context,
    _NavItem item,
    DeviceType deviceType,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: item.onTap,
        child: Container(
          padding: EdgeInsets.all(_getSpacing(deviceType, 12)),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:
                  item.gradient.map((c) => c.withValues(alpha: 0.1)).toList(),
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: item.gradient.first.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(_getSpacing(deviceType, 10)),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: item.gradient),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: item.gradient.first.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  item.icon,
                  size: 22 * _getFontMultiplier(deviceType),
                  color: Colors.white,
                ),
              ),
              SizedBox(height: _getSpacing(deviceType, 8)),
              Flexible(
                child: Text(
                  item.text,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: FontFamily.fontsPoppinsSemiBold,
                    fontSize: 12 * _getFontMultiplier(deviceType),
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Mobile Navigation List
  Widget _buildMobileNavigationList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, Labels.navigation, DeviceType.mobile),
        _buildPremiumTile(
          context,
          DeviceType.mobile,
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
          DeviceType.mobile,
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
          DeviceType.mobile,
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
          DeviceType.mobile,
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
          DeviceType.mobile,
          icon: Icons.favorite_rounded,
          text: Labels.favouriteFoods,
          gradient: [Color(0xFFEF4444), Color(0xFFDC2626)],
          onTap: () {
            context.read<NavBarBloc>().add(const SelectTab(4));
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  /// Tablet Preferences Grid
  Widget _buildTabletPreferencesGrid(
    BuildContext context,
    bool isAuthenticated,
    DeviceType deviceType,
  ) {
    final items = <_NavItem>[
      _NavItem(
        Icons.help_outline_rounded,
        Labels.helpAndSupport,
        [Color(0xFF3B82F6), Color(0xFF2563EB)],
        () => Navigator.pushNamed(context, RouteNames.faqsScreen),
      ),
      if (isAuthenticated)
        _NavItem(
          Icons.settings_rounded,
          Labels.settings,
          [Color(0xFF6B7280), Color(0xFF4B5563)],
          () => Navigator.pushNamed(context, RouteNames.settingsScreen),
        ),
      _NavItem(
        Icons.translate_rounded,
        Labels.languages,
        [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
        () => Navigator.pushNamed(context, RouteNames.languagesScreen),
      ),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _getSpacing(deviceType, 12)),
      child: Column(
        children: [
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildTabletCompactTile(context, item, deviceType),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildThemeTile(context, deviceType),
          ),
        ],
      ),
    );
  }

  /// Tablet Compact Tile (for preferences)
  Widget _buildTabletCompactTile(
    BuildContext context,
    _NavItem item,
    DeviceType deviceType,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: item.onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: _getSpacing(deviceType, 16),
            vertical: _getSpacing(deviceType, 14),
          ),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.onPrimary.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: item.gradient.first.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(_getSpacing(deviceType, 10)),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors:
                        item.gradient
                            .map((c) => c.withValues(alpha: 0.15))
                            .toList(),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  item.icon,
                  size: 22 * _getFontMultiplier(deviceType),
                  color: item.gradient.first,
                ),
              ),
              SizedBox(width: _getSpacing(deviceType, 14)),
              Expanded(
                child: Text(
                  item.text,
                  style: TextStyle(
                    fontFamily: FontFamily.fontsPoppinsSemiBold,
                    fontSize: 14 * _getFontMultiplier(deviceType),
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16 * _getFontMultiplier(deviceType),
                color: Theme.of(
                  context,
                ).colorScheme.outline.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Mobile Preferences List
  Widget _buildMobilePreferencesList(
    BuildContext context,
    bool isAuthenticated,
  ) {
    return Column(
      children: [
        _buildPremiumTile(
          context,
          DeviceType.mobile,
          icon: Icons.help_outline_rounded,
          text: Labels.helpAndSupport,
          gradient: [Color(0xFF3B82F6), Color(0xFF2563EB)],
          onTap: () => Navigator.pushNamed(context, RouteNames.faqsScreen),
        ),
        if (isAuthenticated)
          _buildPremiumTile(
            context,
            DeviceType.mobile,
            icon: Icons.settings_rounded,
            text: Labels.settings,
            gradient: [Color(0xFF6B7280), Color(0xFF4B5563)],
            onTap:
                () => Navigator.pushNamed(context, RouteNames.settingsScreen),
          ),
        _buildPremiumTile(
          context,
          DeviceType.mobile,
          icon: Icons.translate_rounded,
          text: Labels.languages,
          gradient: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
          onTap: () => Navigator.pushNamed(context, RouteNames.languagesScreen),
        ),
        _buildThemeTile(context, DeviceType.mobile),
      ],
    );
  }

  /// Account Section
  Widget _buildAccountSection(BuildContext context, DeviceType deviceType) {
    if (deviceType != DeviceType.mobile) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: _getSpacing(deviceType, 12)),
        child: Column(
          children: [
            _buildSectionHeader(context, Labels.account, deviceType),
            Row(
              children: [
                Expanded(
                  child: _buildTabletAccountButton(
                    context,
                    Labels.login,
                    Icons.login_rounded,
                    [Color(0xFF10B981), Color(0xFF059669)],
                    () => Navigator.of(
                      context,
                    ).pushReplacementNamed(RouteNames.login),
                    deviceType,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTabletAccountButton(
                    context,
                    Labels.register,
                    Icons.person_add_alt_rounded,
                    [Color(0xFF6366F1), Color(0xFF4F46E5)],
                    () => Navigator.pushReplacementNamed(
                      context,
                      RouteNames.signUp,
                    ),
                    deviceType,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Column(
        children: [
          _buildSectionHeader(context, Labels.account, deviceType),
          _buildPremiumTile(
            context,
            deviceType,
            icon: Icons.login_rounded,
            text: Labels.login,
            gradient: [Color(0xFF10B981), Color(0xFF059669)],
            onTap:
                () => Navigator.of(
                  context,
                ).pushReplacementNamed(RouteNames.login),
          ),
          _buildPremiumTile(
            context,
            deviceType,
            icon: Icons.person_add_alt_rounded,
            text: Labels.register,
            gradient: [Color(0xFF6366F1), Color(0xFF4F46E5)],
            onTap:
                () =>
                    Navigator.pushReplacementNamed(context, RouteNames.signUp),
          ),
        ],
      );
    }
  }

  /// Tablet Account Button
  Widget _buildTabletAccountButton(
    BuildContext context,
    String text,
    IconData icon,
    List<Color> gradient,
    VoidCallback onTap,
    DeviceType deviceType,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: _getSpacing(deviceType, 16)),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradient.map((c) => c.withValues(alpha: 0.1)).toList(),
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: gradient.first.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 28 * _getFontMultiplier(deviceType),
                color: gradient.first,
              ),
              SizedBox(height: _getSpacing(deviceType, 8)),
              Text(
                text,
                style: TextStyle(
                  fontFamily: FontFamily.fontsPoppinsSemiBold,
                  fontSize: 13 * _getFontMultiplier(deviceType),
                  color: gradient.first,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Premium User Header
  Widget _buildPremiumUserHeader(
    BuildContext context,
    bool isAuthenticated,
    DeviceType deviceType,
  ) {
    final avatarRadius =
        deviceType == DeviceType.largeTablet
            ? 44.0
            : deviceType == DeviceType.mediumTablet
            ? 40.0
            : 36.0;
    final fontSize = 18.0 * _getFontMultiplier(deviceType);
    final emailFontSize = 13.0 * _getFontMultiplier(deviceType);

    if (isAuthenticated) {
      return StreamBuilder<UserModel?>(
        stream: UserRepository().userStream,
        initialData: UserRepository().currentUser,
        builder: (context, snapshot) {
          final userData = snapshot.data?.userData;

          return Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              _getSpacing(deviceType, 20),
              _getSpacing(deviceType, 60),
              _getSpacing(deviceType, 20),
              _getSpacing(deviceType, 24),
            ),
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
                    radius: avatarRadius,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: AppCacheImage(
                        imageUrl: '$imageBaseUrl${userData?.profileImage}',
                        width: avatarRadius * 2,
                        height: avatarRadius * 2,
                        boxFit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: _getSpacing(deviceType, 16)),
                Text(
                  userData?.name ?? 'User',
                  style: TextStyle(
                    fontFamily: FontFamily.fontsPoppinsSemiBold,
                    color: Colors.white,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
                SizedBox(height: _getSpacing(deviceType, 4)),
                Row(
                  children: [
                    Icon(
                      Icons.email_rounded,
                      size: 14 * _getFontMultiplier(deviceType),
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                    SizedBox(width: _getSpacing(deviceType, 6)),
                    Expanded(
                      child: Text(
                        userData?.email ?? '',
                        style: TextStyle(
                          fontFamily: FontFamily.fontsPoppinsRegular,
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: emailFontSize,
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
      return Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
          _getSpacing(deviceType, 20),
          _getSpacing(deviceType, 60),
          _getSpacing(deviceType, 20),
          _getSpacing(deviceType, 24),
        ),
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
                  radius: avatarRadius,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  child: Icon(
                    Icons.person_rounded,
                    size: 40 * _getFontMultiplier(deviceType),
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
            ),
            SizedBox(height: _getSpacing(deviceType, 16)),
            Text(
              Labels.guest,
              style: TextStyle(
                fontFamily: FontFamily.fontsPoppinsSemiBold,
                color: Theme.of(context).colorScheme.onSecondary,
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: _getSpacing(deviceType, 4)),
            Text(
              'Tap to login or register',
              style: TextStyle(
                fontFamily: FontFamily.fontsPoppinsRegular,
                color: Theme.of(
                  context,
                ).colorScheme.onSecondary.withValues(alpha: 0.7),
                fontSize: emailFontSize,
              ),
            ),
          ],
        ),
      );
    }
  }

  /// Section Header
  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    DeviceType deviceType,
  ) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        _getSpacing(deviceType, 20),
        _getSpacing(deviceType, 12),
        _getSpacing(deviceType, 20),
        _getSpacing(deviceType, 8),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: FontFamily.fontsPoppinsSemiBold,
          color: Theme.of(context).colorScheme.primary,
          fontSize: 12 * _getFontMultiplier(deviceType),
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  /// Premium Drawer Tile (Mobile)
  Widget _buildPremiumTile(
    BuildContext context,
    DeviceType deviceType, {
    required IconData icon,
    required String text,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: _getSpacing(deviceType, 12),
        vertical: _getSpacing(deviceType, 4),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: _getSpacing(deviceType, 12),
              vertical: _getSpacing(deviceType, 5),
            ),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(_getSpacing(deviceType, 8)),
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
                  child: Icon(
                    icon,
                    size: 20 * _getFontMultiplier(deviceType),
                    color: gradient.first,
                  ),
                ),
                SizedBox(width: _getSpacing(deviceType, 14)),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontFamily: FontFamily.fontsPoppinsRegular,
                      fontSize: 14 * _getFontMultiplier(deviceType),
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14 * _getFontMultiplier(deviceType),
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
  Widget _buildThemeTile(BuildContext context, DeviceType deviceType) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: _getSpacing(deviceType, 12),
        vertical: _getSpacing(deviceType, 4),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(
            deviceType == DeviceType.mobile ? 12 : 14,
          ),
          onTap: () {
            context.read<ThemeBloc>().add(
              SwitchThemeEvent(isDark ? AppThemeMode.light : AppThemeMode.dark),
            );
            Navigator.pop(context);
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: _getSpacing(
                deviceType,
                deviceType == DeviceType.mobile ? 12 : 16,
              ),
              vertical: _getSpacing(
                deviceType,
                deviceType == DeviceType.mobile ? 5 : 14,
              ),
            ),
            decoration: BoxDecoration(
              color:
                  deviceType != DeviceType.mobile
                      ? Theme.of(
                        context,
                      ).colorScheme.onPrimary.withValues(alpha: 0.5)
                      : null,
              borderRadius: BorderRadius.circular(
                deviceType == DeviceType.mobile ? 12 : 14,
              ),
              border:
                  deviceType != DeviceType.mobile
                      ? Border.all(
                        color: (isDark ? Color(0xFFFCD34D) : Color(0xFF6366F1))
                            .withValues(alpha: 0.2),
                        width: 1,
                      )
                      : null,
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(
                    _getSpacing(
                      deviceType,
                      deviceType == DeviceType.mobile ? 8 : 10,
                    ),
                  ),
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
                    borderRadius: BorderRadius.circular(
                      deviceType == DeviceType.mobile ? 10 : 12,
                    ),
                    border:
                        deviceType == DeviceType.mobile
                            ? Border.all(
                              color:
                                  isDark
                                      ? Color(0xFFFCD34D).withValues(alpha: 0.2)
                                      : Color(
                                        0xFF6366F1,
                                      ).withValues(alpha: 0.2),
                              width: 1,
                            )
                            : null,
                  ),
                  child: Icon(
                    isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                    size:
                        (deviceType == DeviceType.mobile ? 20 : 22) *
                        _getFontMultiplier(deviceType),
                    color: isDark ? Color(0xFFF59E0B) : Color(0xFF6366F1),
                  ),
                ),
                SizedBox(width: _getSpacing(deviceType, 14)),
                Expanded(
                  child: Text(
                    isDark ? Labels.lightMode : Labels.darkMode,
                    style: TextStyle(
                      fontFamily: FontFamily.fontsPoppinsSemiBold,
                      fontSize: 14 * _getFontMultiplier(deviceType),
                      color:
                          deviceType != DeviceType.mobile
                              ? Theme.of(context).colorScheme.onSecondary
                              : Theme.of(context).colorScheme.onSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size:
                      (deviceType == DeviceType.mobile ? 14 : 16) *
                      _getFontMultiplier(deviceType),
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
  Widget _buildLogoutTile(BuildContext context, DeviceType deviceType) {
    return BlocConsumer<AuthBloc, AuthState>(
      builder:
          (context, state) => Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _getSpacing(deviceType, 12),
              vertical: _getSpacing(deviceType, 4),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(
                  deviceType == DeviceType.mobile ? 12 : 14,
                ),
                onTap: () {
                  context.read<AuthBloc>().add(LogOutUserEvent());
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: _getSpacing(
                      deviceType,
                      deviceType == DeviceType.mobile ? 12 : 16,
                    ),
                    vertical: _getSpacing(
                      deviceType,
                      deviceType == DeviceType.mobile ? 12 : 16,
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      deviceType == DeviceType.mobile ? 12 : 14,
                    ),
                    color: Colors.red.withValues(alpha: 0.05),
                    border:
                        deviceType != DeviceType.mobile
                            ? Border.all(
                              color: Colors.red.withValues(alpha: 0.2),
                              width: 1.5,
                            )
                            : null,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(
                          _getSpacing(
                            deviceType,
                            deviceType == DeviceType.mobile ? 8 : 10,
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(
                            deviceType == DeviceType.mobile ? 10 : 12,
                          ),
                          border: Border.all(
                            color: Colors.red.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.logout_rounded,
                          size:
                              (deviceType == DeviceType.mobile ? 20 : 24) *
                              _getFontMultiplier(deviceType),
                          color: Colors.red.shade700,
                        ),
                      ),
                      SizedBox(width: _getSpacing(deviceType, 14)),
                      Expanded(
                        child: Text(
                          Labels.logout,
                          style: TextStyle(
                            fontFamily: FontFamily.fontsPoppinsSemiBold,
                            fontSize: 14 * _getFontMultiplier(deviceType),
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size:
                            (deviceType == DeviceType.mobile ? 14 : 16) *
                            _getFontMultiplier(deviceType),
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

/// Helper class for navigation items
class _NavItem {
  final IconData icon;
  final String text;
  final List<Color> gradient;
  final VoidCallback onTap;

  _NavItem(this.icon, this.text, this.gradient, this.onTap);
}
