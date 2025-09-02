
import 'package:bloc/bloc.dart';
import 'package:speezu/core/theme/theme_bloc/theme_event.dart';
import 'package:speezu/core/theme/theme_bloc/theme_state.dart';

import '../app_theme.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState(AppThemeMode.light)) {
    on<SwitchThemeEvent>((event, emit) {
      emit(ThemeState(event.themeMode));
    });
  }
}