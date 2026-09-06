import 'package:flutter/material.dart';
import '../../core/mock/mock_data.dart';
import '../../core/store/roamli_store.dart';
import '../../core/widgets/common.dart';
import '../explore/explore_screen.dart';
import '../itinerary/itinerary_screen.dart';
import '../itinerary/demo_trips_screen.dart';
import '../notifications/notifications_screen.dart';
import '../planner/plan_trip_flow.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = RoamliScope.of(context);
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 22, child: Text('OY')),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Good afternoon, Omar', style: Theme.of(context).textTheme.titleLarge), Text('Where do you want to go next?', style: Theme.of(context).textTheme.bodySmall)])),
              IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen())), icon: Badge(isLabelVisible: store.notifications.any((n) => n.unread), child: const Icon(Icons.notifications_outlined))),
            ],
          ),
          const SizedBox(height: 24),
          Text('Where do you want to go?', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 8),
          Text('Plan your next trip with us, tailored to you.', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          const SizedBox(height: 18),
          TextField(
            readOnly: true,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ExploreScreen(standalone: true))),
            decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search destinations, places or food'),
          ),
          const SizedBox(height: 18),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            crossAxisSpacing: 9,
            children: [
              _Quick(icon: Icons.route, label: 'Plan a Trip', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PlanTripFlow()))),
              _Quick(icon: Icons.near_me_outlined, label: 'Nearby', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ExploreScreen(standalone: true, initialCategory: 'Nearby')))),
              _Quick(icon: Icons.restaurant_outlined, label: 'Restaurants', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ExploreScreen(standalone: true, initialCategory: 'Restaurants')))),
              _Quick(icon: Icons.local_activity_outlined, label: 'Experiences', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ExploreScreen(standalone: true, initialCategory: 'Experiences')))),
            ],
          ),
          const SizedBox(height: 26),
          SectionTitle('Upcoming Trip', action: 'All trips', onAction: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DemoTripsScreen()))),
          Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: () { store.openDemoTrip(store.demoTrips.first); Navigator.push(context, MaterialPageRoute(builder: (_) => const ItineraryScreen())); },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  TravelHero(eyebrow: '16–18 OCT · 2 TRAVELERS', title: store.demoTrips.first.title, subtitle: 'Dubai · 3 days · Exact stay selected', icon: Icons.location_city, height: 180),
                  const SizedBox(height: 14),
                  Row(children: [const Icon(Icons.hotel_outlined, size: 18), const SizedBox(width: 7), Expanded(child: Text('${store.demoTrips.first.stay!.name} · daily route anchor')), const Icon(Icons.chevron_right)]),
                ]),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SectionTitle('Trip drafts', action: 'View all', onAction: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DemoTripsScreen()))),
          const SizedBox(height: 10),
          SizedBox(height: 118, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: store.demoTrips.length - 1, separatorBuilder: (_, __) => const SizedBox(width: 10), itemBuilder: (context, i) {
            final trip = store.demoTrips[i + 1];
            return InkWell(onTap: () { store.openDemoTrip(trip); Navigator.push(context, MaterialPageRoute(builder: (_) => const ItineraryScreen())); }, child: Container(width: 210, padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(18), border: Border.all(color: Theme.of(context).dividerColor)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(trip.destination, style: Theme.of(context).textTheme.titleMedium), const SizedBox(height: 4), Text('${trip.status} · ${trip.days} days', style: Theme.of(context).textTheme.bodySmall), const Spacer(), Text(trip.preferences.interests.take(2).join(' · '), maxLines: 1, overflow: TextOverflow.ellipsis)])));
          })),
          const SizedBox(height: 28),
          SectionTitle('Recommended for You', action: 'See all', onAction: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ExploreScreen(standalone: true)))),
          const SizedBox(height: 10),
          SizedBox(
            height: 170,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, i) {
                final place = [MockData.pelekanos, MockData.hiddenGem, MockData.sailing, MockData.redBeach][i];
                return SizedBox(width: 270, child: PlaceCard(place: place, compact: true));
              },
            ),
          ),
          const SizedBox(height: 28),
          const SectionTitle('Trending Destinations'),
          const SizedBox(height: 10),
          const Row(children: [Expanded(child: _Destination(name: 'Kyoto', detail: 'Japan', icon: Icons.temple_buddhist)), SizedBox(width: 10), Expanded(child: _Destination(name: 'Amalfi', detail: 'Italy', icon: Icons.sailing))]),
        ],
      ),
    );
  }
}

class _Quick extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _Quick({required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(
    borderRadius: BorderRadius.circular(18),
    onTap: onTap,
    child: Column(children: [Expanded(child: Container(width: 58, decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: .55), borderRadius: BorderRadius.circular(18)), child: Icon(icon))), const SizedBox(height: 7), Text(label, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700))]),
  );
}

class _Destination extends StatelessWidget {
  final String name;
  final String detail;
  final IconData icon;
  const _Destination({required this.name, required this.detail, required this.icon});
  @override
  Widget build(BuildContext context) => Container(
    height: 150,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(22), gradient: const LinearGradient(colors: [Color(0xFF28465D), Color(0xFF77B7B8)])),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, color: Colors.white, size: 44), const Spacer(), Text(name, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)), Text(detail, style: const TextStyle(color: Colors.white70))]),
  );
}
