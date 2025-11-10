// import 'dart:ui';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:speezu/core/assets/app_images.dart';
// import 'package:speezu/core/assets/font_family.dart';
// import 'package:speezu/core/utils/labels.dart';
// import 'package:speezu/core/utils/media_querry_extention.dart';
// import 'package:speezu/widgets/login_required_bottom%20sheet.dart';
// import '../../repositories/user_repository.dart';
// import '../../routes/route_names.dart';
// import '../../widgets/search_animated_container.dart';
// import '../drawers/drawer.dart';
// import '../cart/bloc/cart_bloc.dart';
// import '../cart/bloc/cart_state.dart';
// import '../products/bloc/products_bloc.dart';
// import '../products/bloc/products_event.dart';
// import '../products/products_tab_bar.dart';
// import 'bloc/nav_bar_bloc.dart';
// import 'bloc/nav_bar_event.dart';
// import 'bloc/nav_bar_state.dart';
//
// class NavBarScreen extends StatefulWidget {
//   final dynamic currentTab;
//
//   const NavBarScreen({super.key, this.currentTab});
//
//   @override
//   State<NavBarScreen> createState() => _NavBarScreenState();
// }
//
// class _NavBarScreenState extends State<NavBarScreen>
//     with TickerProviderStateMixin {
//   final GlobalKey<ScaffoldState> _navBarScaffoldKey =
//       GlobalKey<ScaffoldState>();
//   final ScrollController _scrollController = ScrollController();
//
//   // Animation controller for scroll-driven animations
//   late AnimationController _scrollAnimationController;
//
//   // Animations
//   late Animation<double> _titleOpacityAnimation;
//   late Animation<double> _searchTransitionAnimation;
//
//   final userRepo = UserRepository();
//
//   @override
//   void initState() {
//     super.initState();
//
//     _scrollAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//
//     // Title opacity: 1.0 at rest -> 0.0 when scrolled
//     _titleOpacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
//       CurvedAnimation(
//         parent: _scrollAnimationController,
//         curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
//       ),
//     );
//
//     // Search transition: 0.0 at rest -> 1.0 when scrolled
//     _searchTransitionAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _scrollAnimationController,
//         curve: const Interval(0.3, 1.0, curve: Curves.easeInOutCubic),
//       ),
//     );
//
//     _scrollController.addListener(_handleScroll);
//   }
//
//   void _handleScroll() {
//     if (!_scrollController.hasClients) return;
//
//     const scrollThreshold = 80.0;
//     final scrollOffset = _scrollController.offset.clamp(0.0, scrollThreshold);
//     final progress = (scrollOffset / scrollThreshold).clamp(0.0, 1.0);
//
//     _scrollAnimationController.value = progress;
//   }
//
//   void _resetAnimations() {
//     _scrollAnimationController.reset();
//     if (_scrollController.hasClients) {
//       _scrollController.jumpTo(0);
//     }
//   }
//
//   @override
//   void dispose() {
//     _scrollController.removeListener(_handleScroll);
//     _scrollController.dispose();
//     _scrollAnimationController.dispose();
//     super.dispose();
//   }
//
//   // Premium cart badge
//   Widget _buildCartBadge(int cartCount) {
//     return Stack(
//       clipBehavior: Clip.none,
//       children: [
//         Material(
//           color: Colors.transparent,
//           child: InkWell(
//             borderRadius: BorderRadius.circular(12),
//             onTap: () async {
//               final isUserLoggedIn =
//                   await UserRepository().isUserAuthenticated();
//               if (isUserLoggedIn) {
//                 Navigator.pushNamed(context, RouteNames.cartScreen);
//               } else {
//                 LoginRequiredBottomSheet.show(context);
//               }
//             },
//             child: Container(
//               margin: const EdgeInsets.all(8),
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(
//                   color: Theme.of(
//                     context,
//                   ).colorScheme.secondary.withValues(alpha: 0.1),
//                   width: 1,
//                 ),
//               ),
//               child: Icon(
//                 Icons.shopping_cart_outlined,
//                 color: Theme.of(context).colorScheme.primary,
//                 size: 22,
//               ),
//             ),
//           ),
//         ),
//         if (cartCount > 0)
//           Positioned(
//             right: 4,
//             top: 4,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Colors.red.shade600, Colors.red.shade700],
//                 ),
//                 borderRadius: BorderRadius.circular(10),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.red.withValues(alpha: 0.3),
//                     blurRadius: 4,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
//               child: Text(
//                 cartCount > 99 ? '99+' : cartCount.toString(),
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 10,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//       ],
//     );
//   }
//
//   // Premium drawer button
//   Widget _buildDrawerButton() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 4),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(12),
//           onTap: () => _navBarScaffoldKey.currentState?.openDrawer(),
//           child: Container(
//             margin: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(
//                 color: Theme.of(
//                   context,
//                 ).colorScheme.secondary.withValues(alpha: 0.1),
//                 width: 1,
//               ),
//             ),
//             child: Icon(
//               Icons.menu,
//               color: Theme.of(context).colorScheme.primary,
//               size: 22,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Static app bar for tabs 1 & 3
//
//   @override
//   Widget build(BuildContext context) {
//     List<String> screenTitles = [
//       Labels.products,
//       Labels.mapExplorer,
//       Labels.speezu,
//       Labels.myOrders,
//       Labels.favourites,
//     ];
//     return BlocProvider(
//       create: (_) => NavBarBloc()..add(InitPage(widget.currentTab)),
//       child: BlocListener<NavBarBloc, NavBarState>(
//         listener: (context, state) {
//           _resetAnimations();
//         },
//         child: BlocBuilder<NavBarBloc, NavBarState>(
//           builder: (context, state) {
//             final bloc = context.read<NavBarBloc>();
//
//             return Scaffold(
//               key: _navBarScaffoldKey,
//               backgroundColor: Theme.of(context).colorScheme.onPrimary,
//
//               // Static AppBar for tabs 1 & 3
//               appBar:
//                   (state.currentTab == 1 || state.currentTab == 3)
//                       ? PreferredSize(
//                         preferredSize: const Size.fromHeight(kToolbarHeight),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                               colors: [
//                                 Theme.of(context).colorScheme.onPrimary,
//                                 Theme.of(
//                                   context,
//                                 ).colorScheme.onPrimary.withValues(alpha: 0.95),
//                               ],
//                             ),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Theme.of(
//                                   context,
//                                 ).colorScheme.shadow.withValues(alpha: 0.08),
//                                 offset: const Offset(0, 2),
//                                 blurRadius: 8,
//                               ),
//                             ],
//                           ),
//                           child: AppBar(
//                             centerTitle: true,
//                             backgroundColor: Colors.transparent,
//                             elevation: 0,
//                             scrolledUnderElevation: 0,
//                             leading: _buildDrawerButton(),
//                             title: ShaderMask(
//                               shaderCallback:
//                                   (bounds) => LinearGradient(
//                                     colors: [
//                                       Theme.of(context).colorScheme.onSecondary
//                                           .withValues(alpha: 0.95),
//                                       Theme.of(context).colorScheme.onSecondary
//                                           .withValues(alpha: 0.85),
//                                     ],
//                                   ).createShader(bounds),
//                               child: Text(
//                                 screenTitles[state.currentTab],
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontFamily: FontFamily.fontsPoppinsSemiBold,
//                                   fontSize:20,
//                                   letterSpacing: 0.3,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                             actions: [
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 4),
//                                 child: BlocBuilder<CartBloc, CartState>(
//                                   builder: (context, cartState) {
//                                     return _buildCartBadge(
//                                       cartState.totalItems,
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ],
//                             bottom: PreferredSize(
//                               preferredSize: const Size.fromHeight(1),
//                               child: Container(
//                                 height: 1,
//                                 decoration: BoxDecoration(
//                                   gradient: LinearGradient(
//                                     colors: [
//                                       Colors.transparent,
//                                       Theme.of(context).colorScheme.secondary
//                                           .withValues(alpha: 0.15),
//                                       Colors.transparent,
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       )
//                       : null,
//
//               // endDrawer: EndDrawer(),
//               drawer: DrawerWidget(),
//
//               // Body with collapsing app bar for tabs 0, 2, 4
//               body:
//                   (state.currentTab == 0 ||
//                           state.currentTab == 2 ||
//                           state.currentTab == 4)
//                       ? NestedScrollView(
//                         controller: _scrollController,
//                         headerSliverBuilder: (context, innerBoxIsScrolled) {
//                           return [
//                             SliverAppBar(
//                               pinned: true,
//                               floating: false,
//                               snap: false,
//                               elevation: 0,
//                               scrolledUnderElevation: 0,
//                               expandedHeight: state.currentTab == 0 ? 170 : 120,
//                               collapsedHeight: kToolbarHeight,
//                               backgroundColor:
//                                   Theme.of(context).colorScheme.onPrimary,
//
//                               // Drawer icon - always visible
//                               leading: _buildDrawerButton(),
//
//                               // Cart icon - always visible
//                               actions: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(right: 4),
//                                   child: BlocBuilder<CartBloc, CartState>(
//                                     builder: (context, cartState) {
//                                       return _buildCartBadge(
//                                         cartState.totalItems,
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               ],
//
//                               // Title in collapsed state + Search when scrolled
//                               title: AnimatedBuilder(
//                                 animation: Listenable.merge([
//                                   _titleOpacityAnimation,
//                                   _searchTransitionAnimation,
//                                 ]),
//                                 builder: (context, child) {
//                                   return Stack(
//                                     alignment: Alignment.center,
//                                     children: [
//                                       // Title - visible when collapsed + not scrolled much
//                                       Opacity(
//                                         opacity: _titleOpacityAnimation.value,
//                                         child:
//                                             state.currentTab == 2
//                                                 ? Image.asset(
//                                                   AppImages.speezuLogo,
//                                                   width: 110,
//                                                   fit: BoxFit.contain,
//                                                 )
//                                                 : Text(
//                                                   screenTitles[state
//                                                       .currentTab],
//                                                   style: TextStyle(
//                                                     color: Theme.of(context)
//                                                         .colorScheme
//                                                         .onSecondary
//                                                         .withValues(alpha: 0.9),
//                                                     fontFamily:
//                                                         FontFamily
//                                                             .fontsPoppinsSemiBold,
//                                                     fontSize: 20,
//                                                     letterSpacing: 0.3,
//                                                   ),
//                                                 ),
//                                       ),
//
//                                       // Search - visible when scrolled
//                                       Transform.scale(
//                                         scale:
//                                             0.7 +
//                                             (_searchTransitionAnimation.value *
//                                                 0.4),
//                                         child: Opacity(
//                                           opacity:
//                                               _searchTransitionAnimation.value,
//                                           child: IgnorePointer(
//                                             ignoring:
//                                                 _searchTransitionAnimation
//                                                     .value <
//                                                 0.1,
//                                             child: SizedBox(
//                                               width:
//                                                   MediaQuery.of(
//                                                     context,
//                                                   ).size.width *
//                                                   0.9,
//                                               height: 40,
//                                               child: SearchContainer(),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   );
//                                 },
//                               ),
//
//                               // FlexibleSpace - Search bar at bottom when expanded
//                               flexibleSpace: FlexibleSpaceBar(
//                                 background: Container(
//                                   decoration: BoxDecoration(
//                                     gradient: LinearGradient(
//                                       begin: Alignment.topCenter,
//                                       end: Alignment.bottomCenter,
//                                       colors: [
//                                         Theme.of(context).colorScheme.onPrimary,
//                                         Theme.of(context).colorScheme.onPrimary
//                                             .withValues(alpha: 0.98),
//                                       ],
//                                     ),
//                                   ),
//                                   child: SafeArea(
//                                     bottom: false,
//                                     child: Column(
//                                       mainAxisAlignment: MainAxisAlignment.end,
//                                       children: [
//                                         AnimatedBuilder(
//                                           animation: _searchTransitionAnimation,
//                                           builder: (context, child) {
//                                             final opacity =
//                                                 1.0 -
//                                                 _searchTransitionAnimation
//                                                     .value;
//                                             final height =
//                                                 lerpDouble(
//                                                   60,
//                                                   0,
//                                                   _searchTransitionAnimation
//                                                       .value,
//                                                 ) ??
//                                                 60;
//
//                                             return SizedBox(
//                                               height: height,
//                                               child: Opacity(
//                                                 opacity: opacity,
//                                                 child: IgnorePointer(
//                                                   ignoring: opacity < 0.1,
//                                                   child: Padding(
//                                                     padding:
//                                                         const EdgeInsets.symmetric(
//                                                           horizontal: 16,
//                                                           vertical: 8,
//                                                         ),
//                                                     child: SearchContainer(),
//                                                   ),
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                         ),
//                                         if (state.currentTab == 0)
//                                           DefaultTabController(
//                                             length: 4,
//                                             child: ProductsTabContainer(
//                                               onTabChanged: (index) {
//                                                 context
//                                                     .read<ProductsBloc>()
//                                                     .add(ChangeTabEvent(index));
//                                               },
//                                             ),
//                                           ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//
//                               // Bottom gradient divider
//                               bottom: PreferredSize(
//                                 preferredSize: const Size.fromHeight(1),
//                                 child: Container(
//                                   height: 1,
//                                   decoration: BoxDecoration(
//                                     gradient: LinearGradient(
//                                       colors: [
//                                         Colors.transparent,
//                                         Theme.of(context).colorScheme.secondary
//                                             .withValues(alpha: 0.15),
//                                         Colors.transparent,
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ];
//                         },
//                         body: Builder(
//                           builder: (context) {
//                             if (state.currentPage is ScrollableScreen) {
//                               return (state.currentPage as ScrollableScreen)
//                                   .withScrollController(_scrollController);
//                             }
//                             return state.currentPage;
//                           },
//                         ),
//                       )
//                       : state.currentPage,
//
//               // Bottom Navigation Bar
//               bottomNavigationBar: BottomNavigationBar(
//                 type: BottomNavigationBarType.fixed,
//                 selectedItemColor: Theme.of(context).colorScheme.primary,
//                 selectedFontSize: 0,
//                 unselectedFontSize: 0,
//                 // iconSize: context.scaledFont(22),
//                 elevation: 3,
//                 backgroundColor: Theme.of(context).colorScheme.onPrimary,
//                 selectedIconTheme: IconThemeData(size: 27),
//                 unselectedItemColor: Theme.of(
//                   context,
//                 ).colorScheme.outline.withValues(alpha: 1),
//                 currentIndex: state.currentTab,
//                 onTap: (index) => bloc.add(SelectTab(index)),
//                 items: [
//                   const BottomNavigationBarItem(
//                     icon: Icon(CupertinoIcons.archivebox_fill),
//                     label: '',
//                   ),
//                   const BottomNavigationBarItem(
//                     icon: Icon(Icons.location_on),
//                     label: '',
//                   ),
//                   BottomNavigationBarItem(
//                     label: '',
//                     icon: Container(
//                       // width: context.widthPct(.1),
//                       // height: context.widthPct(.1),
//                       padding: EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         color: Theme.of(context).colorScheme.primary,
//                         borderRadius: const BorderRadius.all(
//                           Radius.circular(50),
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Theme.of(
//                               context,
//                             ).colorScheme.primary.withValues(alpha: .5),
//                             blurRadius: 40,
//                             offset: const Offset(0, 15),
//                           ),
//                           BoxShadow(
//                             color: Theme.of(
//                               context,
//                             ).colorScheme.onSecondary.withValues(alpha: .3),
//                             blurRadius: 13,
//                             offset: const Offset(0, 3),
//                           ),
//                         ],
//                       ),
//                       child: Icon(
//                         Icons.home,
//                         color: Theme.of(context).colorScheme.onPrimary,
//                       ),
//                     ),
//                   ),
//                   const BottomNavigationBarItem(
//                     icon: Icon(Icons.fastfood),
//                     label: '',
//                   ),
//                   const BottomNavigationBarItem(
//                     icon: Icon(Icons.favorite),
//                     label: '',
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
// mixin ScrollableScreen {
//   Widget withScrollController(ScrollController controller);
// }
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speezu/core/assets/app_images.dart';
import 'package:speezu/core/assets/font_family.dart';
import 'package:speezu/core/utils/labels.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';
import 'package:speezu/widgets/login_required_bottom%20sheet.dart';
import '../../repositories/user_repository.dart';
import '../../routes/route_names.dart';
import '../../widgets/search_animated_container.dart';
import '../drawers/drawer.dart';
import '../cart/bloc/cart_bloc.dart';
import '../cart/bloc/cart_state.dart';
import '../products/bloc/products_bloc.dart';
import '../products/bloc/products_event.dart';
import '../products/products_tab_bar.dart';
import 'bloc/nav_bar_bloc.dart';
import 'bloc/nav_bar_event.dart';
import 'bloc/nav_bar_state.dart';

class NavBarScreen extends StatefulWidget {
  final dynamic currentTab;

  const NavBarScreen({super.key, this.currentTab});

  @override
  State<NavBarScreen> createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _navBarScaffoldKey =
  GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  // Animation controller for scroll-driven animations
  late AnimationController _scrollAnimationController;

  // Animations
  late Animation<double> _titleOpacityAnimation;
  late Animation<double> _searchTransitionAnimation;

  final userRepo = UserRepository();

  @override
  void initState() {
    super.initState();

    _scrollAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Title opacity: 1.0 at rest -> 0.0 when scrolled
    _titleOpacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _scrollAnimationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    // Search transition: 0.0 at rest -> 1.0 when scrolled
    _searchTransitionAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _scrollAnimationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeInOutCubic),
      ),
    );

    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) return;

    const scrollThreshold = 80.0;
    final scrollOffset = _scrollController.offset.clamp(0.0, scrollThreshold);
    final progress = (scrollOffset / scrollThreshold).clamp(0.0, 1.0);

    _scrollAnimationController.value = progress;
  }

  void _resetAnimations() {
    _scrollAnimationController.reset();
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    _scrollAnimationController.dispose();
    super.dispose();
  }

  // Premium cart badge with responsive sizing
  Widget _buildCartBadge(int cartCount, bool isTablet, bool isLargeTablet) {
    final iconSize = isLargeTablet ? 26.0 : (isTablet ? 24.0 : 22.0);
    final badgePadding = isLargeTablet ? 7.0 : (isTablet ? 6.0 : 6.0);
    final badgeMinSize = isLargeTablet ? 22.0 : (isTablet ? 20.0 : 18.0);
    final badgeFontSize = isLargeTablet ? 11.0 : (isTablet ? 10.5 : 10.0);
    final containerPadding = isLargeTablet ? 10.0 : (isTablet ? 9.0 : 8.0);
    final borderRadius = isTablet ? 14.0 : 12.0;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius),
            onTap: () async {
              final isUserLoggedIn =
              await UserRepository().isUserAuthenticated();
              if (isUserLoggedIn) {
                Navigator.pushNamed(context, RouteNames.cartScreen);
              } else {
                LoginRequiredBottomSheet.show(context);
              }
            },
            child: Container(
              margin: EdgeInsets.all(containerPadding),
              padding: EdgeInsets.all(containerPadding),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .secondary
                      .withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.shopping_cart_outlined,
                color: Theme.of(context).colorScheme.primary,
                size: iconSize,
              ),
            ),
          ),
        ),
        if (cartCount > 0)
          Positioned(
            right: isTablet ? 5 : 4,
            top: isTablet ? 5 : 4,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: badgePadding,
                vertical: isTablet ? 3 : 2,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red.shade600, Colors.red.shade700],
                ),
                borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withValues(alpha: 0.3),
                    blurRadius: isTablet ? 5 : 4,
                    offset: Offset(0, isTablet ? 3 : 2),
                  ),
                ],
              ),
              constraints: BoxConstraints(
                minWidth: badgeMinSize,
                minHeight: badgeMinSize,
              ),
              child: Text(
                cartCount > 99 ? '99+' : cartCount.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: badgeFontSize,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  // Premium drawer button with responsive sizing
  Widget _buildDrawerButton(bool isTablet, bool isLargeTablet) {
    final iconSize = isLargeTablet ? 26.0 : (isTablet ? 24.0 : 22.0);
    final containerPadding = isLargeTablet ? 10.0 : (isTablet ? 9.0 : 8.0);
    final borderRadius = isTablet ? 14.0 : 12.0;

    return Padding(
      padding: EdgeInsets.only(left: isTablet ? 6 : 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: () => _navBarScaffoldKey.currentState?.openDrawer(),
          child: Container(
            margin: EdgeInsets.all(containerPadding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .secondary
                    .withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.menu,
              color: Theme.of(context).colorScheme.primary,
              size: iconSize,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isTablet = screenWidth >= 600;
        final isMediumTablet = screenWidth >= 768;
        final isLargeTablet = screenWidth >= 900;

        // Responsive values
        final titleFontSize = isLargeTablet ? 24.0 : (isMediumTablet ? 22.0 : 20.0);
        final logoWidth = isLargeTablet ? 130.0 : (isTablet ? 120.0 : 110.0);
        final expandedHeight = isTablet ?
        (isLargeTablet ? 190.0 : 180.0) : 170.0;
        final expandedHeightOther = isTablet ? 140.0 : 120.0;
        final bottomNavIconSize = isLargeTablet ? 30.0 : (isTablet ? 28.0 : 27.0);
        final bottomNavUnselectedSize = isLargeTablet ? 28.0 : (isTablet ? 26.0 : 24.0);
        final homeIconSize = isLargeTablet ? 28.0 : (isTablet ? 26.0 : 24.0);
        final homeIconPadding = isLargeTablet ? 12.0 : (isTablet ? 11.0 : 10.0);
        final searchHeight = isTablet ? 48.0 : 40.0;
        final searchPaddingHorizontal = isTablet ? 20.0 : 16.0;
        final searchPaddingVertical = isTablet ? 10.0 : 8.0;

        List<String> screenTitles = [
          Labels.products,
          Labels.mapExplorer,
          Labels.speezu,
          Labels.myOrders,
          Labels.favourites,
        ];

        return BlocProvider(
          create: (_) => NavBarBloc()..add(InitPage(widget.currentTab)),
          child: BlocListener<NavBarBloc, NavBarState>(
            listener: (context, state) {
              _resetAnimations();
            },
            child: BlocBuilder<NavBarBloc, NavBarState>(
              builder: (context, state) {
                final bloc = context.read<NavBarBloc>();

                return Scaffold(
                  key: _navBarScaffoldKey,
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,

                  // Static AppBar for tabs 1 & 3
                  appBar: (state.currentTab == 1 || state.currentTab == 3)
                      ? PreferredSize(
                    preferredSize: Size.fromHeight(
                      isTablet ? 64 : kToolbarHeight,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(context).colorScheme.onPrimary,
                            Theme.of(context)
                                .colorScheme
                                .onPrimary
                                .withValues(alpha: 0.95),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .shadow
                                .withValues(alpha: 0.08),
                            offset: const Offset(0, 2),
                            blurRadius: isTablet ? 10 : 8,
                          ),
                        ],
                      ),
                      child: AppBar(
                        centerTitle: true,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        scrolledUnderElevation: 0,
                        toolbarHeight: isTablet ? 64 : kToolbarHeight,
                        leading: _buildDrawerButton(isTablet, isLargeTablet),
                        title: ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [
                              Theme.of(context)
                                  .colorScheme
                                  .onSecondary
                                  .withValues(alpha: 0.95),
                              Theme.of(context)
                                  .colorScheme
                                  .onSecondary
                                  .withValues(alpha: 0.85),
                            ],
                          ).createShader(bounds),
                          child: Text(
                            screenTitles[state.currentTab],
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: FontFamily.fontsPoppinsSemiBold,
                              fontSize: titleFontSize,
                              letterSpacing: 0.3,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        actions: [
                          Padding(
                            padding: EdgeInsets.only(
                              right: isTablet ? 6 : 4,
                            ),
                            child: BlocBuilder<CartBloc, CartState>(
                              builder: (context, cartState) {
                                return _buildCartBadge(
                                  cartState.totalItems,
                                  isTablet,
                                  isLargeTablet,
                                );
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
                                  Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withValues(alpha: 0.15),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                      : null,

                  drawer: DrawerWidget(),

                  // Body with collapsing app bar for tabs 0, 2, 4
                  body: (state.currentTab == 0 ||
                      state.currentTab == 2 ||
                      state.currentTab == 4)
                      ? NestedScrollView(
                    controller: _scrollController,
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverAppBar(
                          pinned: true,
                          floating: false,
                          snap: false,
                          elevation: 0,
                          scrolledUnderElevation: 0,
                          expandedHeight: state.currentTab == 0
                              ? expandedHeight
                              : expandedHeightOther,
                          collapsedHeight: isTablet ? 64 : kToolbarHeight,
                          toolbarHeight: isTablet ? 64 : kToolbarHeight,
                          backgroundColor:
                          Theme.of(context).colorScheme.onPrimary,

                          // Drawer icon - always visible
                          leading: _buildDrawerButton(isTablet, isLargeTablet),

                          // Cart icon - always visible
                          actions: [
                            Padding(
                              padding: EdgeInsets.only(
                                right: isTablet ? 6 : 4,
                              ),
                              child: BlocBuilder<CartBloc, CartState>(
                                builder: (context, cartState) {
                                  return _buildCartBadge(
                                    cartState.totalItems,
                                    isTablet,
                                    isLargeTablet,
                                  );
                                },
                              ),
                            ),
                          ],

                          // Title in collapsed state + Search when scrolled
                          title: AnimatedBuilder(
                            animation: Listenable.merge([
                              _titleOpacityAnimation,
                              _searchTransitionAnimation,
                            ]),
                            builder: (context, child) {
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Title - visible when collapsed + not scrolled much
                                  Opacity(
                                    opacity: _titleOpacityAnimation.value,
                                    child: state.currentTab == 2
                                        ? Image.asset(
                                      AppImages.speezuLogo,
                                      width: logoWidth,
                                      fit: BoxFit.contain,
                                    )
                                        : Text(
                                      screenTitles[state.currentTab],
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary
                                            .withValues(alpha: 0.9),
                                        fontFamily: FontFamily
                                            .fontsPoppinsSemiBold,
                                        fontSize: titleFontSize,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ),

                                  // Search - visible when scrolled
                                  Transform.scale(
                                    scale: 0.7 +
                                        (_searchTransitionAnimation.value *
                                            0.4),
                                    child: Opacity(
                                      opacity:
                                      _searchTransitionAnimation.value,
                                      child: IgnorePointer(
                                        ignoring:
                                        _searchTransitionAnimation
                                            .value <
                                            0.1,
                                        child: SizedBox(
                                          width: screenWidth * 0.9,
                                          height: searchHeight,
                                          child: SearchContainer(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),

                          // FlexibleSpace - Search bar at bottom when expanded
                          flexibleSpace: FlexibleSpaceBar(
                            background: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Theme.of(context).colorScheme.onPrimary,
                                    Theme.of(context)
                                        .colorScheme
                                        .onPrimary
                                        .withValues(alpha: 0.98),
                                  ],
                                ),
                              ),
                              child: SafeArea(
                                bottom: false,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    AnimatedBuilder(
                                      animation: _searchTransitionAnimation,
                                      builder: (context, child) {
                                        final opacity = 1.0 -
                                            _searchTransitionAnimation
                                                .value;
                                        final height = lerpDouble(
                                          isTablet ? 70 : 60,
                                          0,
                                          _searchTransitionAnimation
                                              .value,
                                        ) ??
                                            60;

                                        return SizedBox(
                                          height: height,
                                          child: Opacity(
                                            opacity: opacity,
                                            child: IgnorePointer(
                                              ignoring: opacity < 0.1,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: searchPaddingHorizontal,
                                                  vertical: searchPaddingVertical,
                                                ),
                                                child: SearchContainer(),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    if (state.currentTab == 0)
                                      DefaultTabController(
                                        length: 4,
                                        child: ProductsTabContainer(
                                          onTabChanged: (index) {
                                            context
                                                .read<ProductsBloc>()
                                                .add(ChangeTabEvent(index));
                                          },
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Bottom gradient divider
                          bottom: PreferredSize(
                            preferredSize: const Size.fromHeight(1),
                            child: Container(
                              height: 1,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .withValues(alpha: 0.15),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ];
                    },
                    body: Builder(
                      builder: (context) {
                        if (state.currentPage is ScrollableScreen) {
                          return (state.currentPage as ScrollableScreen)
                              .withScrollController(_scrollController);
                        }
                        return state.currentPage;
                      },
                    ),
                  )
                      : state.currentPage,

                  // Bottom Navigation Bar
                  bottomNavigationBar: Container(
                    height: isTablet ? 90 : null,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: isTablet ? 12 : 8,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: BottomNavigationBar(
                      type: BottomNavigationBarType.fixed,
                      selectedItemColor: Theme.of(context).colorScheme.primary,
                      selectedFontSize: 0,
                      unselectedFontSize: 0,
                      elevation: 3,
                      backgroundColor: Theme.of(context).colorScheme.onPrimary,
                      selectedIconTheme: IconThemeData(size: bottomNavIconSize),
                      unselectedIconTheme: IconThemeData(
                        size: bottomNavUnselectedSize,
                      ),
                      unselectedItemColor: Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: 1),
                      currentIndex: state.currentTab,
                      onTap: (index) => bloc.add(SelectTab(index)),
                      items: [
                        const BottomNavigationBarItem(
                          icon: Icon(CupertinoIcons.archivebox_fill),
                          label: '',
                        ),
                        const BottomNavigationBarItem(
                          icon: Icon(Icons.location_on),
                          label: '',
                        ),
                        BottomNavigationBarItem(
                          label: '',
                          icon: Container(
                            padding: EdgeInsets.all(homeIconPadding),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(50),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withValues(alpha: .5),
                                  blurRadius: isTablet ? 45 : 40,
                                  offset: Offset(0, isTablet ? 18 : 15),
                                ),
                                BoxShadow(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondary
                                      .withValues(alpha: .3),
                                  blurRadius: isTablet ? 15 : 13,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.home,
                              color: Theme.of(context).colorScheme.onPrimary,
                              size: homeIconSize,
                            ),
                          ),
                        ),
                        const BottomNavigationBarItem(
                          icon: Icon(Icons.fastfood),
                          label: '',
                        ),
                        const BottomNavigationBarItem(
                          icon: Icon(Icons.favorite),
                          label: '',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

mixin ScrollableScreen {
  Widget withScrollController(ScrollController controller);
}