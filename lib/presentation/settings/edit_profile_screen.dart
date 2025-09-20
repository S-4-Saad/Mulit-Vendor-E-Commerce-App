import 'package:flutter/material.dart';
import 'package:speezu/core/assets/font_family.dart';
import 'package:speezu/core/utils/app_validators.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';
import 'package:speezu/repositories/user_repository.dart';
import 'package:speezu/widgets/app_cache_image.dart';
import 'package:speezu/widgets/custom_app_bar.dart';
import 'package:speezu/widgets/custom_text_form_field.dart';

import '../../core/utils/labels.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final currentUser = UserRepository().currentUser;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  FocusNode nameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  final _editProfileFormKey = GlobalKey<FormState>();
  final UserRepository _userRepository = UserRepository();
  bool _isLoading = false;
  
  String _originalName = '';
  String _originalPhoneNo = '';

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _addListeners();
  }

  void _addListeners() {
    nameController.addListener(() {
      setState(() {});
    });
    phoneController.addListener(() {
      setState(() {});
    });
  }

  void _initializeControllers() {
    _originalName = currentUser?.userData?.name ?? '';
    _originalPhoneNo = currentUser?.userData?.phoneNo ?? '';
    
    nameController.text = _originalName;
    emailController.text = currentUser?.userData?.email ?? '';
    phoneController.text = _originalPhoneNo;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    nameFocusNode.dispose();
    emailFocusNode.dispose();
    phoneFocusNode.dispose();
    super.dispose();
  }

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
                  GestureDetector(
                    onTap: _showImagePickerDialog,
                    child: Stack(
                      children: [
                        // Profile Image
                        Container(
                          width: context.heightPct(.13),
                          height: context.heightPct(.13),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 3,
                            ),
                          ),
                          child: ClipOval(
                            child: AppCacheImage(
                              imageUrl: currentUser?.userData?.profileImage ?? 
                                  'https://tse1.mm.bing.net/th/id/OET.7252da000e8341b2ba1fb61c275c1f30?w=594&h=594&c=7&rs=1&r=0&o=5&pid=1.9&ucfimg=1',
                              width: context.heightPct(.13),
                              height: context.heightPct(.13),
                              round: 500,
                            ),
                          ),
                        ),
                        // Edit Icon
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            SizedBox(height: context.heightPct(.03)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Form(
                key: _editProfileFormKey,
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
                    isEnabled: false,
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
                    hint: currentUser?.userData?.phoneNo ?? Labels.phone,
                    focusNode: phoneFocusNode,
                    nextFocusNode: null,
                  ),
                  SizedBox(height: 30),
                  
                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _hasChanges() 
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _isLoading ? null : _saveProfile,
                      child: _isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              Labels.save,
                              style: TextStyle(
                                fontFamily: FontFamily.fontsPoppinsSemiBold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _hasChanges() {
    final currentName = nameController.text.trim();
    final currentPhone = phoneController.text.trim();
    
    return currentName != _originalName || 
           currentPhone != _originalPhoneNo;
  }

  Future<void> _saveProfile() async {
    if (_editProfileFormKey.currentState!.validate()) {
      // Check if there are any changes
      if (!_hasChanges()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No changes detected. Profile is already up to date.'),
            backgroundColor: Colors.blue,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final success = await _userRepository.updateBasicProfile(
          name: nameController.text.trim(),
          phoneNo: phoneController.text.trim(),
        );

        setState(() {
          _isLoading = false;
        });

        if (success) {
          // Update original values after successful save
          _originalName = nameController.text.trim();
          _originalPhoneNo = phoneController.text.trim();
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Profile updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update profile. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Select Profile Photo',
            style: TextStyle(
              fontFamily: FontFamily.fontsPoppinsSemiBold,
              fontSize: 16,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Camera functionality will be added soon'),
                      backgroundColor: Colors.blue,
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gallery functionality will be added soon'),
                      backgroundColor: Colors.blue,
                    ),
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
