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

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                // Profile Header Card
                _buildProfileCard(context, userData),

                const SizedBox(height: 16),

                // Profile Details Section
                _buildProfileDetailsSection(context, userData),

                const SizedBox(height: 16),

                // App Settings Section
                _buildAppSettingsSection(context),

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, dynamic userData) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Image with gradient border
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary.withOpacity(0.3),
                  theme.colorScheme.primary.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(50),
              ),
              padding: const EdgeInsets.all(2),
              child: AppCacheImage(
                height: 70,
                width: 70,
                boxFit: BoxFit.cover,
                round: 500,
                imageUrl: '$imageBaseUrl${userData?.profileImage}',
              ),
            ),
          ),

          const SizedBox(width: 16),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userData?.name ?? '',
                  style: TextStyle(
                    fontSize: context.scaledFont(17),
                    fontFamily: FontFamily.fontsPoppinsSemiBold,
                    color: theme.colorScheme.onSecondary,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userData?.email ?? '',
                  style: TextStyle(
                    fontSize: context.scaledFont(13),
                    color: theme.colorScheme.outline,
                    fontFamily: FontFamily.fontsPoppinsRegular,
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

  Widget _buildProfileDetailsSection(BuildContext context, dynamic userData) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.person_outline,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  Labels.profileSettings,
                  style: TextStyle(
                    fontSize: context.scaledFont(15),
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
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.edit_outlined,
                        color: theme.colorScheme.primary,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 18),
            height: 1,
            color: theme.colorScheme.outline.withOpacity(0.08),
          ),

          // Profile Details
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                _buildInfoRow(
                  context,
                  Labels.fullName,
                  userData?.name ?? '',
                ),
                const SizedBox(height: 14),
                _buildInfoRow(
                  context,
                  Labels.email,
                  userData?.email ?? '',
                ),
                const SizedBox(height: 14),
                _buildInfoRow(
                  context,
                  'PHONE',
                  userData?.phoneNo ?? 'No Phone',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: context.scaledFont(13),
            color: theme.colorScheme.onSecondary.withOpacity(0.7),
            fontFamily: FontFamily.fontsPoppinsRegular,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              fontSize: context.scaledFont(13),
              color: theme.colorScheme.onSecondary,
              fontFamily: FontFamily.fontsPoppinsMedium,
            ),
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildAppSettingsSection(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.settings_outlined,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  Labels.applicationSettings,
                  style: TextStyle(
                    fontSize: context.scaledFont(15),
                    fontFamily: FontFamily.fontsPoppinsSemiBold,
                    color: theme.colorScheme.onSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 18),
            height: 1,
            color: theme.colorScheme.outline.withOpacity(0.08),
          ),

          // Settings Items
          _buildSettingsTile(
            context,
            icon: Icons.translate_outlined,
            title: Labels.languages,
            onTap: () => Navigator.pushNamed(context, RouteNames.languagesScreen),
          ),
          _buildDivider(context),
          _buildSettingsTile(
            context,
            icon: Icons.location_on_outlined,
            title: Labels.deliveryAddresses,
            onTap: () => Navigator.pushNamed(context, RouteNames.addressBookScreen),
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
          ),
          _buildDivider(context),
          _buildSettingsTile(
            context,
            icon: Icons.help_outline,
            title: Labels.helpAndSupport,
            onTap: () => Navigator.pushNamed(context, RouteNames.faqsScreen),
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
      }) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: theme.colorScheme.primary.withOpacity(0.8),
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: context.scaledFont(14),
                    color: theme.colorScheme.onSecondary,
                    fontFamily: FontFamily.fontsPoppinsRegular,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: theme.colorScheme.outline.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      height: 1,
      color: Theme.of(context).colorScheme.outline.withOpacity(0.06),
    );
  }
}