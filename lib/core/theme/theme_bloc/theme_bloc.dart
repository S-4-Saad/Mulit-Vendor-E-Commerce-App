import 'package:bloc/bloc.dart';
import 'package:speezu/core/theme/theme_bloc/theme_event.dart';
import 'package:speezu/core/theme/theme_bloc/theme_state.dart';
import 'package:speezu/core/theme/theme_repository.dart';

import '../app_theme.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final ThemeRepository _themeRepository;

  ThemeBloc(this._themeRepository)
    : super(const ThemeState(AppThemeMode.light)) {
    on<LoadThemeEvent>(_onLoadTheme);
    on<SwitchThemeEvent>(_onSwitchTheme);
  }

  Future<void> _onLoadTheme(
    LoadThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final savedTheme = await _themeRepository.loadSavedTheme();
    emit(ThemeState(savedTheme));
  }

  Future<void> _onSwitchTheme(
    SwitchThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    await _themeRepository.saveTheme(event.themeMode);
    emit(ThemeState(event.themeMode));
  }
}
