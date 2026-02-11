import 'package:flutter/material.dart';
import 'package:httapp/main.dart';
import 'package:httapp/routes/app_routes.dart';

// Routes (correspond to tabs on the navigation bar)
import 'package:httapp/routes/home_routes.dart';
import 'package:httapp/routes/explore_routes.dart';
import 'package:httapp/routes/map_routes.dart';
import 'package:httapp/routes/settings_routes.dart';

/// MainNavigation
/// This widget controls:
/// - Bottom navigation bar
/// - Per-tab navigation stacks
/// - Back button behavior
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {

  /// Tracks which tab is currently selected
  /// 0 = Home
  /// 1 = Explore
  /// 2 = Map
  /// 3 = Settings
  int _currentIndex = 0;

  /// Route modules define:
  /// - initialRoute for a tab
  /// - available routes inside that tab
  /// 
  /// Each tab has its own route configuration.
  final List<AppRoutes> _routeModules = [
    HomeRoutes(),
    ExploreRoutes(externalRoutes: treePageData),
    MapRoutes(externalRoutes: treePageData),
    SettingsRoutes(),
  ];
  
  /*
    Each tab gets its own Navigator.
    We use a GlobalKey so we can:
    - Access navigator state
    - Pop routes programmatically
    - Preserve navigation history per tab
  */
  late final List<GlobalKey<NavigatorState>> _navigatorKeys = List.generate(_routeModules.length, (index) => GlobalKey<NavigatorState>());

  @override
  Widget build(BuildContext context) {
    return PopScope(

      // Prevent system back button from automatically closing app
      canPop: false,

      // Custom back button handling
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        
        // Try to pop current tab's navigator stack
        final isFirstRouteInCurrentTab = !await _navigatorKeys[_currentIndex].currentState!.maybePop();
        
        // If we're already at root of current tab
        if (isFirstRouteInCurrentTab) {

          // If not on Home tab, then switch to Home
          if (_currentIndex != 0) {
            setState(() => _currentIndex = 0);
          }
        }
      },
      child: Scaffold(
        /*
          IndexedStack keeps ALL tabs alive.
          Only the widget at index = _currentIndex is visible.
          Others remain in memory.
        */
        body: IndexedStack(
          index: _currentIndex,

          // children is a list of widgets (pages) and the child (entry) at index will be displayed
          children: List.generate(_routeModules.length, (index) => _buildNavigator(index, _routeModules[index]),
          ),
        ),

        // Bottom navigation bar
        bottomNavigationBar: NavigationBarTheme(

          // set theme data current theme from context
          data: Theme.of(context).navigationBarTheme,
          child: NavigationBar(
            selectedIndex: _currentIndex,

            // called when tab item is tapped
            onDestinationSelected: 
            (int index) {
              if (_currentIndex == index){
                // if taping the same tab, pop navigator to root page
                _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
              }
              else {
                // change index from the current tab to the requested tab
                setState((){
                  _currentIndex = index;
                  }
                );
              }
            },
            // tab items (destinations)
            destinations: const [
              // Home
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Home',
              ),

              // Explore
              NavigationDestination(
                icon: Icon(Icons.explore_outlined),
                selectedIcon: Icon(Icons.explore),
                label: 'Explore',
              ),

              // Map
              NavigationDestination(
                icon: Icon(Icons.map_outlined),
                selectedIcon: Icon(Icons.map),
                label: 'Map',
              ),

              // Settings
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          )
        ),
      ),
    );
  }

  /* Helper functions */

  /// Allows pages to:
  /// - Switch tabs
  /// - Navigate to a route inside another tab
  void _onTabChange(int newIndex, {String? routeName}) {

    // switch tabs
    setState(() {
      _currentIndex = newIndex;
    });

    // if a route name was provided,
    // navigate to it inside new tab after switching tabs
    if (routeName != null) {
      // reset to requested tab to root
      _navigatorKeys[newIndex].currentState?.popUntil((route) => route.isFirst);

      // push the desired named route
      _navigatorKeys[newIndex].currentState?.pushNamed(routeName);
    }
  }

  /// Builds a Navigator for each tab.
  /// Each Navigator has:
  /// - Its own route stack
  /// - Its own navigation history
  Widget _buildNavigator(int index, AppRoutes routeModule) {
    return Navigator(
      key: _navigatorKeys[index],

      // initial route for the tab
      initialRoute: routeModule.initialRoute,

      // called whenever a route is pushed in this tab
      onGenerateRoute: (settings) {

        // Retrieve the route map for this tab from its route module.
        // Pass the tab change callback and whether this tab is currently active.
        // `isActiveTab` lets pages (e.g., MapPage) react when the tab becomes inactive.
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