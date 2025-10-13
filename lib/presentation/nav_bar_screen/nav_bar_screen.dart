import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speezu/core/assets/app_images.dart';
import 'package:speezu/core/assets/font_family.dart';
import 'package:speezu/core/utils/labels.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';
import 'package:speezu/presentation/drawers/end_drawer.dart';
import 'package:speezu/widgets/login_required_bottom%20sheet.dart';

import '../../core/services/localStorage/my-local-controller.dart';
import '../../core/utils/constants.dart';
import '../../repositories/user_repository.dart';
import '../../routes/route_names.dart';
import '../../widgets/search_animated_container.dart';
import '../drawers/drawer.dart';
import '../cart/bloc/cart_bloc.dart';
import '../cart/bloc/cart_state.dart';
import 'bloc/nav_bar_bloc.dart';
import 'bloc/nav_bar_event.dart';
import 'bloc/nav_bar_state.dart';

class NavBarScreen extends StatefulWidget {
  final dynamic currentTab;

  NavBarScreen({super.key, this.currentTab});

  @override
  State<NavBarScreen> createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _navBarScaffoldKey =
      GlobalKey<ScaffoldState>();

  final ScrollController _scrollController = ScrollController();
  bool _showTitle = true;
  bool _showIcons = true;
  bool _isScrollingDown = false;
  double _lastOffset = 0.0;
  
  late AnimationController _titleAnimationController;
  late AnimationController _iconsAnimationController;
  late Animation<double> _titleAnimation;
  late Animation<double> _iconsAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers with optimized durations
    _titleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _iconsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 180),
      vsync: this,
    );
    
    // Initialize animations with smoother curves
    _titleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _titleAnimationController, curve: Curves.easeOutCubic),
    );
    _iconsAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _iconsAnimationController, curve: Curves.easeOutCubic),
    );
    
    // Start with visible elements
    _titleAnimationController.forward();
    _iconsAnimationController.forward();
    
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) return;
    
    final offset = _scrollController.offset;
    
    // Calculate scroll delta to determine actual movement
    final double delta = offset - _lastOffset;
    _lastOffset = offset;
    
    // Track scroll direction with more robust detection
    if (delta > 0) {
      // Scrolling down
      _isScrollingDown = true;
    } else if (delta < 0) {
      // Scrolling up
      _isScrollingDown = false;
    }
    
    // Thresholds for hiding/showing
    const double scrollThreshold = 1.0;
    const double hideThreshold = 15.0;
    const double titleHideThreshold = 5.0;
    const double showThreshold = 2.0;
    
    final bool isAtTop = offset <= scrollThreshold;
    final bool isNearTop = offset <= showThreshold;
    
    // Only hide if we're actually scrolling down and have moved enough
    final bool shouldHideTitle = _isScrollingDown && offset > titleHideThreshold;
    final bool shouldHideIcons = _isScrollingDown && offset > hideThreshold;
    
    // Only show if we're at the very top OR actively scrolling up and very close to top
    final bool shouldShowTitle = isAtTop || (delta < 0 && isNearTop && !_isScrollingDown);
    final bool shouldShowIcons = isAtTop || (delta < 0 && isNearTop && !_isScrollingDown);
    
    // Apply transitions with strict state checking
    if (shouldHideTitle && _showTitle) {
      _showTitle = false;
      _titleAnimationController.reverse();
    } else if (shouldShowTitle && !_showTitle) {
      _showTitle = true;
      _titleAnimationController.forward();
    }
    
    if (shouldHideIcons && _showIcons) {
      _showIcons = false;
      _iconsAnimationController.reverse();
    } else if (shouldShowIcons && !_showIcons) {
      _showIcons = true;
      _iconsAnimationController.forward();
    }
  }

  void _resetAnimationStates() {
    // Reset scroll position to top
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
    
    // Reset animation states
    _showTitle = true;
    _showIcons = true;
    _isScrollingDown = false;
    _lastOffset = 0.0;
    
    // Animate to visible state
    _titleAnimationController.forward();
    _iconsAnimationController.forward();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _titleAnimationController.dispose();
    _iconsAnimationController.dispose();
    super.dispose();
  }

 // ← added
  final userRepo = UserRepository();

  List<String> screenTitles = [
    Labels.products,
    Labels.mapExplorer,
    Labels.speezu,
    Labels.myOrders,
    Labels.favourites,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavBarBloc()..add(InitPage(widget.currentTab)),
      child: BlocListener<NavBarBloc, NavBarState>(
        listener: (context, state) {
          // Reset animation states when tab changes
          _resetAnimationStates();
        },
        child: BlocBuilder<NavBarBloc, NavBarState>(
          builder: (context, state) {
            final bloc = context.read<NavBarBloc>();

          return Scaffold(
            key: _navBarScaffoldKey,
            backgroundColor: Theme.of(context).colorScheme.onPrimary,

            appBar:state.currentTab==1||state.currentTab==3? AppBar(
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
                            color: Theme.of(context).colorScheme.primary,
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
                  _navBarScaffoldKey.currentState?.openDrawer();
                },

                icon: const Icon(Icons.menu),
                color: Theme.of(context).colorScheme.primary,
              ),
              bottom: PreferredSize(
                preferredSize:
                    state.currentTab == 0 || state.currentTab == 2
                        ? Size(1, 20 + context.scaledFont(50))
                        : Size(1, 3),
                child: Column(
                  children: [
                    Divider(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: .5),
                      height: 1,

                      thickness: 1.5,
                    ),
                    state.currentTab == 0 || state.currentTab == 2
                        ? SearchContainer()
                        : SizedBox.shrink(),
                  ],
                ),
              ),

              // elevation: 1,
              title: Text(
                screenTitles[state.currentTab],
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSecondary.withValues(alpha: .9),
                  fontFamily: FontFamily.fontsPoppinsSemiBold,
                  fontSize: context.scaledFont(19),
                ),
              ),
            ):null,
            endDrawer: EndDrawer(),

            drawer: DrawerWidget(),
            // endDrawer: FilterWidget(onFilter: (_) {
            //   Navigator.of(context).pushReplacementNamed(
            //     '/Pages',
            //     arguments: state.currentTab,
            //   );
            // }),
            // body: state.currentPage,
              body: (state.currentTab == 0 || state.currentTab == 2 || state.currentTab == 4)
                  ? NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      pinned: true,
                      floating: true,
                      snap: true,
                      centerTitle: true,
                      backgroundColor: Theme.of(context).colorScheme.onPrimary,
                      leading: AnimatedBuilder(
                        animation: _iconsAnimation,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _iconsAnimation.value,
                            child: IconButton(
                              icon: const Icon(Icons.menu),
                              color: Theme.of(context).colorScheme.primary,
                              onPressed: () => _navBarScaffoldKey.currentState?.openDrawer(),
                            ),
                          );
                        },
                      ),
                      actions: [
                        AnimatedBuilder(
                          animation: _iconsAnimation,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _iconsAnimation.value,
                              child: BlocBuilder<CartBloc, CartState>(
                                builder: (context, cartState) {
                                  final cartCount = cartState.totalItems;
                                  return Stack(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.shopping_cart, color: Theme.of(context).colorScheme.primary),
                                        onPressed: ()async {
                                          final isUserLoggedIn=await UserRepository().isUserAuthenticated();
                                          if(isUserLoggedIn){
                                            Navigator.pushNamed(context, RouteNames.cartScreen);

                                          }else{
                                            LoginRequiredBottomSheet.show(context);
                                          }
                                          },
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
                            );
                          },
                        ),
                      ],
                      expandedHeight: 120,
                      title: AnimatedBuilder(
                        animation: _titleAnimation,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _titleAnimation.value,
                            child: state.currentTab==2?Image.asset(AppImages.speezuLogo,width: 110,):Text(

                              screenTitles[state.currentTab],
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.9),
                                fontFamily: FontFamily.fontsPoppinsSemiBold,
                                fontSize: context.scaledFont(19),
                              ),
                            ),
                          );
                        },
                      ),

                      flexibleSpace: LayoutBuilder(
                        builder: (context, constraints) {
                          final maxHeight = 120.0; // expanded height of the SliverAppBar
                          final minHeight = kToolbarHeight; // collapsed height
                          final currentHeight = constraints.biggest.height;

                          // shrinkFactor: 0 (expanded) -> 1 (collapsed)
                          final shrinkFactor = (maxHeight - currentHeight) / (maxHeight - minHeight);

                          final fullWidth = MediaQuery.of(context).size.width - 32; // full width minus padding
                          final collapsedWidth = fullWidth * 0.6; // width when collapsed (slightly larger for better UX)
                          
                          // Smooth interpolation for width and opacity
                          final animatedWidth = lerpDouble(fullWidth, collapsedWidth, shrinkFactor.clamp(0.0, 1.0)) ?? fullWidth;
                          final searchOpacity = lerpDouble(1.0, 0.8, shrinkFactor.clamp(0.0, 1.0)) ?? 1.0;

                          return Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeOutCubic,
                                width: animatedWidth,
                                child: AnimatedOpacity(
                                  duration: const Duration(milliseconds: 180),
                                  curve: Curves.easeOutCubic,
                                  opacity: searchOpacity,
                                  child: SearchContainer(),
                                ),
                              ),
                            ),
                          );
                        },
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
              // Other tabs render normally, no scroll wrapping


            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Theme.of(context).colorScheme.primary,
              selectedFontSize: 0,
              unselectedFontSize: 0,
              iconSize: context.scaledFont(22),
              elevation: 3,

              backgroundColor: Theme.of(context).colorScheme.onPrimary,
              selectedIconTheme: IconThemeData(size: context.scaledFont(26)),
              unselectedItemColor: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 1),
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
                    width: context.widthPct(.1),
                    height: context.widthPct(.1),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: .5),
                          blurRadius: 40,
                          offset: const Offset(0, 15),
                        ),
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSecondary.withValues(alpha: .3),
                          blurRadius: 13,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.home,
                      color: Theme.of(context).colorScheme.onPrimary,
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
          );
        },
        ),
      ),
    );
  }

}
mixin ScrollableScreen {
  Widget withScrollController(ScrollController controller);

}