import 'package:flutter/material.dart';
import '../../core/mock/mock_data.dart';
import '../../core/store/roamli_store.dart';
import '../../core/widgets/common.dart';
import '../itinerary/itinerary_screen.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});
  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  int tab = 0;
  String query = '';

  @override
  Widget build(BuildContext context) {
    final store = RoamliScope.of(context);
    final saved = MockData.allDemoPlaces.where((p) => store.isSaved(p.placeId) && p.name.toLowerCase().contains(query.toLowerCase())).toList();
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Saved', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 8),
          Text('Keep trip ideas, restaurants and collections in one place.', style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 16),
          TextField(onChanged: (v) => setState(() => query = v), decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search your saved items…')),
          const SizedBox(height: 16),
          SegmentedButton<int>(showSelectedIcon: false, segments: const [ButtonSegment(value: 0, label: Text('All')), ButtonSegment(value: 1, label: Text('Collections')), ButtonSegment(value: 2, label: Text('Trips'))], selected: {tab}, onSelectionChanged: (s) => setState(() => tab = s.first)),
          const SizedBox(height: 22),
          if (tab == 0) ...[
            const SectionTitle('Collections'),
            const SizedBox(height: 10),
            SizedBox(height: 88, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: store.collections.length, separatorBuilder: (_, __) => const SizedBox(width: 10), itemBuilder: (context, i) => _CollectionMini(name: store.collections[i].name, count: store.collections[i].placeIds.length))),
            const SizedBox(height: 24),
            const SectionTitle('Saved Places'),
            if (saved.isEmpty) const _EmptySaved() else ...saved.map((p) => Padding(padding: const EdgeInsets.only(bottom: 10), child: PlaceCard(place: p))),
          ] else if (tab == 1) ...[
            Row(children: [Expanded(child: Text('Your collections', style: Theme.of(context).textTheme.headlineSmall)), IconButton(onPressed: () => _newCollection(context), icon: const Icon(Icons.add))]),
            const SizedBox(height: 10),
            ...store.collections.map((c) => Card(margin: const EdgeInsets.only(bottom: 10), child: ListTile(leading: const CircleAvatar(child: Icon(Icons.folder_outlined)), title: Text(c.name), subtitle: Text('${c.placeIds.length} places${c.note.isEmpty ? '' : ' · ${c.note}'}'), trailing: const Icon(Icons.chevron_right), onTap: () => _collectionDetails(context, c.name, c.placeIds)))),
          ] else ...[
            const SectionTitle('Saved Trips'),
            ...store.demoTrips.map((trip) => Card(margin: const EdgeInsets.only(bottom: 10), child: ListTile(
              leading: CircleAvatar(child: Icon(trip.stay == null ? Icons.add_location_alt_outlined : Icons.luggage_outlined)),
              title: Text(trip.title),
              subtitle: Text('${trip.status} · ${trip.days} days · ${trip.preferences.budget}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () { store.openDemoTrip(trip); Navigator.push(context, MaterialPageRoute(builder: (_) => const ItineraryScreen())); },
            ))),
          ],
        ],
      ),
    );
  }

  void _newCollection(BuildContext context) {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New collection'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'e.g. Honeymoon'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              final name = controller.text.isEmpty ? 'New collection' : controller.text;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$name created in mock mode.')));
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _collectionDetails(BuildContext context, String name, Set<String> ids) {
    final places = MockData.allDemoPlaces.where((p) => ids.contains(p.placeId)).toList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text(name)),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              if (places.isEmpty)
                const _EmptySaved()
              else
                ...places.map((p) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: PlaceCard(place: p),
                )),
            ],
          ),
        ),
      ),
    );
  }

}

class _CollectionMini extends StatelessWidget {
  final String name;
  final int count;
  const _CollectionMini({required this.name, required this.count});
  @override
  Widget build(BuildContext context) => Container(width: 170, padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(18), border: Border.all(color: Theme.of(context).dividerColor)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.folder_outlined), const SizedBox(height: 7), Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleMedium), Text('$count places', style: Theme.of(context).textTheme.bodySmall)]));
}

class _EmptySaved extends StatelessWidget {
  const _EmptySaved();
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: 40), child: Column(children: [const Icon(Icons.favorite_border, size: 64), const SizedBox(height: 12), Text('No saved places yet', style: Theme.of(context).textTheme.titleLarge), const SizedBox(height: 6), const Text('Start exploring and save places you love.') ]));
}
