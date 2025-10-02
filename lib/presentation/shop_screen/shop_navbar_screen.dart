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

class ShopNavbarScreen extends StatelessWidget {
  final dynamic shopCurrentTab;
  final int? storeId;

  ShopNavbarScreen({super.key, this.shopCurrentTab, this.storeId});
  final List<String> screenTitles = [
    Labels.shop,
    Labels.mapExplorer,
    Labels.shopProducts,
  ];
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavBarBloc()..add(ShopInitPage(shopCurrentTab, storeId: storeId)),
      child: BlocBuilder<NavBarBloc, NavBarState>(
        builder: (context, state) {
          final bloc = context.read<NavBarBloc>();

          return Scaffold(

            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            appBar:state.shopCurrentTab==0?null: AppBar(
              centerTitle: true,
              backgroundColor: Theme.of(context).colorScheme.onPrimary,
              actions: [
                BlocBuilder<CartBloc, CartState>(
                  builder: (context, cartState) {
                    final cartCount = cartState.totalItems;
                    return Stack(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, RouteNames.cartScreen);
                          },
                          icon: Icon(
                            Icons.shopping_cart,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        if (cartCount > 0)
                          Positioned(
                            right: 2,
                            top: 2,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 20,
                                minHeight: 20,
                              ),
                              child: Text(
                                cartCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },

                icon: const Icon(Icons.arrow_back),
                color: Theme.of(context).colorScheme.secondary,
              ),
              bottom: PreferredSize(
                preferredSize: Size(1, 5),
                child: Divider(
                  color: Theme.of(
                    context,
                  ).colorScheme.secondary.withValues(alpha: .5),
                  height: 1,

                  thickness: 1.5,
                ),
              ),

              // elevation: 1,
              title: Text(
                screenTitles[state.shopCurrentTab],
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSecondary.withValues(alpha: .9),
                  fontFamily: FontFamily.fontsPoppinsSemiBold,
                  fontSize: context.scaledFont(19),
                ),
              ),
            ),

            body: state.shopCurrentPage,
            bottomNavigationBar: BottomAppBar(
              elevation: 3,
              color: Theme.of(context).colorScheme.onPrimary,
              child: Row(
                children: [
                  Expanded(
                    child: IconButton(
                      icon:  Icon(Icons.store,color: state.shopCurrentTab==0?Theme.of(context).colorScheme.primary:
                        Theme.of(context).colorScheme.outline,),
                      onPressed: () => bloc.add(const ShopSelectTab(0)),
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      icon:  Icon(Icons.location_on,color: state.shopCurrentTab == 1
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outline,),
                      onPressed: () => bloc.add(const ShopSelectTab(1)),
                    ),
                  ),
                  Expanded(
                    flex: 2, // 👈 gives more space to this one
                    child: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () => bloc.add(const ShopSelectTab(2)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: state.shopCurrentTab == 2
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.outline,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.category_outlined,
                                color: Theme.of(context).colorScheme.onPrimary),
                            const SizedBox(width: 5),
                            Text(
                              Labels.products,
                              style: TextStyle(
                                fontFamily: FontFamily.fontsPoppinsSemiBold,
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: context.scaledFont(12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          );
        },
      ),
    );
  }
}
