import 'package:flutter/material.dart';
import '../../core/mock/mock_data.dart';
import '../../core/models/models.dart';
import '../../core/store/roamli_store.dart';
import '../../core/theme/roamli_colors.dart';
import '../../core/widgets/common.dart';

class ItineraryScreen extends StatefulWidget {
  const ItineraryScreen({super.key});
  @override
  State<ItineraryScreen> createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> with SingleTickerProviderStateMixin {
  late final TabController tabs = TabController(length: 4, vsync: this);
  int day = 0;

  @override
  void dispose() {
    tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = RoamliScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(store.activeTrip.title),
        actions: [IconButton(onPressed: () => _tripMenu(context), icon: const Icon(Icons.more_horiz))],
        bottom: TabBar(controller: tabs, tabs: const [Tab(text: 'Overview'), Tab(text: 'Itinerary'), Tab(text: 'Map'), Tab(text: 'Costs')]),
      ),
      body: TabBarView(
        controller: tabs,
        children: [
          _Overview(trip: store.activeTrip, onOpenItinerary: () => tabs.animateTo(1)),
          _ItineraryTab(day: day, onDayChanged: (value) => setState(() => day = value), store: store),
          _MapTab(store: store),
          _CostsTab(store: store),
        ],
      ),
    );
  }

  void _tripMenu(BuildContext context) {
    showModalBottomSheet(context: context, showDragHandle: true, builder: (_) => SafeArea(child: Wrap(children: [
      ListTile(leading: const Icon(Icons.download_outlined), title: const Text('Make available offline'), onTap: () => Navigator.pop(context)),
      ListTile(leading: const Icon(Icons.share_outlined), title: const Text('Share trip'), onTap: () => Navigator.pop(context)),
      ListTile(leading: const Icon(Icons.hotel_outlined), title: const Text('Change stay'), subtitle: const Text('ROAMLI will ask before re-optimizing'), onTap: () { Navigator.pop(context); _changeStay(context); }),
    ])));
  }

  void _changeStay(BuildContext context) {
    showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('Optimize trip from this location?'),
      content: const Text('Your existing itinerary will remain intact unless you choose to re-optimize routes from the new stay.'),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Keep itinerary')), FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Optimize routes'))],
    ));
  }
}

class _Overview extends StatelessWidget {
  final DemoTrip trip;
  final VoidCallback onOpenItinerary;
  const _Overview({required this.trip, required this.onOpenItinerary});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
    children: [
      TravelHero(eyebrow: '${trip.start.day}/${trip.start.month}–${trip.end.day}/${trip.end.month} · ${trip.destination.toUpperCase()}', title: trip.title, subtitle: '${trip.days} days · ${trip.adults + trip.children} travelers · ${trip.preferences.budget} budget', icon: Icons.travel_explore, height: 230),
      const SizedBox(height: 18),
      Card(child: ListTile(leading: const CircleAvatar(child: Icon(Icons.hotel_outlined)), title: Text(trip.stay?.name ?? 'Stay not added yet'), subtitle: Text(trip.stay != null && trip.useStayAsAnchor ? 'Daily start & end point · ${trip.stayStatus}' : '${trip.stayStatus} · Add a stay to improve your routes'), trailing: Icon(trip.stay != null ? Icons.check_circle : Icons.add_location_alt_outlined, color: trip.stay != null ? RoamliColors.explorerGreen : RoamliColors.coral))),
      const SizedBox(height: 12),
      Wrap(spacing: 8, runSpacing: 8, children: trip.featureTags.map((tag) => Chip(label: Text(tag))).toList()),
      const SizedBox(height: 22),
      const SectionTitle('Trip snapshot'),
      Row(children: [Expanded(child: _Metric(icon: Icons.calendar_today_outlined, value: '${trip.days}', label: 'Days')), const SizedBox(width: 10), Expanded(child: _Metric(icon: Icons.place_outlined, value: '${trip.stops}', label: 'Stops')), const SizedBox(width: 10), Expanded(child: _Metric(icon: Icons.payments_outlined, value: '${trip.currency} ${trip.estimatedTotal}', label: 'Estimate'))]),
      const SizedBox(height: 24),
      const SectionTitle('Trip focus'),
      Card(child: ListTile(leading: CircleAvatar(child: Text(trip.status.substring(0, 1))), title: Text(trip.highlight), subtitle: Text('${trip.preferences.companion} · ${trip.preferences.pace} pace · ${trip.preferences.transport.join(' + ')}'), trailing: const Icon(Icons.chevron_right))),
      const SizedBox(height: 14),
      ElevatedButton.icon(onPressed: onOpenItinerary, icon: const Icon(Icons.route), label: const Text('View Day-by-Day Itinerary')),
      const SizedBox(height: 24),
      const SectionTitle('Trip tools'),
      const Wrap(spacing: 8, runSpacing: 8, children: [Chip(avatar: Icon(Icons.wb_sunny_outlined), label: Text('Weather')), Chip(avatar: Icon(Icons.download_outlined), label: Text('Offline')), Chip(avatar: Icon(Icons.payments_outlined), label: Text('Costs')), Chip(avatar: Icon(Icons.near_me_outlined), label: Text('Nearby'))]),
    ],
  );
}

class _Metric extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _Metric({required this.icon, required this.value, required this.label});
  @override
  Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8), child: Column(children: [Icon(icon), const SizedBox(height: 7), Text(value, style: Theme.of(context).textTheme.titleLarge), Text(label, style: Theme.of(context).textTheme.bodySmall)])));
}

class _ItineraryTab extends StatelessWidget {
  final int day;
  final ValueChanged<int> onDayChanged;
  final RoamliStore store;
  const _ItineraryTab({required this.day, required this.onDayChanged, required this.store});

  @override
  Widget build(BuildContext context) {
    final current = store.itinerary[day];
    return Column(children: [
      Padding(padding: const EdgeInsets.fromLTRB(20, 14, 20, 4), child: SizedBox(height: 54, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: store.itinerary.length, separatorBuilder: (_, __) => const SizedBox(width: 8), itemBuilder: (context, i) => ChoiceChip(label: Text('Day ${i + 1}'), selected: i == day, onSelected: (_) => onDayChanged(i))))),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), child: Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(current.title, style: Theme.of(context).textTheme.headlineSmall), Text('${current.stops.length} stops · starts from your stay', style: Theme.of(context).textTheme.bodySmall)])), TextButton.icon(onPressed: () => _addPlace(context), icon: const Icon(Icons.add), label: const Text('Add'))])),
      Expanded(
        child: ReorderableListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
          itemCount: current.stops.length,
          onReorder: (oldIndex, newIndex) {
            if (newIndex > oldIndex) newIndex--;
            final next = List<ItineraryStop>.of(current.stops);
            final item = next.removeAt(oldIndex);
            next.insert(newIndex, item);
            store.updateItineraryDay(day, next);
          },
          itemBuilder: (context, i) {
            final stop = current.stops[i];
            return Padding(
              key: ValueKey(stop.id),
              padding: const EdgeInsets.only(bottom: 10),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Column(children: [CircleAvatar(radius: 18, backgroundColor: RoamliColors.coral, foregroundColor: Colors.white, child: Text('${i + 1}')), if (i < current.stops.length - 1) Container(width: 2, height: 52, color: Theme.of(context).dividerColor)]),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(stop.time, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: RoamliColors.coral)), const SizedBox(height: 3), Text(stop.place.name, style: Theme.of(context).textTheme.titleMedium), Text(stop.note, style: Theme.of(context).textTheme.bodySmall), if (stop.travelMinutesFromPrevious > 0) Padding(padding: const EdgeInsets.only(top: 8), child: Text('${stop.travelMinutesFromPrevious} min from previous stop', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)))])),
                    PopupMenuButton<String>(onSelected: (value) { if (value == 'remove') store.removeStop(day, stop.id); }, itemBuilder: (_) => const [PopupMenuItem(value: 'details', child: Text('View details')), PopupMenuItem(value: 'replace', child: Text('Replace')), PopupMenuItem(value: 'remove', child: Text('Remove'))]),
                  ]),
                ),
              ),
            );
          },
        ),
      ),
    ]);
  }

  void _addPlace(BuildContext context) {
    showModalBottomSheet(context: context, showDragHandle: true, builder: (_) => SafeArea(child: ListView(shrinkWrap: true, padding: const EdgeInsets.fromLTRB(20, 0, 20, 20), children: [Text('Add to Day ${day + 1}', style: Theme.of(context).textTheme.headlineSmall), const SizedBox(height: 14), ...MockData.explore.take(5).map((p) => ListTile(leading: const Icon(Icons.add_circle_outline), title: Text(p.name), subtitle: Text(p.category), onTap: () { store.addStop(day, p); Navigator.pop(context); }))])));
  }
}

class _MapTab extends StatelessWidget {
  final RoamliStore store;
  const _MapTab({required this.store});
  @override
  Widget build(BuildContext context) {
    final trip = store.activeTrip;
    final places = [if (trip.stay != null) trip.stay!, ...store.itinerary.expand((d) => d.stops.map((s) => s.place))];
    return ListView(padding: const EdgeInsets.all(20), children: [const SectionTitle('Trip route'), MockMap(places: places, showRoute: true), const SizedBox(height: 14), Card(child: ListTile(leading: const Icon(Icons.hotel_outlined), title: const Text('Route anchor'), subtitle: Text(trip.stay == null ? 'No stay yet · routes use destination areas until you add one' : '${trip.stay!.name} · start and end point'), trailing: Icon(trip.stay == null ? Icons.info_outline : Icons.check_circle, color: trip.stay == null ? RoamliColors.coral : RoamliColors.explorerGreen))), const SizedBox(height: 10), const Card(child: ListTile(leading: Icon(Icons.route), title: Text('Route optimization'), subtitle: Text('Mock travel times are active. Real Routes API plugs in here later.')))]);
  }
}

class _CostsTab extends StatelessWidget {
  final RoamliStore store;
  const _CostsTab({required this.store});
  @override
  Widget build(BuildContext context) {
    final activity = store.itinerary.expand((d) => d.stops).fold<int>(0, (sum, s) => sum + s.place.estimatedCost);
    final trip = store.activeTrip;
    final stay = trip.stayCost;
    final total = activity + stay + trip.transportCost;
    return ListView(padding: const EdgeInsets.all(20), children: [
      Text('Estimated trip cost', style: Theme.of(context).textTheme.headlineSmall),
      const SizedBox(height: 6),
      Text('${trip.currency} $total', style: Theme.of(context).textTheme.displayLarge),
      const SizedBox(height: 18),
      _CostRow(label: 'Stay', value: stay),
      _CostRow(label: 'Food & experiences', value: activity),
      _CostRow(label: 'Local transport', value: trip.transportCost),
      const SizedBox(height: 12),
      Text('Estimates are planning guidance, not booking totals.', style: Theme.of(context).textTheme.bodySmall),
    ]);
  }
}

class _CostRow extends StatelessWidget {
  final String label;
  final int value;
  const _CostRow({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Card(margin: const EdgeInsets.only(bottom: 10), child: ListTile(title: Text(label), trailing: Text('AED $value', style: Theme.of(context).textTheme.titleMedium)));
}
