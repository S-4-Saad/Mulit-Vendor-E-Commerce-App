import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speezu/core/assets/font_family.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';
import 'package:speezu/models/languages_model.dart';
import 'package:speezu/widgets/custom_app_bar.dart';

import '../../core/services/localStorage/my-local-controller.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/labels.dart';
import 'bloc/languages_bloc.dart';
import 'bloc/languages_event.dart';
import 'bloc/languages_state.dart';

class LanguageScreen extends StatefulWidget {
  LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  final LanguagesList languagesList = LanguagesList();
  Locale? savedLocale; // keep it at class level

  @override
  void initState() {
    super.initState();
    _loadSavedLocale();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Labels.languages),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.translate,
                  color: Theme.of(context).colorScheme.onSecondary,
                  size: context.scaledFont(25),
                ),
                title: Text(
                  Labels.appLanguage,
                  style: TextStyle(
                    fontSize: context.scaledFont(17),
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontFamily: FontFamily.fontsPoppinsSemiBold,
                  ),
                ),
                subtitle: Text(
                  Labels.selectYourPreferredLanguage,
                  style: TextStyle(
                    fontSize: context.scaledFont(12),
                    color: Theme.of(context).colorScheme.outline,
                    fontFamily: FontFamily.fontsPoppinsRegular,
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<LanguageBloc, LanguageState>(
                builder: (context, state) {
                  return ListView.builder(
                    itemCount: languagesList.languages.length,
                    itemBuilder: (context, index) {
                      final lang = languagesList.languages[index];

                      // ✅ safer comparison
                      final isSelected =
                          state.currentLocale.languageCode ==
                              lang.locale.languageCode &&
                          (state.currentLocale.countryCode ?? '') ==
                              (lang.locale.countryCode ?? '');

                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onPrimary,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSecondary.withValues(alpha: .3),
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          leading: Image.asset(
                            lang.flag,
                            width: 40,
                            height: 40,
                          ),
                          title: Text(
                            lang.englishName,
                            style: TextStyle(
                              fontSize: context.scaledFont(14),
                              color:
                                  isSelected
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : Theme.of(
                                        context,
                                      ).colorScheme.onSecondary,
                              fontFamily: FontFamily.fontsPoppinsSemiBold,
                            ),
                          ),
                          subtitle: Text(
                            lang.localName,
                            style: TextStyle(
                              fontSize: context.scaledFont(12),
                              color: Theme.of(context).colorScheme.outline,
                              fontFamily: FontFamily.fontsPoppinsRegular,
                            ),
                          ),
                          trailing:
                              isSelected
                                  ? Icon(
                                    Icons.check_circle,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  )
                                  : null,
                          onTap: () {
                            context.read<LanguageBloc>().add(
                              ChangeLanguage(context, lang.locale),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadSavedLocale() async {
    final langCode = await LocalStorage.getData(key: AppKeys.languageCode);
    final countryCode = await LocalStorage.getData(key: AppKeys.countryCode);

    if (langCode != null) {
      final locale =
          (countryCode != null && countryCode.isNotEmpty)
              ? Locale(langCode, countryCode)
              : Locale(langCode);

      // setState(() {
      savedLocale = locale;
      // });

      // also update bloc with saved locale
      if (mounted) {
        context.read<LanguageBloc>().add(ChangeLanguage(context, locale));
      }
    }
  }
}

class LanguagesList {
  final List<LanguageModel> _languages = [
    LanguageModel(
      locale: const Locale('en'),
      englishName: "English",
      localName: "English",
      flag: "assets/images/united-states-of-america.png",
    ),
    LanguageModel(
      locale: const Locale('ar'),
      englishName: "Arabic",
      localName: "العربية",
      flag: "assets/images/united-arab-emirates.png",
    ),
    LanguageModel(
      locale: const Locale('es'),
      englishName: "Spanish",
      localName: "Spana",
      flag: "assets/images/spain.png",
    ),
    LanguageModel(
      locale: const Locale('fr'),
      englishName: "French (France)",
      localName: "Français - France",
      flag: "assets/images/france.png",
    ),
    LanguageModel(
      locale: const Locale('fr', 'CA'), // ✅ Proper format
      englishName: "French (Canada)",
      localName: "Français - Canadien",
      flag: "assets/images/canada.png",
    ),
    LanguageModel(
      locale: const Locale('pt', 'BR'), // ✅ Proper format
      englishName: "Portuguese (Brazil)",
      localName: "Brazilian",
      flag: "assets/images/brazil.png",
    ),
    LanguageModel(
      locale: const Locale('ko'),
      englishName: "Korean",
      localName: "Korean",
      flag: "assets/images/united-states-of-america.png",
    ),
  ];

  List<LanguageModel> get languages => _languages;
}
