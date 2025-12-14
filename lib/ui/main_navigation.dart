import 'package:flutter/material.dart';
import 'package:holcomb_tree_trail/main.dart';
import 'package:holcomb_tree_trail/routes/app_routes.dart';

// Routes (correspond to tabs on the navigation bar)
import 'package:holcomb_tree_trail/routes/home_routes.dart';
import 'package:holcomb_tree_trail/routes/explore_routes.dart';
import 'package:holcomb_tree_trail/routes/map_routes.dart';
import 'package:holcomb_tree_trail/routes/settings_routes.dart';


class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  /* Initialize route modules
    These determine what navigation routes are available on a tab
    Each tab has its own routes based on the index of this list
  */
  final List<AppRoutes> _routeModules = [
    HomeRoutes(),
    ExploreRoutes(externalRoutes: treePageData),
    MapRoutes(),
    SettingsRoutes(),
  ];
  
  // Global keys to preserve navigator state for each tab
  // makes each tab stateful
  late final List<GlobalKey<NavigatorState>> _navigatorKeys = List.generate(_routeModules.length, (index) => GlobalKey<NavigatorState>());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        
        final isFirstRouteInCurrentTab = !await _navigatorKeys[_currentIndex].currentState!.maybePop();
        
        if (isFirstRouteInCurrentTab) {
          if (_currentIndex != 0) {
            setState(() => _currentIndex = 0);
          }

        }
      },
      child: Scaffold(
        // IndexedStack contains the page that is displayed
        body: IndexedStack(
          index: _currentIndex,
          // children is a list of widgets (pages) and the child (entry) at index will be displayed
          children: List.generate(_routeModules.length, (index) => _buildNavigator(index, _routeModules[index]),
          ),
        ),
        // NavigationBarTheme to set custom colors on the nav bar
        bottomNavigationBar: NavigationBarTheme(
          // create a NavigationBarThemeData and set with colors from the current theme
          data: NavigationBarThemeData(
            backgroundColor: Theme.of(context).colorScheme.primary,
            indicatorColor: Theme.of(context).colorScheme.secondary,
            labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
                (Set<WidgetState> states) => TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
            iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
                (Set<WidgetState> states) => states.contains(WidgetState.selected)
                ? IconThemeData(color: Theme.of(context).colorScheme.secondaryContainer)
                : IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
              ),
          ),
          child: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: 
            (int index) {
              if (_currentIndex == index){
                // tap the same tab to pop navigator to root page
                _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
              }
              else {
                // change from the current tab to the requested tab
                setState((){
                  _currentIndex = index;
                  }
                );
              }
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.search_outlined),
                selectedIcon: Icon(Icons.explore),
                label: 'Explore',
              ),
              NavigationDestination(
                icon: Icon(Icons.map_outlined),
                selectedIcon: Icon(Icons.map),
                label: 'Map',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings),
                selectedIcon: Icon(Icons.settings_outlined),
                label: 'Settings',
              ),
            ],
          )
        ),
      ),
    );
  }

  // Helper functions
  void _onTabChange(int newIndex, {String? routeName}) {
    // switch tabs
    setState(() {
      _currentIndex = newIndex;
    });
    // Navigate to specific route after switching tabs
    if (routeName != null) {
      Future.delayed(Duration(milliseconds: 100), () {
        _navigatorKeys[newIndex].currentState?.pushNamed(routeName);
      });
    }
  }

  Widget _buildNavigator(int index, AppRoutes routeModule) {
    return Navigator(
      key: _navigatorKeys[index],
      initialRoute: routeModule.initialRoute,
      onGenerateRoute: (settings) {
        final routes = routeModule.getRoutes(context, onTabChange: _onTabChange);
        final builder = routes[settings.name];
        if (builder != null) {
          return MaterialPageRoute(
            builder: builder,
            settings: settings,
          );
        }
        return null;
      },
    );
  }
}