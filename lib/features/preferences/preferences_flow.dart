import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/store/roamli_store.dart';
import '../../core/widgets/app_shell.dart';
import '../../core/widgets/common.dart';

class PreferencesFlow extends StatefulWidget {
  final bool editMode;
  const PreferencesFlow({super.key, this.editMode = false});
  @override
  State<PreferencesFlow> createState() => _PreferencesFlowState();
}

class _PreferencesFlowState extends State<PreferencesFlow> {
  final controller = PageController();
  int page = 0;
  late TravelPreferences prefs;
  bool initialized = false;

  static const styles = ['Relaxed', 'Balanced', 'Packed', 'Adventure', 'Luxury', 'Local & Authentic'];
  static const interests = ['Food & Drinks', 'Nature', 'Beaches', 'Culture & History', 'Shopping', 'Nightlife', 'Adventure', 'Wellness', 'Family', 'Photography', 'Entertainment', 'Hidden Gems'];
  static const foods = ['Local Cuisine', 'Fine Dining', 'Street Food', 'Cafés', 'Healthy', 'Vegetarian / Vegan', 'Halal', 'Dietary needs / allergies'];
  static const budgets = ['Budget', 'Moderate', 'Premium', 'Luxury'];
  static const companions = ['Solo', 'Couple', 'Friends', 'Family', 'Business'];
  static const pace = ['Slow', 'Balanced', 'Fast'];
  static const transport = ['Walking', 'Public Transport', 'Taxi / Ride-hailing', 'Rental Car', 'Cycling', 'Choose best for me'];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized) {
      prefs = RoamliScope.of(context).preferences;
      initialized = true;
    }
  }

  void toggleSet(String value, Set<String> current, ValueChanged<Set<String>> update, {bool single = false}) {
    final next = Set<String>.of(current);
    if (single) {
      next
        ..clear()
        ..add(value);
    } else if (!next.add(value)) {
      next.remove(value);
    }
    setState(() => update(next));
  }

  Future<void> finish() async {
    await RoamliScope.of(context).savePreferences(prefs);
    if (!mounted) return;
    if (widget.editMode) {
      Navigator.pop(context);
    } else {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const AppShell()), (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.editMode ? 'Travel Preferences' : 'Make ROAMLI yours'),
      leading: widget.editMode ? const BackButton() : null,
      actions: [TextButton(onPressed: finish, child: const Text('Save'))],
    ),
    body: SafeArea(
      child: Column(
        children: [
          Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: LinearProgressIndicator(value: (page + 1) / 7)),
          Expanded(
            child: PageView(
              controller: controller,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (value) => setState(() => page = value),
              children: [
                _PreferencePage(title: 'How do you like to travel?', subtitle: 'Choose the style that feels most like you.', child: ChoiceChipWrap(options: styles, selected: prefs.styles, single: true, onTap: (v) => toggleSet(v, prefs.styles, (s) => prefs = prefs.copyWith(styles: s), single: true))),
                _PreferencePage(title: 'What are you into?', subtitle: 'Pick as many interests as you like.', child: ChoiceChipWrap(options: interests, selected: prefs.interests, onTap: (v) => toggleSet(v, prefs.interests, (s) => prefs = prefs.copyWith(interests: s)))),
                _PreferencePage(title: 'Food preferences', subtitle: 'Help us surface places you’ll actually enjoy.', child: ChoiceChipWrap(options: foods, selected: prefs.food, onTap: (v) => toggleSet(v, prefs.food, (s) => prefs = prefs.copyWith(food: s)))),
                _PreferencePage(title: 'Typical budget', subtitle: 'This becomes your default and can be changed per trip.', child: ChoiceChipWrap(options: budgets, selected: {prefs.budget}, single: true, onTap: (v) => setState(() => prefs = prefs.copyWith(budget: v)))),
                _PreferencePage(title: 'Who do you usually travel with?', subtitle: 'We’ll use this as a starting point.', child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ChoiceChipWrap(options: companions, selected: {prefs.companion}, single: true, onTap: (v) => setState(() => prefs = prefs.copyWith(companion: v))), const SizedBox(height: 28), Text('Your pace', style: Theme.of(context).textTheme.titleLarge), const SizedBox(height: 12), ChoiceChipWrap(options: pace, selected: {prefs.pace}, single: true, onTap: (v) => setState(() => prefs = prefs.copyWith(pace: v)))])),
                _PreferencePage(title: 'Getting around', subtitle: 'Choose your preferred ways to move.', child: ChoiceChipWrap(options: transport, selected: prefs.transport, onTap: (v) => toggleSet(v, prefs.transport, (s) => prefs = prefs.copyWith(transport: s)))),
                _PreferencePage(title: 'You’re all set.', subtitle: 'These preferences will shape future trips. You can change them any time from Profile.', child: const TravelHero(eyebrow: 'ROAMLI', title: 'Ready for your next trip?', subtitle: 'Your defaults are saved to your profile.', icon: Icons.check_circle_outline, height: 240)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                if (page > 0) Expanded(child: OutlinedButton(onPressed: () => controller.previousPage(duration: const Duration(milliseconds: 220), curve: Curves.easeOut), child: const Text('Back'))),
                if (page > 0) const SizedBox(width: 12),
                Expanded(child: ElevatedButton(onPressed: page == 6 ? finish : () => controller.nextPage(duration: const Duration(milliseconds: 220), curve: Curves.easeOut), child: Text(page == 6 ? 'Finish' : 'Continue'))),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _PreferencePage extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  const _PreferencePage({required this.title, required this.subtitle, required this.child});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(22, 26, 22, 20),
    children: [
      Text(title, style: Theme.of(context).textTheme.headlineLarge),
      const SizedBox(height: 10),
      Text(subtitle, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
      const SizedBox(height: 28),
      child,
    ],
  );
}
