import 'package:flutter/material.dart';

enum RoamliSystemState {building, offline, location, noResults, placeUnavailable, emptySaved, emptyTrips, genericError, rateLimited, plusLocked, maintenance, connectionLost, regionUnavailable, invalidLink}

class SystemStateScreen extends StatelessWidget {
  final RoamliSystemState state;
  const SystemStateScreen({super.key, required this.state});
  @override
  Widget build(BuildContext context) {
    final data = _data(state);
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(data.$1, size: 90, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 24),
          Text(data.$2, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          Text(data.$3, textAlign: TextAlign.center),
          const SizedBox(height: 26),
          ElevatedButton(onPressed: () => Navigator.maybePop(context), child: Text(data.$4)),
        ]),
      ),
    );
  }

  static (IconData, String, String, String) _data(RoamliSystemState state) => switch (state) {
    RoamliSystemState.building => (Icons.public, 'Building your trip…', 'Finding top places, organizing your itinerary, and adding the final touches.', 'Continue'),
    RoamliSystemState.offline => (Icons.wifi_off, 'You’re offline', 'Check your connection and try again. Saved trips can remain available offline.', 'Try Again'),
    RoamliSystemState.location => (Icons.location_on, 'Use your location', 'Allow location to find places nearby and improve routes. You can still plan trips without it.', 'Allow Location'),
    RoamliSystemState.noResults => (Icons.search_off, 'No results found', 'Try a different search or adjust your filters.', 'Try a New Search'),
    RoamliSystemState.placeUnavailable => (Icons.signpost_outlined, 'We couldn’t load this place', 'This place is currently unavailable or its information could not be loaded.', 'Try Again'),
    RoamliSystemState.emptySaved => (Icons.favorite_border, 'No saved places yet', 'Start exploring and save the places you love.', 'Explore Places'),
    RoamliSystemState.emptyTrips => (Icons.luggage_outlined, 'No trips yet', 'Your next adventure is just a few taps away.', 'Plan a New Trip'),
    RoamliSystemState.genericError => (Icons.error_outline, 'Something went wrong', 'We couldn’t load this right now. Please try again.', 'Try Again'),
    RoamliSystemState.rateLimited => (Icons.hourglass_bottom, 'Hold on a moment', 'There’s a lot happening right now. Please wait a little and try again.', 'Try Again'),
    RoamliSystemState.plusLocked => (Icons.lock_outline, 'This feature is part of ROAMLI+', 'Unlock deeper discovery and premium trip tools.', 'Explore ROAMLI+'),
    RoamliSystemState.maintenance => (Icons.construction, 'We’ll be back soon', 'We’re making some improvements to make your experience even better.', 'Try Again'),
    RoamliSystemState.connectionLost => (Icons.cloud_off, 'Connection lost', 'We couldn’t load new content. Check your connection and try again.', 'Try Again'),
    RoamliSystemState.regionUnavailable => (Icons.public_off, 'Not available in this region', 'This feature isn’t available in your current location yet.', 'Go Back'),
    RoamliSystemState.invalidLink => (Icons.link_off, 'This link isn’t valid', 'It may have expired or been removed.', 'Go Back'),
  };
}

class SystemStatesGallery extends StatelessWidget {
  const SystemStatesGallery({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('System States')),
    body: ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: RoamliSystemState.values.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final state = RoamliSystemState.values[i];
        return Card(child: ListTile(title: Text(state.name), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SystemStateScreen(state: state)))));
      },
    ),
  );
}
