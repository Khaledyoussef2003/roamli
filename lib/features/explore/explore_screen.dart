import 'package:flutter/material.dart';
import '../../core/mock/mock_data.dart';
import '../../core/models/models.dart';
import '../../core/services/services.dart';
import '../../core/store/roamli_store.dart';
import '../../core/widgets/common.dart';

class ExploreScreen extends StatefulWidget {
  final bool standalone;
  final String initialCategory;
  const ExploreScreen({super.key, this.standalone = false, this.initialCategory = 'Places'});
  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final search = TextEditingController();
  late String category = widget.initialCategory;
  bool map = false;
  bool openNow = false;
  String price = 'Any';
  List<PlaceRef> results = MockData.explore;
  final PlacesService service = const MockPlacesService(MockData.explore);

  final categories = const ['Places', 'Restaurants', 'Experiences', 'Hidden Gems', 'Nearby'];

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  Future<void> runSearch(String value) async {
    final found = await service.autocomplete(value);
    if (!mounted) return;
    setState(() => results = _filter(found));
  }

  List<PlaceRef> _filter(List<PlaceRef> input) => input.where((p) {
    final catOk = switch (category) {
      'Restaurants' => p.category == 'Restaurant',
      'Experiences' => p.category == 'Experience',
      'Hidden Gems' => p.category == 'Hidden Gem',
      'Places' => p.category != 'Stay',
      _ => true,
    };
    final openOk = !openNow || p.openNow;
    final priceOk = price == 'Any' || p.priceLevel.length <= price.length;
    return catOk && openOk && priceOk;
  }).toList();

  void refreshFilter() => setState(() => results = _filter(MockData.explore.where((p) => search.text.isEmpty || p.name.toLowerCase().contains(search.text.toLowerCase())).toList()));

  @override
  Widget build(BuildContext context) {
    final body = SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [Expanded(child: Text('Explore', style: Theme.of(context).textTheme.headlineLarge)), SegmentedButton<bool>(showSelectedIcon: false, segments: const [ButtonSegment(value: false, icon: Icon(Icons.view_list_outlined)), ButtonSegment(value: true, icon: Icon(Icons.map_outlined))], selected: {map}, onSelectionChanged: (s) => setState(() => map = s.first))]),
              const SizedBox(height: 14),
              TextField(controller: search, onChanged: runSearch, decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search places, restaurants, experiences…', suffixIcon: Icon(Icons.tune))),
              const SizedBox(height: 12),
              SizedBox(height: 40, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: categories.length, separatorBuilder: (_, __) => const SizedBox(width: 7), itemBuilder: (context, i) => ChoiceChip(label: Text(categories[i]), selected: category == categories[i], onSelected: (_) { setState(() => category = categories[i]); refreshFilter(); }))),
              const SizedBox(height: 10),
              Row(children: [FilterChip(label: const Text('Open now'), selected: openNow, onSelected: (v) { setState(() => openNow = v); refreshFilter(); }), const SizedBox(width: 8), PopupMenuButton<String>(onSelected: (v) { price = v; refreshFilter(); }, itemBuilder: (_) => ['Any', r'$', r'$$', r'$$$', r'$$$$'].map((v) => PopupMenuItem(value: v, child: Text(v == 'Any' ? 'Any price' : v))).toList(), child: Chip(label: Text(price == 'Any' ? 'Price' : price)))]),
            ]),
          ),
          Expanded(
            child: map
              ? ListView(padding: const EdgeInsets.fromLTRB(20, 6, 20, 20), children: [MockMap(places: results), const SizedBox(height: 12), ElevatedButton.icon(onPressed: () async { final found = await service.searchArea(center: const GeoPoint(36.46, 25.38)); if (mounted) setState(() => results = _filter(found)); }, icon: const Icon(Icons.refresh), label: const Text('Search this area')), const SizedBox(height: 16), ...results.take(3).map((p) => Padding(padding: const EdgeInsets.only(bottom: 10), child: PlaceCard(place: p, compact: true, onAddToTrip: () => _add(context, p))))])
              : results.isEmpty
                ? const Center(child: Padding(padding: EdgeInsets.all(30), child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.search_off, size: 70), SizedBox(height: 16), Text('No results found'), SizedBox(height: 6), Text('Try another search or adjust your filters.')])) )
                : ListView.separated(padding: const EdgeInsets.fromLTRB(20, 6, 20, 28), itemCount: results.length, separatorBuilder: (_, __) => const SizedBox(height: 10), itemBuilder: (context, i) => PlaceCard(place: results[i], onAddToTrip: () => _add(context, results[i]))),
          ),
        ],
      ),
    );
    if (!widget.standalone) return body;
    return Scaffold(appBar: AppBar(), body: body);
  }

  void _add(BuildContext context, PlaceRef place) {
    final store = RoamliScope.of(context);
    store.addStop(0, place);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${place.name} added to Day 1')));
  }
}
