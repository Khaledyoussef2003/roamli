import 'package:flutter/material.dart';
import '../theme/roamli_colors.dart';
import '../../features/explore/explore_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/planner/plan_trip_flow.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/saved/saved_screen.dart';

class AppShell extends StatefulWidget {
  final int initialIndex;
  const AppShell({super.key, this.initialIndex = 0});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late int index = widget.initialIndex;
  final pages = const [HomeScreen(), ExploreScreen(), PlannerLanding(), SavedScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) => Scaffold(
    body: IndexedStack(index: index, children: pages),
    bottomNavigationBar: NavigationBar(
      selectedIndex: index,
      height: 72,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      onDestinationSelected: (value) => setState(() => index = value),
      destinations: [
        const NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
        const NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore), label: 'Explore'),
        NavigationDestination(
          icon: Container(width: 44, height: 44, decoration: const BoxDecoration(color: RoamliColors.coral, shape: BoxShape.circle), child: const Icon(Icons.add_road, color: Colors.white)),
          selectedIcon: Container(width: 48, height: 48, decoration: const BoxDecoration(color: RoamliColors.coral, shape: BoxShape.circle), child: const Icon(Icons.route, color: Colors.white)),
          label: 'Planner',
        ),
        const NavigationDestination(icon: Icon(Icons.favorite_border), selectedIcon: Icon(Icons.favorite), label: 'Saved'),
        const NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
      ],
    ),
  );
}
