import 'package:flutter/material.dart';
import '../../core/mock/mock_data.dart';
import '../../core/models/models.dart';
import '../../core/store/roamli_store.dart';
import '../../core/theme/roamli_colors.dart';
import '../../core/widgets/common.dart';
import '../itinerary/itinerary_screen.dart';
import '../itinerary/demo_trips_screen.dart';

class PlannerLanding extends StatelessWidget {
  const PlannerLanding({super.key});
  @override
  Widget build(BuildContext context) => SafeArea(
    child: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Planner', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 8),
        Text('Turn a destination into a trip that fits you.', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 22),
        const TravelHero(eyebrow: 'PLAN YOUR NEXT TRIP', title: 'Where are you going next?', subtitle: 'Destination, stay, preferences, budget — then ROAMLI brings it together.', icon: Icons.route, height: 230),
        const SizedBox(height: 20),
        ElevatedButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PlanTripFlow())), icon: const Icon(Icons.add), label: const Text('Plan a New Trip')),
        const SizedBox(height: 28),
        SectionTitle('Your Trips', action: 'View all', onAction: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DemoTripsScreen()))),
        Card(child: ListTile(leading: const CircleAvatar(child: Icon(Icons.location_city)), title: const Text('Dubai Luxe Weekend'), subtitle: const Text('Planned · exact stay · premium couple trip'), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DemoTripsScreen())))),
        Card(child: ListTile(leading: const CircleAvatar(child: Icon(Icons.flight_takeoff)), title: const Text('4 more demo trips'), subtitle: const Text('Ibiza · Italy · Prague · Mykonos'), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DemoTripsScreen())))),
      ],
    ),
  );
}

class PlanTripFlow extends StatefulWidget {
  const PlanTripFlow({super.key});
  @override
  State<PlanTripFlow> createState() => _PlanTripFlowState();
}

class _PlanTripFlowState extends State<PlanTripFlow> {
  final controller = PageController();
  final destination = TextEditingController(text: 'Santorini, Greece');
  final dailyBudget = TextEditingController();
  int page = 0;
  bool building = false;

  @override
  void dispose() {
    controller.dispose();
    destination.dispose();
    dailyBudget.dispose();
    super.dispose();
  }

  TripDraft get draft => RoamliScope.of(context).tripDraft;

  void next() {
    if (page == 0) draft.destination = destination.text.trim();
    if (page == 5) draft.dailyBudget = int.tryParse(dailyBudget.text);
    if (page == 7) {
      buildTrip();
    } else {
      controller.nextPage(duration: const Duration(milliseconds: 240), curve: Curves.easeOut);
    }
  }

  Future<void> buildTrip() async {
    setState(() => building = true);
    await Future<void>.delayed(const Duration(milliseconds: 1100));
    if (!mounted) return;
    setState(() => building = false);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ItineraryScreen()));
  }

  @override
  Widget build(BuildContext context) {
    if (building) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(34),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const SizedBox(width: 84, height: 84, child: CircularProgressIndicator(strokeWidth: 7)),
                const SizedBox(height: 28),
                Text('We’re putting your trip together…', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 12),
                const Text('Organizing places, timing and your daily route.'),
              ]),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Plan a Trip'), actions: [Text('${page + 1}/8', style: Theme.of(context).textTheme.labelLarge), const SizedBox(width: 18)]),
      body: SafeArea(
        child: Column(
          children: [
            Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: LinearProgressIndicator(value: (page + 1) / 8)),
            Expanded(
              child: PageView(
                controller: controller,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (value) => setState(() => page = value),
                children: [
                  _Step(title: 'Where are you going?', subtitle: 'Search for a city, region or destination.', child: TextField(controller: destination, decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'e.g. Santorini, Greece'))),
                  _DatesStep(draft: draft, onChanged: () => setState(() {})),
                  _StayStep(draft: draft, onChanged: () => setState(() {})),
                  _TravelersStep(draft: draft, onChanged: () => setState(() {})),
                  _TripPreferencesStep(draft: draft, onChanged: () => setState(() {})),
                  _Step(title: 'Budget', subtitle: 'Use your profile default or adjust it for this trip.', child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ChoiceChipWrap(options: const ['Budget', 'Moderate', 'Premium', 'Luxury'], selected: {draft.budget}, single: true, onTap: (v) => setState(() => draft.budget = v)), const SizedBox(height: 22), TextField(controller: dailyBudget, keyboardType: TextInputType.number, decoration: const InputDecoration(prefixIcon: Icon(Icons.payments_outlined), labelText: 'Approximate daily budget (optional)', suffixText: 'AED'))])),
                  _ReviewStep(draft: draft),
                  const _Step(title: 'Ready to build your trip?', subtitle: 'Review complete. You can still edit everything afterward.', child: TravelHero(eyebrow: 'ROAMLI', title: 'Your trip. Your way.', subtitle: 'We’ll create a day-by-day starting point around your choices.', icon: Icons.auto_awesome, height: 250)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(children: [
                if (page > 0) Expanded(child: OutlinedButton(onPressed: () => controller.previousPage(duration: const Duration(milliseconds: 220), curve: Curves.easeOut), child: const Text('Back'))),
                if (page > 0) const SizedBox(width: 12),
                Expanded(child: ElevatedButton(onPressed: next, child: Text(page == 7 ? 'Build My Trip' : 'Continue'))),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  const _Step({required this.title, required this.subtitle, required this.child});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.fromLTRB(22, 28, 22, 22), children: [Text(title, style: Theme.of(context).textTheme.headlineLarge), const SizedBox(height: 9), Text(subtitle, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)), const SizedBox(height: 28), child]);
}

class _DatesStep extends StatelessWidget {
  final TripDraft draft;
  final VoidCallback onChanged;
  const _DatesStep({required this.draft, required this.onChanged});
  @override
  Widget build(BuildContext context) => _Step(
    title: 'When are you going?',
    subtitle: 'Choose dates or keep things flexible.',
    child: Column(children: [
      Card(child: ListTile(leading: const Icon(Icons.calendar_month_outlined), title: Text(draft.start == null ? 'Choose trip dates' : '${_date(draft.start!)} – ${_date(draft.end!)}'), subtitle: const Text('Flexible dates are okay too'), trailing: const Icon(Icons.chevron_right), onTap: () async { final result = await showDateRangePicker(context: context, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 730))); if (result != null) { draft.start = result.start; draft.end = result.end; onChanged(); } })),
      const SizedBox(height: 14),
      OutlinedButton(onPressed: () { draft.start = null; draft.end = null; onChanged(); }, child: const Text('My dates are flexible')),
    ]),
  );
  static String _date(DateTime d) => '${d.day}/${d.month}/${d.year}';
}

class _StayStep extends StatelessWidget {
  final TripDraft draft;
  final VoidCallback onChanged;
  const _StayStep({required this.draft, required this.onChanged});

  @override
  Widget build(BuildContext context) => _Step(
    title: 'Your Stay',
    subtitle: 'Add your exact property or address so daily routes can start from the right place.',
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (draft.stay != null) ...[
        PlaceCard(place: draft.stay!, compact: true),
        const SizedBox(height: 12),
        SwitchListTile.adaptive(value: draft.useStayAsAnchor, onChanged: (v) { draft.useStayAsAnchor = v; onChanged(); }, title: const Text('Use as my daily starting point'), subtitle: const Text('Routes can start and end at your stay.')),
        const SizedBox(height: 12),
      ],
      _StayOption(icon: Icons.hotel_outlined, title: 'Search hotel or accommodation', subtitle: 'Choose the exact property and branch', onTap: () { draft.stay = MockData.canaves; onChanged(); }),
      _StayOption(icon: Icons.location_on_outlined, title: 'Enter address', subtitle: 'For apartments, Airbnb or private stays', onTap: () { draft.stay = const PlaceRef(placeId: 'manual_stay', name: 'Private Stay', category: 'Stay', subtitle: 'Oia, Santorini · Manual address', location: GeoPoint(36.46, 25.38), description: 'Manual accommodation address'); onChanged(); }),
      _StayOption(icon: Icons.schedule, title: 'I haven’t booked yet', subtitle: 'Skip for now and add it later', onTap: () { draft.stay = null; onChanged(); }),
      _StayOption(icon: Icons.recommend_outlined, title: 'Help me choose', subtitle: 'Show accommodation ideas later', onTap: () { draft.stay = null; ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ROAMLI will include stay suggestions in your trip.'))); }),
      if (draft.stay == null) Padding(padding: const EdgeInsets.only(top: 12), child: Text('You can still build your trip. Add your stay later to improve daily routes.', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: RoamliColors.slate))),
    ]),
  );
}

class _StayOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _StayOption({required this.icon, required this.title, required this.subtitle, required this.onTap});
  @override
  Widget build(BuildContext context) => Card(margin: const EdgeInsets.only(bottom: 10), child: ListTile(leading: Icon(icon), title: Text(title), subtitle: Text(subtitle), trailing: const Icon(Icons.chevron_right), onTap: onTap));
}

class _TravelersStep extends StatelessWidget {
  final TripDraft draft;
  final VoidCallback onChanged;
  const _TravelersStep({required this.draft, required this.onChanged});
  @override
  Widget build(BuildContext context) => _Step(title: 'Who’s traveling?', subtitle: 'Tell us who the trip is for.', child: Column(children: [
    _Counter(label: 'Adults', detail: 'Age 13+', value: draft.adults, onChanged: (v) { draft.adults = v; onChanged(); }),
    const Divider(),
    _Counter(label: 'Children', detail: 'Age 0–12', value: draft.children, onChanged: (v) { draft.children = v; onChanged(); }),
  ]));
}

class _Counter extends StatelessWidget {
  final String label;
  final String detail;
  final int value;
  final ValueChanged<int> onChanged;
  const _Counter({required this.label, required this.detail, required this.value, required this.onChanged});
  @override
  Widget build(BuildContext context) => ListTile(title: Text(label), subtitle: Text(detail), trailing: Row(mainAxisSize: MainAxisSize.min, children: [IconButton(onPressed: value > 0 ? () => onChanged(value - 1) : null, icon: const Icon(Icons.remove_circle_outline)), Text('$value', style: Theme.of(context).textTheme.titleMedium), IconButton(onPressed: () => onChanged(value + 1), icon: const Icon(Icons.add_circle_outline))]));
}

class _TripPreferencesStep extends StatelessWidget {
  final TripDraft draft;
  final VoidCallback onChanged;
  const _TripPreferencesStep({required this.draft, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    final profile = RoamliScope.of(context).preferences;
    final current = draft.overrides ?? profile;
    return _Step(title: 'Trip Preferences', subtitle: 'Your profile preferences are already applied. Adjusting them here affects only this trip.', child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Using your profile defaults'), const SizedBox(height: 8), Text('${current.styles.join(', ')} · ${current.budget} · ${current.pace} pace'), const SizedBox(height: 6), Text(current.interests.take(4).join(' · '), style: Theme.of(context).textTheme.bodySmall)]))),
      const SizedBox(height: 14),
      OutlinedButton.icon(onPressed: () { draft.overrides = current.copyWith(styles: {'Relaxed'}, pace: 'Slow'); onChanged(); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Trip-only preferences adjusted. Profile defaults were not changed.'))); }, icon: const Icon(Icons.tune), label: const Text('Adjust for this trip')),
      if (draft.overrides != null) TextButton(onPressed: () { draft.overrides = null; onChanged(); }, child: const Text('Use profile defaults instead')),
    ]));
  }
}

class _ReviewStep extends StatelessWidget {
  final TripDraft draft;
  const _ReviewStep({required this.draft});
  @override
  Widget build(BuildContext context) => _Step(title: 'Review your trip', subtitle: 'Make sure the basics look right before we build it.', child: Column(children: [
    _ReviewRow(icon: Icons.place_outlined, label: 'Destination', value: draft.destination.isEmpty ? 'Santorini, Greece' : draft.destination),
    _ReviewRow(icon: Icons.calendar_month_outlined, label: 'Dates', value: draft.start == null ? 'Flexible' : '${draft.start!.day}/${draft.start!.month} – ${draft.end!.day}/${draft.end!.month}'),
    _ReviewRow(icon: Icons.hotel_outlined, label: 'Stay', value: draft.stay?.name ?? 'Not added yet'),
    _ReviewRow(icon: Icons.group_outlined, label: 'Travelers', value: '${draft.adults} adults${draft.children > 0 ? ', ${draft.children} children' : ''}'),
    _ReviewRow(icon: Icons.payments_outlined, label: 'Budget', value: '${draft.budget}${draft.dailyBudget != null ? ' · ${draft.dailyBudget} AED/day' : ''}'),
  ]));
}

class _ReviewRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _ReviewRow({required this.icon, required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Card(margin: const EdgeInsets.only(bottom: 10), child: ListTile(leading: Icon(icon), title: Text(label), subtitle: Text(value), trailing: const Icon(Icons.check_circle, color: RoamliColors.explorerGreen)));
}
