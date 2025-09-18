import 'package:flutter/material.dart';
import 'package:speezu/core/assets/font_family.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';
import 'package:speezu/repositories/user_repository.dart';
import 'package:speezu/widgets/app_cache_image.dart';
import 'package:speezu/widgets/custom_app_bar.dart';

import '../../core/utils/labels.dart';

class ProfileInfoScreen extends StatelessWidget {
  ProfileInfoScreen({super.key});
  final currentUser = UserRepository().currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Labels.profile),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: context.heightPct(.35),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(60),
                bottomRight: Radius.circular(60),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppCacheImage(
                  imageUrl:
                      'https://tse1.mm.bing.net/th/id/OET.7252da000e8341b2ba1fb61c275c1f30?w=594&h=594&c=7&rs=1&r=0&o=5&pid=1.9&ucfimg=1',
                  width: context.heightPct(.13),
                  height: context.heightPct(.13),
                  round: 500,
                ),
                Text(
                  currentUser?.userData?.name ?? 'User Name',
                  style: TextStyle(
                    fontSize: context.scaledFont(18),
                    fontWeight: FontWeight.w600,
                    fontFamily: FontFamily.fontsPoppinsSemiBold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                SizedBox(
                  width: context.widthPct(.8),
                  child: Text(
                    currentUser?.userData?.phoneNo ?? 'No Phone Found',
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: context.scaledFont(14),
                      fontWeight: FontWeight.w400,
                      fontFamily: FontFamily.fontsPoppinsRegular,
                      color: Theme.of(context).colorScheme.onPrimary,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: context.heightPct(.03)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    SizedBox(width: context.widthPct(.05)),
                    Text(
                      Labels.about,
                      style: TextStyle(
                        fontSize: context.scaledFont(14),
                        fontFamily: FontFamily.fontsPoppinsSemiBold,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),

                  ],
                ),
                SizedBox(height: context.heightPct(.02)),
                Text(
                  currentUser?.userData?.email ?? 'No Email Found',
                  style: TextStyle(
                    fontSize: context.scaledFont(12),
                    fontFamily: FontFamily.fontsPoppinsRegular,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
                SizedBox(height: context.heightPct(.03)),
                Row(
                  children: [
                    Icon(
                      Icons.shopping_basket_outlined,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    SizedBox(width: context.widthPct(.05)),
                    Text(
                      Labels.resentOrders,
                      style: TextStyle(
                        fontSize: context.scaledFont(14),
                        fontFamily: FontFamily.fontsPoppinsSemiBold,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),

                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
