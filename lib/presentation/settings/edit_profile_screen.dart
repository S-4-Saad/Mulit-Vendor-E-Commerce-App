import 'package:flutter/material.dart';
import 'package:speezu/core/assets/font_family.dart';
import 'package:speezu/core/utils/app_validators.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';
import 'package:speezu/repositories/user_repository.dart';
import 'package:speezu/widgets/app_cache_image.dart';
import 'package:speezu/widgets/custom_app_bar.dart';
import 'package:speezu/widgets/custom_text_form_field.dart';

import '../../core/utils/labels.dart';
import '../../routes/route_names.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});
  final currentUser = UserRepository().currentUser;
  final TextEditingController nameController = TextEditingController(
    text: UserRepository().currentUser?.userData?.name ?? '',
  );
  final TextEditingController emailController = TextEditingController(
    text: UserRepository().currentUser?.userData?.email ?? '',
  );
  final TextEditingController phoneController = TextEditingController(
    text:
        UserRepository().currentUser?.userData?.phoneNo ??
        '',
  );
  // final TextEditingController bioController = TextEditingController(
  //   text:
  //       UserRepository().currentUser?.userData?.customFields?.bio?.value ?? '',
  // );
  FocusNode nameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  FocusNode bioFocusNode = FocusNode();
  final _editProfileFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Labels.editProfile),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: context.heightPct(.25),
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
                        Labels.name,
                        style: TextStyle(
                          fontSize: context.scaledFont(14),
                          fontFamily: FontFamily.fontsPoppinsSemiBold,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  CustomTextFormField(
                    validator: AppValidators.validateRequired,
                    textEditingController: nameController,
                    hint: currentUser?.userData?.name ?? Labels.name,
                    focusNode: nameFocusNode,
                    nextFocusNode: emailFocusNode,
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.email_outlined,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                      SizedBox(width: context.widthPct(.05)),
                      Text(
                        Labels.emailAddress,
                        style: TextStyle(
                          fontSize: context.scaledFont(14),
                          fontFamily: FontFamily.fontsPoppinsSemiBold,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  CustomTextFormField(
                    validator: AppValidators.validateEmail,
                    textEditingController: emailController,
                    hint: currentUser?.userData?.email ?? Labels.email,
                    focusNode: emailFocusNode,
                    nextFocusNode: phoneFocusNode,
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.phone_android,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                      SizedBox(width: context.widthPct(.05)),
                      Text(
                        Labels.phoneNumber,
                        style: TextStyle(
                          fontSize: context.scaledFont(14),
                          fontFamily: FontFamily.fontsPoppinsSemiBold,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  CustomTextFormField(
                    validator: AppValidators.validatePhone,
                    textEditingController: phoneController,
                    hint: currentUser?.userData?.name ?? Labels.phone,
                    focusNode: phoneFocusNode,
                    nextFocusNode: bioFocusNode,
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                      SizedBox(width: context.widthPct(.05)),
                      Text(
                        Labels.bio,
                        style: TextStyle(
                          fontSize: context.scaledFont(14),
                          fontFamily: FontFamily.fontsPoppinsSemiBold,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(
                        Icons.location_city,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                      SizedBox(width: context.widthPct(.05)),
                      Text(
                        Labels.address,
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
                            RouteNames.addressBookScreen,
                          );
                        },
                        icon: Icon(
                          Icons.edit,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                    ],
                  ),
                  // Container(
                  //   width: double.infinity,
                  //
                  //   padding: EdgeInsets.all(10),
                  //   decoration: BoxDecoration(
                  //     color: Theme.of(context).colorScheme.onPrimary,
                  //     borderRadius: BorderRadius.circular(12),
                  //     border: Border.all(
                  //       color: Theme.of(
                  //         context,
                  //       ).colorScheme.outline.withValues(alpha: .3),
                  //     ),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.grey.withValues(alpha: 0.1),
                  //         spreadRadius: 1,
                  //         blurRadius: 4,
                  //         offset: const Offset(0, 2),
                  //       ),
                  //     ],
                  //   ),
                  //   child: Text(
                  //     currentUser?.userData?.customFields?.address?.view ??
                  //         'No Address Found',
                  //     maxLines: 2,
                  //     textAlign: TextAlign.start,
                  //     style: TextStyle(
                  //       fontSize: context.scaledFont(14),
                  //       fontWeight: FontWeight.w400,
                  //       fontFamily: FontFamily.fontsPoppinsRegular,
                  //       color: Theme.of(context).colorScheme.onSecondary,
                  //       overflow: TextOverflow.ellipsis,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
