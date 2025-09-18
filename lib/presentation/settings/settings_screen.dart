import 'package:flutter/material.dart';
import 'package:speezu/core/assets/font_family.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';
import 'package:speezu/repositories/user_repository.dart';
import 'package:speezu/routes/route_names.dart';
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
        padding: const EdgeInsets.all(5.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Material(
                color: Colors.transparent,
                child: ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, RouteNames.profileInfoScreen);
                  },
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
              ),
              SizedBox(height: context.heightPct(.01)),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
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
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              RouteNames.editProfileScreen,
                            );
                          },
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
                    SizedBox(height: context.heightPct(.015)),
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
                    SizedBox(height: context.heightPct(.015)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'PHONE',
                          style: TextStyle(
                            fontSize: context.scaledFont(13),
                            color: Theme.of(context).colorScheme.onSecondary,
                            fontFamily: FontFamily.fontsPoppinsRegular,
                          ),
                        ),
                        Text(
                          userRepo?.phoneNo ?? 'No Phone',
                          style: TextStyle(
                            fontSize: context.scaledFont(13),
                            color: Theme.of(context).colorScheme.outline,
                            fontFamily: FontFamily.fontsPoppinsRegular,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: context.heightPct(.01)),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.credit_card,
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
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              RouteNames.cardInfoAddScreen,
                            );
                          },
                          icon: Icon(
                            Icons.add,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.heightPct(.01)),
                    Text(
                      Labels.defaultCreditCard,
                      style: TextStyle(
                        fontSize: context.scaledFont(13),
                        fontFamily: FontFamily.fontsPoppinsSemiBold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: context.heightPct(.01)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Labels.number,
                          style: TextStyle(
                            fontFamily: FontFamily.fontsPoppinsRegular,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                        Text(
                          maskCardNumber('1234 1234 1234 1234'),
                          style: TextStyle(
                            fontFamily: FontFamily.fontsPoppinsRegular,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.heightPct(.01)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Labels.expiredDate,
                          style: TextStyle(
                            fontFamily: FontFamily.fontsPoppinsRegular,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                        Text(
                          '12/24',
                          style: TextStyle(
                            fontFamily: FontFamily.fontsPoppinsRegular,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.heightPct(.01)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Labels.holderName,
                          style: TextStyle(
                            fontFamily: FontFamily.fontsPoppinsRegular,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                        Text(
                          'Ahmad Ejaz',
                          style: TextStyle(
                            fontFamily: FontFamily.fontsPoppinsRegular,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: context.heightPct(.01)),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
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
                          Icons.settings,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                        SizedBox(width: context.widthPct(.02)),
                        Text(
                          Labels.applicationSettings,
                          style: TextStyle(
                            fontSize: context.scaledFont(14),
                            fontFamily: FontFamily.fontsPoppinsSemiBold,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.heightPct(.01)),
                    ListTile(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          RouteNames.languagesScreen,
                        );
                      },
                      leading: Icon(
                        Icons.translate,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                      title: Text(
                        Labels.languages,
                        style: TextStyle(
                          fontSize: context.scaledFont(13),
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontFamily: FontFamily.fontsPoppinsRegular,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    SizedBox(height: context.heightPct(.01)),
                    ListTile(
                      onTap: () {
                        // Navigator.pushNamed(context, RouteNames.languagesScreen);
                      },
                      leading: Icon(
                        Icons.location_on_outlined,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                      title: Text(
                        Labels.deliveryAddresses,
                        style: TextStyle(
                          fontSize: context.scaledFont(13),
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontFamily: FontFamily.fontsPoppinsRegular,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    SizedBox(height: context.heightPct(.01)),
                    ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, RouteNames.faqsScreen);
                      },
                      leading: Icon(
                        Icons.help_outline,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                      title: Text(
                        Labels.helpAndSupport,
                        style: TextStyle(
                          fontSize: context.scaledFont(13),
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontFamily: FontFamily.fontsPoppinsRegular,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    SizedBox(height: context.heightPct(.01)),
                    ListTile(
                      onTap: () {
                        // Navigator.pushNamed(context, RouteNames.languagesScreen);
                      },
                      leading: Icon(
                        Icons.password_outlined,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                      title: Text(
                        Labels.changePassword,
                        style: TextStyle(
                          fontSize: context.scaledFont(13),
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontFamily: FontFamily.fontsPoppinsRegular,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: context.heightPct(.02)),
            ],
          ),
        ),
      ),
    );
  }

  String maskCardNumber(String cardNumber) {
    if (cardNumber.length < 4) return cardNumber;
    String last4 = cardNumber.substring(cardNumber.length - 4);
    return '**** **** **** $last4';
  }
}
