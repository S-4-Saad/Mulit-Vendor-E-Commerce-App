import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speezu/core/assets/font_family.dart';
import 'package:speezu/core/utils/labels.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';
import 'package:speezu/routes/route_names.dart';
import '../nav_bar_screen/bloc/nav_bar_bloc.dart';
import '../nav_bar_screen/bloc/nav_bar_event.dart';
import '../nav_bar_screen/bloc/nav_bar_state.dart';
import '../cart/bloc/cart_bloc.dart';
import '../cart/bloc/cart_state.dart';
import 'bloc/shop_bloc.dart';
import 'bloc/shop_event.dart';

class ShopNavbarScreen extends StatelessWidget {
  final dynamic shopCurrentTab;
  final int? storeId;

  ShopNavbarScreen({super.key, this.shopCurrentTab, this.storeId});

  final List<String> screenTitles = [
    Labels.shop,
    Labels.reviews,
    Labels.shopProducts,
  ];

  // Premium cart badge widget
  Widget _buildCartBadge(BuildContext context, int cartCount) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.pushNamed(context, RouteNames.cartScreen);
            },
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.shopping_cart_outlined,
                color: Theme.of(context).colorScheme.onSecondary,
                size: 22,
              ),
            ),
          ),
        ),
        if (cartCount > 0)
          Positioned(
            right: 4,
            top: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red.shade600, Colors.red.shade700],
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              constraints: const BoxConstraints(
                minWidth: 18,
                minHeight: 18,
              ),
              child: Text(
                cartCount > 99 ? '99+' : cartCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  // Premium back button
  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: (){

            Navigator.pop(context);
            context.read<ShopBloc>().add(ClearStoreDetail());
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.onSecondary,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  // Premium AppBar
  PreferredSizeWidget _buildPremiumAppBar(BuildContext context, NavBarState state) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.onPrimary,
              Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.95),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.08),
              offset: const Offset(0, 2),
              blurRadius: 8,
            ),
          ],
        ),
        child: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: _buildBackButton(context),
          title: ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                Theme.of(context).colorScheme.onSecondary.withValues(alpha: 0.95),
                Theme.of(context).colorScheme.onSecondary.withValues(alpha: 0.85),
              ],
            ).createShader(bounds),
            child: Text(
              screenTitles[state.shopCurrentTab],
              style: TextStyle(
                color: Colors.white,
                fontFamily: FontFamily.fontsPoppinsSemiBold,
                fontSize: 22,
                letterSpacing: 0.3,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: BlocBuilder<CartBloc, CartState>(
                builder: (context, cartState) {
                  return _buildCartBadge(context, cartState.totalItems);
                },
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Theme.of(context).colorScheme.secondary.withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Premium Bottom Navigation Bar
  Widget _buildPremiumBottomNav(BuildContext context, NavBarState state, NavBarBloc bloc) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -4),
            blurRadius: 12,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Store Tab
              _buildNavItem(
                context: context,
                icon: Icons.store_rounded,
                label: Labels.shop,
                isSelected: state.shopCurrentTab == 0,
                onTap: () => bloc.add(const ShopSelectTab(0)),
              ),

              // Reviews Tab
              _buildNavItem(
                context: context,
                icon: Icons.star_rounded,
                label: Labels.reviews,
                isSelected: state.shopCurrentTab == 1,
                onTap: () => bloc.add(const ShopSelectTab(1)),
              ),

              // Products Tab (Premium Pill Style)
              _buildProductsTab(context, state, bloc),
            ],
          ),
        ),
      ),
    );
  }

  // Navigation Item
  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  // Premium Products Tab (Pill Style)
  Widget _buildProductsTab(BuildContext context, NavBarState state, NavBarBloc bloc) {
    final isSelected = state.shopCurrentTab == 2;

    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => bloc.add(const ShopSelectTab(2)),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withValues(alpha: 0.85),
                  ],
                )
                    : null,
                color: isSelected ? null : Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                boxShadow: isSelected
                    ? [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
                    : [],
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.category_rounded,
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.outline,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      Labels.products,
                      style: TextStyle(
                        fontFamily: FontFamily.fontsPoppinsSemiBold,
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.outline,
                        fontSize: context.scaledFont(13),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Clear store details when navigating back
        context.read<ShopBloc>().add(ClearStoreDetail());
        return true;
      },
      child: BlocProvider(
        create: (_) => NavBarBloc()..add(ShopInitPage(shopCurrentTab, storeId: storeId)),
        child: BlocBuilder<NavBarBloc, NavBarState>(
          builder: (context, state) {
            final bloc = context.read<NavBarBloc>();

            return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.onPrimary,

              // Show AppBar for all tabs except tab 0
              appBar: state.shopCurrentTab == 0
                  ? null
                  : _buildPremiumAppBar(context, state),

              body: state.shopCurrentPage,

              // Premium Bottom Navigation
              bottomNavigationBar: _buildPremiumBottomNav(context, state, bloc),
            );
          },
        ),
      ),
    );
  }
}