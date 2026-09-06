import 'package:flutter/material.dart';
import '../../core/store/roamli_store.dart';
import '../../core/theme/roamli_colors.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = RoamliScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('ROAMLI+')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(22, 8, 22, 30),
        children: [
          Container(
            padding: const EdgeInsets.all(26),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(28), gradient: const LinearGradient(colors: [RoamliColors.midnight, Color(0xFF293D5D), RoamliColors.coralSoft])),
            child: Column(children: [const Icon(Icons.workspace_premium, size: 72, color: Colors.white), const SizedBox(height: 12), Text('More freedom. More discovery.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white)), const SizedBox(height: 8), const Text('Premium travel tools for people who want more from every trip.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70))]),
          ),
          const SizedBox(height: 24),
          Text('Free vs ROAMLI+', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          ...const [
            ('Trip planning', 'Useful', 'More / unlimited'),
            ('Explore', 'Core discovery', 'Deeper discovery'),
            ('Filters', 'Basic', 'Advanced'),
            ('Itinerary optimization', 'Standard', 'Enhanced'),
            ('Offline access', 'Limited', 'Included'),
            ('Saved collections', 'Useful limits', 'Expanded / unlimited'),
          ].map((row) => Card(margin: const EdgeInsets.only(bottom: 8), child: Padding(padding: const EdgeInsets.all(14), child: Row(children: [Expanded(flex: 2, child: Text(row.$1)), Expanded(child: Text(row.$2, textAlign: TextAlign.center)), Expanded(child: Text(row.$3, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700)))])))),
          const SizedBox(height: 20),
          Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(children: [Text('Yearly', style: Theme.of(context).textTheme.headlineSmall), const SizedBox(height: 6), const Text('Placeholder pricing — set after operating and API costs are modeled.'), const SizedBox(height: 14), ElevatedButton(onPressed: () { store.setPlus(true); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ROAMLI+ activated in mock mode.'))); }, child: Text(store.plusMember ? 'ROAMLI+ Active' : 'Get ROAMLI+'))]))),
          TextButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Restore purchases will connect to App Store / Play billing later.'))), child: const Text('Restore Purchases')),
        ],
      ),
    );
  }
}
