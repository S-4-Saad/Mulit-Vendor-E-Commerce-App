import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Screens
import 'package:speezu/presentation/home/home_screen.dart';
import 'package:speezu/presentation/products/products_tab_bar.dart';
import 'package:speezu/presentation/shop_screen/shop/shop_products_screen.dart';
import 'package:speezu/repositories/user_repository.dart';
import 'package:speezu/widgets/login_required_screen.dart';

// Bloc files
import '../../../core/services/localStorage/my-local-controller.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/labels.dart';
import '../../../paractise.dart';
import '../../favourites/favourite_products_screen.dart';
import '../../orders/orders_tab_bar_screen.dart';
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
      shopCurrentPage: StoreScreen(),
      storeId: null,
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

  void _onSelectTab(SelectTab event, Emitter<NavBarState> emit) async {
    final isLoggedIn = await isUserAuthenticated();

    final page = _mapIndexToPage(event.tabIndex, isLoggedIn);
    emit(state.copyWith(currentTab: event.tabIndex, currentPage: page));
  }

  /// 🔹 Updated mapping logic — dynamically uses login state
  Widget _mapIndexToPage(int index, bool isLoggedIn) {
    switch (index) {
      case 0:
        return ProductsTabBarScreen(initialIndex: 0);
      case 1:
        return const MapScreen();
      case 2:
        return const HomeScreen();
      case 3:
        return isLoggedIn
            ? OrdersTabBarScreen()
            : LoginRequiredScreen(featureName: Labels.myOrders);
      case 4:
        return isLoggedIn
            ? FavouriteProductsScreen()
            : LoginRequiredScreen(featureName: Labels.favourites);
      default:
        return const HomeScreen();
    }
  }

  void _shopInitPage(ShopInitPage event, Emitter<NavBarState> emit) {
    final tab = event.tab;
    final storeId = event.storeId;

    // Update store ID in state
    if (storeId != null) {
      emit(state.copyWith(storeId: storeId));
    }

    if (tab is int) {
      add(ShopSelectTab(tab));
    } else {
      // default to Home tab (0)
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
        return ShopDetailScreen(storeId: state.storeId);
      case 1:
        return const ShopMapScreen();
      case 2:
        return state.storeId != null
            ? ShopProductsScreen(storeId: state.storeId!)
            : const Center(child: Text('Store ID not available'));
      default:
        return ShopDetailScreen(storeId: state.storeId);
    }
  }

  /// ✅ Always checks live authentication status (no restart needed)
  Future<bool> isUserAuthenticated() async {
    final token = await LocalStorage.getData(key: AppKeys.authToken);
    return token != null;
  }
}
