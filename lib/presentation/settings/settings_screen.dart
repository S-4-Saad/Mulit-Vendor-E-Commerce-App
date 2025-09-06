import 'package:flutter/material.dart';
import 'package:speezu/core/assets/font_family.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';
import 'package:speezu/models/user_model.dart';
import 'package:speezu/repositories/user_repository.dart';
import 'package:speezu/widgets/app_cache_image.dart';
import 'package:speezu/widgets/custom_app_bar.dart';

import '../../core/utils/labels.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});
  final userRepo = UserRepository().currentUser?.userData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(title: Labels.settings),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              title: Text(
                userRepo?.name ?? '',
                style: TextStyle(
                  fontSize: context.scaledFont(16),
                  fontFamily: FontFamily.fontsPoppinsSemiBold,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
              subtitle: Text(
                userRepo?.email ?? '',
                style: TextStyle(
                  fontSize: context.scaledFont(13),
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
              trailing: AppCacheImage(
                height: context.widthPct(0.15),
                width: context.widthPct(0.15),
                boxFit: BoxFit.fill,
                round: 500,
                imageUrl:
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTSLU5_eUUGBfxfxRd4IquPiEwLbt4E_6RYMw&s",
              ),
            ),
            SizedBox(height: context.heightPct(.01)),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.5),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                      SizedBox(width: context.widthPct(.02)),
                      Text(
                        Labels.profileSettings,
                        style: TextStyle(
                          fontSize: context.scaledFont(14),
                          fontFamily: FontFamily.fontsPoppinsSemiBold,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.edit,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.heightPct(.01)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Labels.fullName,
                        style: TextStyle(
                          fontSize: context.scaledFont(13),
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontFamily: FontFamily.fontsPoppinsRegular,
                        ),
                      ),
                      Text(
                        userRepo?.name ?? '',
                        style: TextStyle(
                          fontSize: context.scaledFont(13),
                          color: Theme.of(context).colorScheme.outline,
                          fontFamily: FontFamily.fontsPoppinsRegular,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.heightPct(.01)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Labels.email,
                        style: TextStyle(
                          fontSize: context.scaledFont(13),
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontFamily: FontFamily.fontsPoppinsRegular,
                        ),
                      ),
                      Text(
                        userRepo?.email ?? '',
                        style: TextStyle(
                          fontSize: context.scaledFont(13),
                          color: Theme.of(context).colorScheme.outline,
                          fontFamily: FontFamily.fontsPoppinsRegular,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.heightPct(.01)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        userRepo?.customFields?.phone?.name?.toUpperCase() ??
                            '',
                        style: TextStyle(
                          fontSize: context.scaledFont(13),
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontFamily: FontFamily.fontsPoppinsRegular,
                        ),
                      ),
                      Text(
                        userRepo?.customFields?.phone?.value ?? '',
                        style: TextStyle(
                          fontSize: context.scaledFont(13),
                          color: Theme.of(context).colorScheme.outline,
                          fontFamily: FontFamily.fontsPoppinsRegular,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.heightPct(.01)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        userRepo?.customFields?.address?.name?.toUpperCase() ??
                            '',
                        style: TextStyle(
                          fontSize: context.scaledFont(13),
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontFamily: FontFamily.fontsPoppinsRegular,
                        ),
                      ),
                      SizedBox(
                        width: context.widthPct(.5),
                        child: Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          userRepo?.customFields?.address?.value ?? '',
                          style: TextStyle(
                            fontSize: context.scaledFont(13),
                            color: Theme.of(context).colorScheme.outline,
                            fontFamily: FontFamily.fontsPoppinsRegular,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.heightPct(.01)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        userRepo?.customFields?.bio?.name?.toUpperCase() ?? '',
                        style: TextStyle(
                          fontSize: context.scaledFont(13),
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontFamily: FontFamily.fontsPoppinsRegular,
                        ),
                      ),
                      SizedBox(
                        width: context.widthPct(.5),
                        child: Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          userRepo?.customFields?.bio?.value ?? '',
                          style: TextStyle(
                            fontSize: context.scaledFont(13),
                            color: Theme.of(context).colorScheme.outline,
                            fontFamily: FontFamily.fontsPoppinsRegular,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
