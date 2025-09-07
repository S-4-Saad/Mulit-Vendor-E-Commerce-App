import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Screens
import 'package:speezu/presentation/home/home_screen.dart';

// Bloc files
import '../../../paractise.dart';
import 'nav_bar_event.dart';
import 'nav_bar_state.dart';

class NavBarBloc extends Bloc<NavBarEvent, NavBarState> {
  NavBarBloc()
      : super(
    NavBarState(
      currentTab: 2,
      currentPage: const HomeScreen(),
    ),
  ) {
    on<InitPage>(_onInitPage);
    on<SelectTab>(_onSelectTab);
  }

  void _onInitPage(InitPage event, Emitter<NavBarState> emit) {
    final tab = event.tab;

    if (tab is int) {
      add(SelectTab(tab));
    } else {
      // default to Home tab (2)
      add(const SelectTab(2));
    }
  }

  void _onSelectTab(SelectTab event, Emitter<NavBarState> emit) {
    final page = _mapIndexToPage(event.tabIndex);
    emit(state.copyWith(currentTab: event.tabIndex, currentPage: page));
  }

  /// Extracted mapping logic for maintainability
  Widget _mapIndexToPage(int index) {
    switch (index) {
      case 0:
        return const NotificationScreen();
      case 1:
        return const MapScreen();
      case 2:
        return const HomeScreen();
      case 3:
        return const OrderScreen();
      case 4:
        return const FavouriteScreen();
      default:
        return const HomeScreen();
    }
  }
}
