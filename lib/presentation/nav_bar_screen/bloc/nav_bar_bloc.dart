import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Screens
import 'package:speezu/presentation/home/home_screen.dart';
import 'package:speezu/presentation/products/products_tab_bar.dart';
import 'package:speezu/presentation/shop_screen/shop/shop_products_screen.dart';

// Bloc files
import '../../../paractise.dart';
import '../../orders/orders_tab_bar_screen.dart';
import '../../product_detail/product_detail_screen.dart';
import '../../shop_screen/shop/shop_detail_screen.dart';
import '../../map_screen/map_screen.dart';
import 'nav_bar_event.dart';
import 'nav_bar_state.dart';

class NavBarBloc extends Bloc<NavBarEvent, NavBarState> {
  NavBarBloc()
    : super(
        NavBarState(
          shopCurrentTab: 0,
          currentTab: 2,
          currentPage: const HomeScreen(),
          shopCurrentPage: StoreScreen()
        ),
      ) {
    on<InitPage>(_onInitPage);
    on<SelectTab>(_onSelectTab);
    on<ShopInitPage>(_shopInitPage);
    on<ShopSelectTab>(_shopSelectedTab);
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
        return ProductsTabBarScreen(initialIndex: 0,);
      case 1:
        return const MapScreen();
      case 2:
        return const HomeScreen();
      case 3:
        return const OrdersTabBarScreen();
      case 4:
        return const FavouriteScreen();
      default:
        return const HomeScreen();
    }
  }

  void _shopInitPage(ShopInitPage event, Emitter<NavBarState> emit) {
    final tab = event.tab;

    if (tab is int) {
      add(ShopSelectTab(tab));
    } else {
      // default to Home tab (2)
      add(const ShopSelectTab(0));
    }
  }

  void _shopSelectedTab(ShopSelectTab event, Emitter<NavBarState> emit) {
    final page = _shopMapIndexToPage(event.tabIndex);
    emit(state.copyWith(shopCurrentTab: event.tabIndex, shopCurrentPage: page));
  }

  /// Extracted mapping logic for maintainability
  Widget _shopMapIndexToPage(int index) {
    switch (index) {
      case 0:
        return const ShopDetailScreen();
      case 1:
        return const ShopMapScreen();
      case 2:
        return  ShopProductsScreen();
      default:
        return const ShopDetailScreen();
    }
  }
}
