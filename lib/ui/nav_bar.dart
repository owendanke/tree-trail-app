import 'package:flutter/material.dart';
import 'package:holcomb_tree_trail/routes/app_routes.dart';

// Routes
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

  // Initialize route modules
  final List<AppRoutes> _routeModules = [
    HomeRoutes(),
    ExploreRoutes(),
    MapRoutes(),
    SettingsRoutes(),
  ];
  

  // Global keys to preserve navigator state for each tab
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
        body: IndexedStack(
          index: _currentIndex,
          children: List.generate(
            _routeModules.length,
            (index) => _buildNavigator(index, _routeModules[index]),
          ),
        ),
        bottomNavigationBar: NavigationBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          indicatorColor: Theme.of(context).colorScheme.secondary,
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            if (_currentIndex == index){
              // tap the same tab to pop to root page
              _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
            }
            else {
              setState(() {
                _currentIndex = index;
              });
            }
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home, color: Color(0xff942824)),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.search_outlined),
              selectedIcon: Icon(Icons.explore, color: Color(0xff942824)),
              label: 'Explore',
            ),
            NavigationDestination(
              icon: Icon(Icons.map_outlined),
              selectedIcon: Icon(Icons.map, color: Color(0xff942824)),
              label: 'Map',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings),
              selectedIcon: Icon(Icons.settings_outlined, color: Color(0xff942824)),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }

  // Helper function
  Widget _buildNavigator(int index, AppRoutes routeModule) {
    return Navigator(
      key: _navigatorKeys[index],
      initialRoute: routeModule.initialRoute,
      onGenerateRoute: (settings) {
        final routes = routeModule.getRoutes(context);
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