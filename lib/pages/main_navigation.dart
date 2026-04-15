// Copyright (c) 2026, Owen Danke

// Flutter
import 'package:flutter/material.dart';

// httapp
import 'package:httapp/main.dart';
import 'package:httapp/routes/app_routes.dart';
import 'package:httapp/ui/theme.dart';
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

class _MainNavigationState extends State<MainNavigation> with SingleTickerProviderStateMixin {

  /// Tracks which tab is currently selected
  /// 0 = Home
  /// 1 = Explore
  /// 2 = Map
  /// 3 = Settings
  int _currentIndex = 0;

  final _tabLabels = ['Home', 'Explore', 'Map', 'Settings'];
  final _tabIcons = [Icons.home_outlined, Icons.explore_outlined, Icons.map_outlined, Icons.settings_outlined];
  final _tabSelectedIcons = [Icons.home, Icons.explore, Icons.map, Icons.settings];

  static ColorScheme colorScheme = MaterialTheme.lightScheme();

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

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabLabels.length, vsync: this);
  }

  static Widget _tabItem(IconData icon, IconData selectedIcon, String label, {bool isSelected = false}) {
    return AnimatedContainer(
      alignment: Alignment.center,
      duration: Duration(milliseconds: 300),
      decoration: isSelected
        ? BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: colorScheme.tertiaryContainer,
        )
        : null,

        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isSelected
              ? Icon(selectedIcon, color: colorScheme.secondary)
              : Icon(icon, color: colorScheme.onPrimary),
            isSelected
              ? Text(label, style: TextStyle(color: colorScheme.onTertiaryContainer))
              : Text(label, style: TextStyle(color: colorScheme.onPrimary)),
          ],
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom + 12;

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
        body: Stack(
          children: [
            // main content
            Positioned.fill(
              /*
                IndexedStack keeps ALL tabs alive.
                Only the widget at index = _currentIndex is visible.
                Others remain in memory.
              */
              child: IndexedStack(
                index: _currentIndex,

                // children is a list of widgets (pages) and the child (entry) at index will be displayed
                children: List.generate(_routeModules.length, (index) => _buildNavigator(index, _routeModules[index]),
                ),
              ),
            ),
            
            // Floating bottom navigation bar
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 100,
                padding: EdgeInsets.fromLTRB(12, 0, 12, bottomInset),
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(20),
                  child: Container(
                    color: colorScheme.primary,
                    child: TabBar(
                      controller: _tabController,
                      tabAlignment: TabAlignment.fill,

                      labelColor: colorScheme.secondary,
                      unselectedLabelColor: colorScheme.onPrimary,

                      indicator: UnderlineTabIndicator(borderSide: BorderSide.none),
                      onTap: (int index) {
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
                      tabs: [
                        for (int i = 0; i < _tabLabels.length; i++)
                          _tabItem(_tabIcons[i], _tabSelectedIcons[i], _tabLabels[i], isSelected: i == _currentIndex),
                      ],
                    ),
                  )
                )
              )
            )
          ],
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