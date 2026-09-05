import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/store/roamli_store.dart';
import '../../core/theme/roamli_colors.dart';
import '../../core/widgets/common.dart';

class PlaceDetailScreen extends StatelessWidget {
  final PlaceRef place;
  const PlaceDetailScreen({super.key, required this.place});

  void message(BuildContext context, String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  @override
  Widget build(BuildContext context) {
    final store = RoamliScope.of(context);
    return Scaffold(
      appBar: AppBar(actions: [IconButton(onPressed: () => store.toggleSaved(place.placeId), icon: Icon(store.isSaved(place.placeId) ? Icons.favorite : Icons.favorite_border, color: store.isSaved(place.placeId) ? RoamliColors.coral : null))]),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
        children: [
          TravelHero(eyebrow: place.category, title: place.name, subtitle: place.subtitle, icon: place.category == 'Restaurant' ? Icons.restaurant : Icons.place, height: 260),
          const SizedBox(height: 20),
          Row(children: [Text('★ ${place.rating.toStringAsFixed(1)}', style: Theme.of(context).textTheme.titleMedium), if (place.priceLevel.isNotEmpty) ...[const SizedBox(width: 12), Text(place.priceLevel)], const Spacer(), Chip(label: Text(place.openNow ? 'Open now' : 'Check hours'))]),
          const SizedBox(height: 14),
          Text(place.description.isEmpty ? 'A place selected for your ROAMLI trip.' : place.description, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 24),
          const SectionTitle('Location'),
          MockMap(places: [place]),
          const SizedBox(height: 18),
          Row(children: [Expanded(child: OutlinedButton.icon(onPressed: () => message(context, 'Directions will open through the map provider once APIs are connected.'), icon: const Icon(Icons.directions), label: const Text('Directions'))), const SizedBox(width: 10), Expanded(child: OutlinedButton.icon(onPressed: () { store.addStop(0, place); message(context, '${place.name} added to Day 1'); }, icon: const Icon(Icons.add_circle_outline), label: const Text('Add to Trip')))]),
          if (place.category == 'Restaurant') ...[
            const SizedBox(height: 12),
            ElevatedButton.icon(onPressed: () {
              if (place.bookingUrl != null) {
                message(context, 'Production build: open the restaurant’s external reservation page. ROAMLI will not claim a booking is confirmed.');
              } else if (place.phone != null) {
                message(context, 'Production build: call ${place.phone}.');
              } else {
                message(context, 'No verified reservation link is available. Website and directions remain available.');
              }
            }, icon: const Icon(Icons.event_available_outlined), label: Text(place.bookingUrl != null ? 'Reserve a Table' : place.phone != null ? 'Call Restaurant' : 'View Website')),
            const SizedBox(height: 8),
            Text('Reservations are handled by the restaurant or external booking service, not by ROAMLI.', style: Theme.of(context).textTheme.bodySmall),
          ],
          if (place.category == 'Stay') ...[
            const SizedBox(height: 18),
            Card(child: ListTile(leading: const Icon(Icons.route), title: const Text('Use as daily starting point'), subtitle: const Text('When selected as your stay, routes can start and end here.'), trailing: const Icon(Icons.check_circle, color: RoamliColors.explorerGreen))),
          ],
        ],
      ),
    );
  }
}
