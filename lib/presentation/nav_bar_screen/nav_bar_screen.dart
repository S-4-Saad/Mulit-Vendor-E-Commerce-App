import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speezu/core/assets/font_family.dart';
import 'package:speezu/core/utils/labels.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';
import 'package:speezu/presentation/drawers/end_drawer.dart';

import '../../repositories/user_repository.dart';
import '../../routes/route_names.dart';
import '../drawers/drawer.dart';
import 'bloc/nav_bar_bloc.dart';
import 'bloc/nav_bar_event.dart';
import 'bloc/nav_bar_state.dart';

class NavBarScreen extends StatelessWidget {
  final dynamic currentTab;
  final GlobalKey<ScaffoldState> _navBarScaffoldKey =
      GlobalKey<ScaffoldState>();

  final userRepo = UserRepository();
  NavBarScreen({super.key, this.currentTab});
  List<String> screenTitles = [
    Labels.notifications,
    Labels.mapExplorer,
    Labels.speezu,
    Labels.myOrders,
    Labels.favourites,
  ];
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavBarBloc()..add(InitPage(currentTab)),
      child: BlocBuilder<NavBarBloc, NavBarState>(
        builder: (context, state) {
          final bloc = context.read<NavBarBloc>();

          return Scaffold(
            key: _navBarScaffoldKey,
            backgroundColor: Theme.of(context).colorScheme.onPrimary,

            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Theme.of(context).colorScheme.onPrimary,
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
              leading: IconButton(
                onPressed: () {
                  _navBarScaffoldKey.currentState?.openDrawer();
                },

                icon: const Icon(Icons.menu),
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
                screenTitles[state.currentTab],
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSecondary.withValues(alpha: .9),
                  fontFamily: FontFamily.fontsPoppinsSemiBold,
                  fontSize: context.scaledFont(19),
                ),
              ),
            ),
            endDrawer: EndDrawer(),

            drawer: DrawerWidget(),
            // endDrawer: FilterWidget(onFilter: (_) {
            //   Navigator.of(context).pushReplacementNamed(
            //     '/Pages',
            //     arguments: state.currentTab,
            //   );
            // }),
            body: state.currentPage,
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
                  icon: Icon(Icons.notifications),
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
