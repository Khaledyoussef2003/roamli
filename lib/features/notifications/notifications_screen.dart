import 'package:flutter/material.dart';
import '../../core/store/roamli_store.dart';
import '../../core/theme/roamli_colors.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = RoamliScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications'), actions: [IconButton(onPressed: () => _settings(context), icon: const Icon(Icons.tune))]),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Text('Trip updates', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 6),
          Text('Useful reminders and changes without noisy technical messages.', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 18),
          ...store.notifications.map((n) => Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: CircleAvatar(backgroundColor: RoamliColors.coral.withValues(alpha: .12), child: Icon(n.icon, color: RoamliColors.coral)),
              title: Text(n.title),
              subtitle: Padding(padding: const EdgeInsets.only(top: 4), child: Text(n.body)),
              trailing: n.unread ? const CircleAvatar(radius: 4, backgroundColor: RoamliColors.coral) : null,
              isThreeLine: true,
            ),
          )),
          const SizedBox(height: 16),
          Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Weather alert example', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Container(height: 120, decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), gradient: const LinearGradient(colors: [Color(0xFF476E88), Color(0xFF9BC2CB)])), child: const Center(child: Icon(Icons.cloud_outlined, size: 56, color: Colors.white))),
            const SizedBox(height: 12),
            const Text('Possible rain tomorrow · 22°C'),
            const SizedBox(height: 8),
            Wrap(spacing: 8, children: [ActionChip(label: const Text('Indoor ideas'), onPressed: () {}), ActionChip(label: const Text('Check itinerary'), onPressed: () {})]),
          ]))),
        ],
      ),
    );
  }

  void _settings(BuildContext context) {
    final store = RoamliScope.of(context);
    showModalBottomSheet(context: context, showDragHandle: true, builder: (_) => SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(20, 4, 20, 24), child: Column(mainAxisSize: MainAxisSize.min, children: [
      Text('Notification Settings', style: Theme.of(context).textTheme.headlineSmall),
      SwitchListTile.adaptive(value: store.notificationsEnabled, onChanged: store.setNotifications, title: const Text('Notifications'), subtitle: const Text('Trip reminders, place reminders, weather and useful updates.')),
      SwitchListTile.adaptive(value: store.quietHours, onChanged: store.setQuietHours, title: const Text('Quiet hours'), subtitle: const Text('Silence non-essential notifications overnight.')),
      const ListTile(leading: Icon(Icons.volume_up_outlined), title: Text('Sound'), trailing: Text('Default')),
      const ListTile(leading: Icon(Icons.language), title: Text('Language'), trailing: Text('English')),
    ]))));
  }
}
