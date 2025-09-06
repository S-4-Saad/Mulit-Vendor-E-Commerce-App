import 'dart:developer';
import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:speezu/core/services/localStorage/my-local-controller.dart';
import 'package:speezu/core/utils/constants.dart';
import 'languages_event.dart';
import 'languages_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(const LanguageState(Locale('en'))) {
    on<ChangeLanguage>((event, emit) async {
      log('Language changed to: ${event.locale}');
      await event.context.setLocale(event.locale);
      emit(LanguageState(event.locale));
      await LocalStorage.saveData(key: AppKeys.languageCode, value: event.locale.languageCode);
      await LocalStorage.saveData(key: AppKeys.countryCode, value: event.locale.countryCode ?? '');
    });
  }
}