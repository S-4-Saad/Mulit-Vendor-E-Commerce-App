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
import 'package:speezu/widgets/app_cache_image.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/theme_bloc/theme_event.dart';
import '../auth/bloc/auth_bloc.dart';
import '../auth/bloc/auth_event.dart';
import '../nav_bar_screen/bloc/nav_bar_bloc.dart';
import '../nav_bar_screen/bloc/nav_bar_event.dart';

class DrawerWidget extends StatelessWidget {
  final currentUser = UserRepository().currentUser;

  DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // ✅ User Account Header
            GestureDetector(
              onTap: () {
                if (currentUser?.userData?.apiToken != null) {
                  Navigator.of(context).pushNamed(RouteNames.profileInfoScreen);
                } else {
                  Navigator.of(context).pushNamed(RouteNames.login);
                }
              },
              child: _buildUserHeader(context),
            ),

            // ✅ Drawer Items (connected to Bloc)
            _buildListTile(
              context,
              icon: Icons.home,
              text: Labels.home,
              onTap: () {
                context.read<NavBarBloc>().add(const SelectTab(2));
                Navigator.pop(context);
              },
            ),
            _buildListTile(
              context,
              icon: CupertinoIcons.archivebox_fill,
              text: Labels.products,
              onTap: () {
                context.read<NavBarBloc>().add(const SelectTab(0));
                Navigator.pop(context);
              },
            ),
            _buildListTile(
              context,
              icon: Icons.map,
              text: Labels.mapExplorer,
              onTap: () {
                context.read<NavBarBloc>().add(const SelectTab(1));
                Navigator.pop(context);
              },
            ),
            _buildListTile(
              context,
              icon: Icons.local_mall,
              text: Labels.myOrders,
              onTap: () {
                context.read<NavBarBloc>().add(const SelectTab(3));
                Navigator.pop(context);
              },
            ),
            _buildListTile(
              context,
              icon: Icons.favorite,
              text: Labels.favouriteFoods,
              onTap: () {
                context.read<NavBarBloc>().add(const SelectTab(4));
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.heightPct(.01)),

            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                Labels.applicationPreferences,
                style: TextStyle(
                  fontFamily: FontFamily.fontsPoppinsSemiBold,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ),

            // ✅ Other Navigation (direct pages)
            // _buildListTile(
            //   context,
            //   icon: Icons.help,
            //   text: Labels.helpAndSupport,
            //   onTap: () => Navigator.of(context).push(
            //     MaterialPageRoute(builder: (_) => const HelpScreen()),
            //   ),
            // ),
            // _buildListTile(
            //   context,
            //   icon: Icons.settings,
            //   text: S.of(context).settings,
            //   onTap: () {
            //     if (userService.currentUser.value.apiToken != null) {
            //       Navigator.of(context).push(
            //         MaterialPageRoute(builder: (_) => const SettingsScreen()),
            //       );
            //     } else {
            //       Navigator.of(context).pushReplacementNamed('/Login');
            //     }
            //   },
            // ),
            _buildListTile(
              context,
              icon: Icons.help_outline,
              text: Labels.helpAndSupport,
              onTap: () => Navigator.pushNamed(context, RouteNames.faqsScreen),
            ),
            currentUser?.userData?.apiToken == null
                ? SizedBox.shrink()
                : _buildListTile(
                  context,
                  icon: Icons.settings,
                  text: Labels.settings,
                  onTap:
                      () => Navigator.pushNamed(
                        context,
                        RouteNames.settingsScreen,
                      ),
                ),
            _buildListTile(
              context,
              icon: Icons.translate,
              text: Labels.languages,
              onTap:
                  () =>
                      Navigator.pushNamed(context, RouteNames.languagesScreen),
            ),
            //
            // // ✅ Theme Switch
            _buildListTile(
              context,
              icon:
                  Theme.of(context).brightness == Brightness.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
              text:
                  Theme.of(context).brightness == Brightness.dark
                      ? Labels.lightMode
                      : Labels.darkMode,
              onTap: () {
                final isDark = Theme.of(context).brightness == Brightness.dark;
                context.read<ThemeBloc>().add(
                  SwitchThemeEvent(
                    isDark ? AppThemeMode.light : AppThemeMode.dark,
                  ),
                );
                Navigator.pop(context);
              },
            ),
            currentUser?.userData?.apiToken == null
                ? SizedBox.shrink()
                : BlocConsumer<AuthBloc, AuthState>(
                  builder:
                      (context, state) => _buildListTile(
                        context,
                        icon: Icons.logout,
                        text: Labels.logout,
                        onTap: () {
                          context.read<AuthBloc>().add(LogOutUserEvent());
                        },
                      ),
                  listener: (context, state) {
                    if (state.logoutStatus == LogoutStatus.success) {
                      Navigator.of(
                        context,
                      ).pushReplacementNamed(RouteNames.login);
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                ),
            currentUser?.userData?.apiToken == null
                ? _buildListTile(
                  context,
                  icon: Icons.exit_to_app,
                  text: Labels.login,
                  onTap: () {
                    Navigator.of(
                      context,
                    ).pushReplacementNamed(RouteNames.login);
                  },
                )
                : SizedBox.shrink(),

            currentUser?.userData?.apiToken == null
                ? _buildListTile(
                  context,
                  icon: Icons.person_add_alt,
                  text: Labels.register,
                  onTap:
                      () => Navigator.pushReplacementNamed(
                        context,
                        RouteNames.signUp,
                      ),
                )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  /// ✅ User Header (Logged-in or Guest)
  Widget _buildUserHeader(BuildContext context) {
    if (currentUser?.userData?.apiToken != null) {
      return UserAccountsDrawerHeader(
        currentAccountPicture: CircleAvatar(
          backgroundImage:
              (currentUser?.userData?.media != null &&
                      currentUser!.userData!.media!.isNotEmpty)
                  ? NetworkImage(currentUser?.userData!.media!.first.url ?? '')
                  : null,
          child:
              (currentUser?.userData?.media == null ||
                      currentUser!.userData!.media!.isEmpty)
                  ? const Icon(Icons.person, size: 32)
                  : null,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
        ),
        arrowColor: Theme.of(context).colorScheme.onSecondary,
        currentAccountPictureSize: const Size.square(70),
        accountName: Text(
          currentUser?.userData?.name ?? '',
          style: TextStyle(
            fontFamily: FontFamily.fontsPoppinsSemiBold,
            color: Theme.of(context).colorScheme.onSecondary,
            fontSize: context.scaledFont(16),
          ),
        ),
        accountEmail: Text(
          currentUser?.userData?.email ?? '',
          style: TextStyle(
            fontFamily: FontFamily.fontsPoppinsRegular,
            color: Theme.of(context).colorScheme.onSecondary,
            fontSize: context.scaledFont(12),
            height: -0.2,
          ),
        ),
      );
    } else {
      return Column(
        children: [
          Container(
            // margin: const EdgeInsets.only(top: 20, bottom: 1),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            color: Theme.of(
              context,
            ).colorScheme.secondary.withValues(alpha: 0.1),
            child: Row(
              children: [
                Icon(
                  Icons.account_circle,
                  size: context.scaledFont(40),
                  color: Theme.of(context).colorScheme.outline,
                ),
                SizedBox(width: context.widthPct(.03)),
                Text(
                  Labels.guest,
                  style: TextStyle(
                    fontFamily: FontFamily.fontsPoppinsSemiBold,
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontSize: context.scaledFont(16),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 0,
            color: Theme.of(
              context,
            ).colorScheme.onSecondary.withValues(alpha: .3),
          ),
        ],
      );
    }
  }

  /// ✅ Reusable Drawer Tile
  ListTile _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.outline),
      title: Text(
        text,
        style: TextStyle(
          fontFamily: FontFamily.fontsPoppinsRegular,
          fontSize: context.scaledFont(12),
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
      onTap: onTap,
    );
  }
}
