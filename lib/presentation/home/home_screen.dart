import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Home Screen'),

          ElevatedButton(
            onPressed: () {
              if (context.locale.languageCode == 'en') {
                context.setLocale(const Locale('ar'));
              } else {
                context.setLocale(const Locale('en'));
              }
            },
            child: Text('Change Language'),
          ),

          SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3),
              ),
              // maximumSize: Size(150, 400),
              minimumSize: Size(10, 30),
            ),
            onPressed: () {},
            child: Text(
              'PickUp',
              style: TextStyle(
                color: Colors.white,
                fontSize: context.scaledFont(13),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,

    );
  }
}
