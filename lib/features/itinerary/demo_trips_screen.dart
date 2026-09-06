import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/store/roamli_store.dart';
import '../../core/theme/roamli_colors.dart';
import '../../core/widgets/common.dart';
import 'itinerary_screen.dart';

class DemoTripsScreen extends StatelessWidget {
  final bool showAppBar;
  const DemoTripsScreen({super.key, this.showAppBar = true});

  @override
  Widget build(BuildContext context) {
    final store = RoamliScope.of(context);
    final content = ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
      children: [
        if (!showAppBar) ...[
          Text('My Trips', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 8),
          Text('Five different mock trips expose more of ROAMLI before live APIs are connected.', style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 20),
        ],
        ...store.demoTrips.map((trip) => Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: _TripCard(trip: trip),
        )),
      ],
    );
    if (!showAppBar) return SafeArea(child: content);
    return Scaffold(appBar: AppBar(title: const Text('My Trips')), body: content);
  }
}

class _TripCard extends StatelessWidget {
  final DemoTrip trip;
  const _TripCard({required this.trip});

  @override
  Widget build(BuildContext context) {
    final store = RoamliScope.of(context);
    final color = switch (trip.status) {
      'Planned' => RoamliColors.explorerGreen,
      'Needs attention' => Colors.orange,
      _ => RoamliColors.coral,
    };
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () {
          store.openDemoTrip(trip);
          Navigator.push(context, MaterialPageRoute(builder: (_) => const ItineraryScreen()));
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            TravelHero(
              eyebrow: '${trip.country.toUpperCase()} · ${trip.days} DAYS',
              title: trip.title,
              subtitle: '${trip.adults + trip.children} travelers · ${trip.preferences.budget} · ${trip.preferences.pace}',
              icon: _iconFor(trip.destination),
              height: 150,
            ),
            const SizedBox(height: 14),
            Row(children: [
              Container(width: 9, height: 9, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              const SizedBox(width: 7),
              Text(trip.status, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: color)),
              const Spacer(),
              Text('${trip.start.day}/${trip.start.month}/${trip.start.year}'),
            ]),
            const SizedBox(height: 10),
            Text(trip.highlight, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 10),
            Row(children: [
              Icon(trip.stay == null ? Icons.add_location_alt_outlined : Icons.hotel_outlined, size: 18),
              const SizedBox(width: 7),
              Expanded(child: Text(trip.stay?.name ?? 'Stay not booked yet', maxLines: 1, overflow: TextOverflow.ellipsis)),
              const Icon(Icons.chevron_right),
            ]),
            const SizedBox(height: 10),
            Wrap(spacing: 7, runSpacing: 7, children: trip.featureTags.take(4).map((tag) => Chip(label: Text(tag))).toList()),
          ]),
        ),
      ),
    );
  }

  IconData _iconFor(String destination) {
    if (destination.contains('Dubai')) return Icons.location_city;
    if (destination.contains('Ibiza')) return Icons.nightlife;
    if (destination.contains('Rome')) return Icons.train;
    if (destination.contains('Prague')) return Icons.account_balance;
    if (destination.contains('Mykonos')) return Icons.beach_access;
    return Icons.travel_explore;
  }
}
