import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speezu/core/assets/font_family.dart';
import 'package:speezu/core/utils/labels.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';
import 'package:speezu/presentation/drawers/end_drawer.dart';

import '../../repositories/user_repository.dart';
import '../../routes/route_names.dart';
import '../../widgets/search_animated_container.dart';
import '../drawers/drawer.dart';
import '../home/home_screen.dart';
import 'bloc/nav_bar_bloc.dart';
import 'bloc/nav_bar_event.dart';
import 'bloc/nav_bar_state.dart';

class NavBarScreen extends StatefulWidget {
  final dynamic currentTab;

  NavBarScreen({super.key, this.currentTab});

  @override
  State<NavBarScreen> createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {
  final GlobalKey<ScaffoldState> _navBarScaffoldKey =
      GlobalKey<ScaffoldState>();

  final ScrollController _scrollController = ScrollController();
  bool _showTitle = true;


  @override
  void initState() {
    // TODO: implement initState
    _scrollController.addListener(() {
      // Hide when scrolling down, show when scrolling up
      if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        if (_showTitle) setState(() => _showTitle = false);
      } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
        if (!_showTitle) setState(() => _showTitle = true);
      }
    });
    super.initState();
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
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RouteNames.cartScreen);
                  },
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Theme.of(context).colorScheme.primary,
                  ),
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
                        ? SearchContainer(onSearchTap: () {})
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
                  double getShrinkFactor() {
                    final maxHeight = 120.0;
                    final minHeight = kToolbarHeight;
                    final offset = _scrollController.hasClients ? _scrollController.offset : 0.0;
                    final shrink = (offset / (maxHeight - minHeight)).clamp(0.0, 1.0);
                    return shrink;
                  }

                  return [
                    SliverAppBar(
                      pinned: true,
                      floating: true,
                      snap: true,
                      centerTitle: true,
                      backgroundColor: Theme.of(context).colorScheme.onPrimary,
                      leading: IconButton(
                        icon: const Icon(Icons.menu),
                        color: Theme.of(context).colorScheme.primary,
                        onPressed: () => _navBarScaffoldKey.currentState?.openDrawer(),
                      ),
                      actions: [
                        IconButton(
                          icon: Icon(Icons.shopping_cart, color: Theme.of(context).colorScheme.primary),
                          onPressed: () => Navigator.pushNamed(context, RouteNames.cartScreen),
                        ),
                      ],
                      expandedHeight: 120,
                      title: Visibility(
                        visible: _showTitle,
                        child: Text(
                          screenTitles[state.currentTab],
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.9),
                            fontFamily: FontFamily.fontsPoppinsSemiBold,
                            fontSize: context.scaledFont(19),
                          ),
                        ),
                      ),

                      flexibleSpace: LayoutBuilder(
                        builder: (context, constraints) {
                          final maxHeight = 120.0; // expanded height of the SliverAppBar
                          final minHeight = kToolbarHeight; // collapsed height
                          final currentHeight = constraints.biggest.height;

                          // shrinkFactor: 0 (expanded) -> 1 (collapsed)
                          final shrinkFactor = (maxHeight - currentHeight) / (maxHeight - minHeight);

                          final fullWidth = MediaQuery.of(context).size.width - 32; // full width minus padding
                          final collapsedWidth = fullWidth * 0.5; // width when collapsed (adjust as needed)

                          return Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 100),
                                width: lerpDouble(fullWidth, collapsedWidth, shrinkFactor),
                                child: SearchContainer(onSearchTap: () {}),
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
    );
  }
}
mixin ScrollableScreen {
  Widget withScrollController(ScrollController controller);

}