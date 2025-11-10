import 'package:flutter/material.dart';
import 'package:speezu/core/assets/font_family.dart';
import 'package:speezu/core/services/urls.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';
import 'package:speezu/presentation/auth/change_password_screen.dart';
import 'package:speezu/repositories/user_repository.dart';
import 'package:speezu/routes/route_names.dart';
import 'package:speezu/widgets/app_cache_image.dart';
import 'package:speezu/widgets/custom_app_bar.dart';
import 'package:speezu/presentation/settings/payment/card_info_add_screen.dart';
import 'package:speezu/models/user_model.dart';
import '../../core/utils/labels.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(title: Labels.settings),
      body: StreamBuilder<UserModel?>(
        stream: UserRepository().userStream,
        initialData: UserRepository().currentUser,
        builder: (context, snapshot) {
          final userData = snapshot.data?.userData;

          return LayoutBuilder(
            builder: (context, constraints) {
              // Define breakpoints
              final screenWidth = MediaQuery.of(context).size.width;
              final bool isMobile = screenWidth < 600;
              final bool isTablet = screenWidth >= 600 && screenWidth < 1024;
              final bool isLargeTablet = screenWidth >= 1024;

              // Responsive values
              final double horizontalPadding = isMobile ? 16 : (isTablet ? 32 : 48);
              final double verticalPadding = isMobile ? 12 : (isTablet ? 20 : 24);
              final double cardSpacing = isMobile ? 16 : (isTablet ? 20 : 24);
              final double maxWidth = isLargeTablet ? 1200 : double.infinity;

              return Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: verticalPadding,
                    ),
                    child: isLargeTablet
                        ? _buildLargeTabletLayout(context, userData, cardSpacing)
                        : _buildMobileTabletLayout(context, userData, cardSpacing),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Layout for large tablets (side-by-side)
  Widget _buildLargeTabletLayout(BuildContext context, dynamic userData, double spacing) {
    return Column(
      children: [
        // Profile Header Card - Full width with gradient
        _buildEnhancedProfileCard(context, userData, true),
        SizedBox(height: spacing),

        // Two column layout
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left column - Profile Details
            Expanded(
              child: _buildProfileDetailsSection(context, userData, true),
            ),
            SizedBox(width: spacing),

            // Right column - App Settings
            Expanded(
              child: _buildAppSettingsSection(context, true),
            ),
          ],
        ),
        SizedBox(height: spacing),
      ],
    );
  }

  // Layout for mobile and tablet (stacked)
  Widget _buildMobileTabletLayout(BuildContext context, dynamic userData, double spacing) {
    return Column(
      children: [
        _buildEnhancedProfileCard(context, userData, false),
        SizedBox(height: spacing),
        _buildProfileDetailsSection(context, userData, false),
        SizedBox(height: spacing),
        _buildAppSettingsSection(context, false),
        SizedBox(height: spacing * 1.5),
      ],
    );
  }

  Widget _buildEnhancedProfileCard(BuildContext context, dynamic userData, bool isLarge) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;

    final double imageSize = isMobile ? 70 : (isLarge ? 90 : 80);
    final double titleSize = isMobile ? 17 : (isLarge ? 20 : 18);
    final double subtitleSize = isMobile ? 13 : (isLarge ? 15 : 14);

    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : (isLarge ? 28 : 24)),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(isMobile ? 20 : 24),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Image with enhanced gradient border
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
             color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(100),
              ),
              padding: const EdgeInsets.all(3),
              child: AppCacheImage(
                height: imageSize,
                width: imageSize,
                boxFit: BoxFit.cover,
                round: 500,
                imageUrl: '$imageBaseUrl${userData?.profileImage}',
              ),
            ),
          ),

          SizedBox(width: isMobile ? 16 : 20),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userData?.name ?? '',
                  style: TextStyle(
                    fontSize: titleSize,
                    fontFamily: FontFamily.fontsPoppinsSemiBold,
                    color: theme.colorScheme.onSecondary,
                    letterSpacing: 0.3,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: isMobile ? 4 : 6),
                Row(
                  children: [
                    Icon(
                      Icons.email_outlined,
                      size: isMobile ? 14 : 16,
                      color: theme.colorScheme.primary.withOpacity(0.7),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        userData?.email ?? '',
                        style: TextStyle(
                          fontSize: subtitleSize,
                          color: theme.colorScheme.outline,
                          fontFamily: FontFamily.fontsPoppinsRegular,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetailsSection(BuildContext context, dynamic userData, bool isLarge) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(isMobile ? 20 : 24),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 6),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          // Section Header
          Padding(
            padding: EdgeInsets.all(isMobile ? 18 : 22),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isMobile ? 8 : 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary.withOpacity(0.15),
                        theme.colorScheme.primary.withOpacity(0.08),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.person_outline,
                    color: theme.colorScheme.primary,
                    size: isMobile ? 20 : 22,
                  ),
                ),
                SizedBox(width: isMobile ? 12 : 14),
                Text(
                  Labels.profileSettings,
                  style: TextStyle(
                    fontSize: context.scaledFont(isMobile ? 15 : 16),
                    fontFamily: FontFamily.fontsPoppinsSemiBold,
                    color: theme.colorScheme.onSecondary,
                  ),
                ),
                const Spacer(),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, RouteNames.editProfileScreen);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: EdgeInsets.all(isMobile ? 8 : 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary.withOpacity(0.15),
                            theme.colorScheme.primary.withOpacity(0.08),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.edit_outlined,
                        color: theme.colorScheme.primary,
                        size: isMobile ? 18 : 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Divider with gradient
          Container(
            margin: EdgeInsets.symmetric(horizontal: isMobile ? 18 : 22),
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  theme.colorScheme.outline.withOpacity(0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // Profile Details
          Padding(
            padding: EdgeInsets.all(isMobile ? 18 : 22),
            child: Column(
              children: [
                _buildInfoRow(
                  context,
                  Labels.fullName,
                  userData?.name ?? '',
                  Icons.person_outline,
                  isLarge,
                ),
                SizedBox(height: isMobile ? 14 : 16),
                _buildInfoRow(
                  context,
                  Labels.email,
                  userData?.email ?? '',
                  Icons.email_outlined,
                  isLarge,
                ),
                SizedBox(height: isMobile ? 14 : 16),
                _buildInfoRow(
                  context,
                  'PHONE',
                  userData?.phoneNo ?? 'No Phone',
                  Icons.phone_outlined,
                  isLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value, IconData icon, bool isLarge) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;

    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.08),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: isMobile ? 18 : 20,
            color: theme.colorScheme.primary.withOpacity(0.7),
          ),
          SizedBox(width: isMobile ? 10 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: context.scaledFont(isMobile ? 11 : 12),
                    color: theme.colorScheme.onSecondary.withOpacity(0.6),
                    fontFamily: FontFamily.fontsPoppinsRegular,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: context.scaledFont(isMobile ? 13 : 14),
                    color: theme.colorScheme.onSecondary,
                    fontFamily: FontFamily.fontsPoppinsMedium,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppSettingsSection(BuildContext context, bool isLarge) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(isMobile ? 20 : 24),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 6),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          // Section Header
          Padding(
            padding: EdgeInsets.all(isMobile ? 18 : 22),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isMobile ? 8 : 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary.withOpacity(0.15),
                        theme.colorScheme.primary.withOpacity(0.08),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.settings_outlined,
                    color: theme.colorScheme.primary,
                    size: isMobile ? 20 : 22,
                  ),
                ),
                SizedBox(width: isMobile ? 12 : 14),
                Text(
                  Labels.applicationSettings,
                  style: TextStyle(
                    fontSize: context.scaledFont(isMobile ? 15 : 16),
                    fontFamily: FontFamily.fontsPoppinsSemiBold,
                    color: theme.colorScheme.onSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Divider with gradient
          Container(
            margin: EdgeInsets.symmetric(horizontal: isMobile ? 18 : 22),
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  theme.colorScheme.outline.withOpacity(0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // Settings Items
          _buildSettingsTile(
            context,
            icon: Icons.translate_outlined,
            title: Labels.languages,
            onTap: () => Navigator.pushNamed(context, RouteNames.languagesScreen),
            isLarge: isLarge,
          ),
          _buildDivider(context),
          _buildSettingsTile(
            context,
            icon: Icons.location_on_outlined,
            title: Labels.deliveryAddresses,
            onTap: () => Navigator.pushNamed(context, RouteNames.addressBookScreen),
            isLarge: isLarge,
          ),
          _buildDivider(context),
          _buildSettingsTile(
            context,
            icon: Icons.credit_card_outlined,
            title: 'Payment Method',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CardInfoAddScreen()),
            ),
            isLarge: isLarge,
          ),
          _buildDivider(context),
          _buildSettingsTile(
            context,
            icon: Icons.help_outline,
            title: Labels.helpAndSupport,
            onTap: () => Navigator.pushNamed(context, RouteNames.faqsScreen),
            isLarge: isLarge,
          ),
          _buildDivider(context),
          _buildSettingsTile(
            context,
            icon: Icons.lock_outline,
            title: Labels.changePassword,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
            ),
            isLarge: isLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
        required bool isLarge,
      }) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(0),
        splashColor: theme.colorScheme.primary.withOpacity(0.08),
        highlightColor: theme.colorScheme.primary.withOpacity(0.05),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 18 : 22,
            vertical: isMobile ? 16 : 18,
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(isMobile ? 10 : 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary.withOpacity(0.1),
                      theme.colorScheme.primary.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: theme.colorScheme.primary,
                  size: isMobile ? 20 : 22,
                ),
              ),
              SizedBox(width: isMobile ? 14 : 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: context.scaledFont(isMobile ? 14 : 15),
                    color: theme.colorScheme.onSecondary,
                    fontFamily: FontFamily.fontsPoppinsRegular,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: isMobile ? 16 : 18,
                color: theme.colorScheme.primary.withOpacity(0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: isMobile ? 18 : 22),
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Theme.of(context).colorScheme.outline.withOpacity(0.08),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}