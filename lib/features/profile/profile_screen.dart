import 'package:flutter/material.dart';
import '../../core/mock/mock_data.dart';
import '../../core/store/roamli_store.dart';
import '../../core/theme/roamli_colors.dart';
import '../notifications/notifications_screen.dart';
import '../itinerary/demo_trips_screen.dart';
import '../preferences/preferences_flow.dart';
import '../subscription/subscription_screen.dart';
import '../system_states/system_states.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = RoamliScope.of(context);
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 34),
        children: [
          Row(children: [
            const CircleAvatar(radius: 34, child: Text('OY', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(MockData.userName, style: Theme.of(context).textTheme.headlineSmall), Text(store.guestMode ? 'Guest traveler' : MockData.username), const SizedBox(height: 3), Text('Balanced explorer · Food & hidden gems', style: Theme.of(context).textTheme.bodySmall)])),
            IconButton(onPressed: () => _editProfile(context), icon: const Icon(Icons.edit_outlined)),
          ]),
          const SizedBox(height: 22),
          Row(children: [Expanded(child: _Stat('${store.demoTrips.length}', 'Trips')), const SizedBox(width: 10), const Expanded(child: _Stat('5', 'Countries')), const SizedBox(width: 10), Expanded(child: _Stat('${store.savedPlaceIds.length}', 'Saved'))]),
          const SizedBox(height: 22),
          Card(child: ListTile(leading: const CircleAvatar(backgroundColor: RoamliColors.coral, foregroundColor: Colors.white, child: Icon(Icons.workspace_premium)), title: Text(store.plusMember ? 'ROAMLI+ Member' : 'Discover ROAMLI+'), subtitle: Text(store.plusMember ? 'Premium trip tools are active.' : 'More planning, deeper discovery and offline access.'), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SubscriptionScreen())))),
          const SizedBox(height: 20),
          _Group(title: 'Travel', children: [
            _Tile(icon: Icons.luggage_outlined, title: 'My Trips', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DemoTripsScreen()))),
            _Tile(icon: Icons.tune, title: 'Travel Preferences', subtitle: '${store.preferences.budget} · ${store.preferences.pace}', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PreferencesFlow(editMode: true)))),
            _Tile(icon: Icons.favorite_border, title: 'Saved Places', onTap: () {}),
          ]),
          const SizedBox(height: 16),
          _Group(title: 'Settings', children: [
            _Tile(icon: Icons.notifications_outlined, title: 'Notifications', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()))),
            _Tile(icon: Icons.dark_mode_outlined, title: 'Appearance', subtitle: store.themeMode.name, onTap: () => _appearance(context)),
            _Tile(icon: Icons.language, title: 'Language', subtitle: store.language, onTap: () {}),
            _Tile(icon: Icons.currency_exchange, title: 'Currency', subtitle: store.currency, onTap: () {}),
            _Tile(icon: Icons.shield_outlined, title: 'Privacy & Data', onTap: () => _privacy(context)),
          ]),
          const SizedBox(height: 16),
          _Group(title: 'Support', children: [
            _Tile(icon: Icons.help_outline, title: 'Help & Support', onTap: () {}),
            _Tile(icon: Icons.info_outline, title: 'About ROAMLI', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SystemStatesGallery()))),
          ]),
          const SizedBox(height: 12),
          ListTile(leading: const Icon(Icons.logout, color: Colors.red), title: const Text('Sign Out', style: TextStyle(color: Colors.red)), onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sign-out wiring will connect to the production auth provider later.')))),
        ],
      ),
    );
  }

  void _editProfile(BuildContext context) => showModalBottomSheet(context: context, showDragHandle: true, builder: (_) => const SafeArea(child: Padding(padding: EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [Text('Edit Profile', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), SizedBox(height: 12), TextField(decoration: InputDecoration(labelText: 'Display name'), controller: null), SizedBox(height: 14), Text('Mock data stays centralized as Omar Youssef until authentication is connected.')]))));

  void _appearance(BuildContext context) {
    final store = RoamliScope.of(context);
    showModalBottomSheet(context: context, showDragHandle: true, builder: (_) => SafeArea(child: Column(mainAxisSize: MainAxisSize.min, children: ThemeMode.values.map((mode) => RadioListTile<ThemeMode>(value: mode, groupValue: store.themeMode, title: Text(mode == ThemeMode.system ? 'System' : mode == ThemeMode.light ? 'Light' : 'Dark'), onChanged: (v) { if (v != null) store.setThemeMode(v); Navigator.pop(context); })).toList())));
  }

  void _privacy(BuildContext context) => showModalBottomSheet(context: context, showDragHandle: true, builder: (_) => SafeArea(child: Wrap(children: [const ListTile(title: Text('Privacy & Data'), subtitle: Text('Control location, saved data and your account.')), ListTile(leading: const Icon(Icons.location_on_outlined), title: const Text('Location'), subtitle: const Text('Used for nearby discovery and better routes. Denying it does not block trip planning.'), onTap: () {}), ListTile(leading: const Icon(Icons.cloud_upload_outlined), title: const Text('Save guest trips to account'), subtitle: const Text('Available when a guest creates an account.'), onTap: () {}), ListTile(leading: const Icon(Icons.delete_outline, color: Colors.red), title: const Text('Delete account', style: TextStyle(color: Colors.red)), subtitle: const Text('Production flow will include confirmation and provider deletion.'), onTap: () {})])));
}

class _Group extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Group({required this.title, required this.children});
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Padding(padding: const EdgeInsets.only(left: 4, bottom: 8), child: Text(title, style: Theme.of(context).textTheme.titleMedium)), Card(child: Column(children: children))]);
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  const _Tile({required this.icon, required this.title, this.subtitle, required this.onTap});
  @override
  Widget build(BuildContext context) => ListTile(leading: Icon(icon), title: Text(title), subtitle: subtitle == null ? null : Text(subtitle!), trailing: const Icon(Icons.chevron_right), onTap: onTap);
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  const _Stat(this.value, this.label);
  @override
  Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.symmetric(vertical: 14), child: Column(children: [Text(value, style: Theme.of(context).textTheme.headlineSmall), Text(label, style: Theme.of(context).textTheme.bodySmall)])));
}
