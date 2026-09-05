import 'package:flutter/material.dart';
import '../models/models.dart';
import '../store/roamli_store.dart';
import '../theme/roamli_colors.dart';
import '../../features/place/place_detail_screen.dart';

class ScreenPadding extends StatelessWidget {
  final Widget child;
  const ScreenPadding({super.key, required this.child});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.fromLTRB(20, 16, 20, 24), child: child);
}

class SectionTitle extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  const SectionTitle(this.title, {super.key, this.action, this.onAction});
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(child: Text(title, style: Theme.of(context).textTheme.headlineSmall)),
      if (action != null) TextButton(onPressed: onAction, child: Text(action!)),
    ],
  );
}

class ChoiceChipWrap extends StatelessWidget {
  final List<String> options;
  final Set<String> selected;
  final ValueChanged<String> onTap;
  final bool single;
  const ChoiceChipWrap({super.key, required this.options, required this.selected, required this.onTap, this.single = false});

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 9,
    runSpacing: 9,
    children: options.map((option) {
      final active = selected.contains(option);
      return FilterChip(
        selected: active,
        showCheckmark: active,
        label: Text(option),
        onSelected: (_) => onTap(option),
        selectedColor: RoamliColors.coral.withValues(alpha: .14),
      );
    }).toList(),
  );
}

class TravelHero extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String subtitle;
  final IconData icon;
  final double height;
  const TravelHero({super.key, required this.eyebrow, required this.title, required this.subtitle, required this.icon, this.height = 190});

  @override
  Widget build(BuildContext context) => Container(
    height: height,
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(26),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [RoamliColors.midnight, Color(0xFF25455F), RoamliColors.coralSoft],
      ),
    ),
    child: Stack(
      children: [
        Positioned(right: -12, bottom: -16, child: Icon(icon, size: 130, color: Colors.white.withValues(alpha: .12))),
        Align(
          alignment: Alignment.bottomLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(eyebrow.toUpperCase(), style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w700, letterSpacing: 1.2, fontSize: 12)),
              const SizedBox(height: 7),
              Text(title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white)),
              const SizedBox(height: 5),
              Text(subtitle, style: const TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      ],
    ),
  );
}

class PlaceCard extends StatelessWidget {
  final PlaceRef place;
  final bool compact;
  final VoidCallback? onAddToTrip;
  const PlaceCard({super.key, required this.place, this.compact = false, this.onAddToTrip});

  @override
  Widget build(BuildContext context) {
    final store = RoamliScope.of(context);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PlaceDetailScreen(place: place))),
        child: Padding(
          padding: EdgeInsets.all(compact ? 13 : 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: compact ? 64 : 82,
                height: compact ? 64 : 82,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  gradient: const LinearGradient(colors: [Color(0xFFFFC08E), Color(0xFF6DBBC3)]),
                ),
                child: Icon(_iconFor(place.category), color: Colors.white, size: 30),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Expanded(child: Text(place.name, style: Theme.of(context).textTheme.titleMedium)),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: () => store.toggleSaved(place.placeId),
                        icon: Icon(store.isSaved(place.placeId) ? Icons.favorite : Icons.favorite_border, color: store.isSaved(place.placeId) ? RoamliColors.coral : null),
                      ),
                    ]),
                    Text(place.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 6),
                    Wrap(spacing: 8, children: [
                      Text('★ ${place.rating.toStringAsFixed(1)}', style: const TextStyle(fontWeight: FontWeight.w700)),
                      if (place.priceLevel.isNotEmpty) Text(place.priceLevel),
                      Text(place.openNow ? 'Open' : 'Hours vary', style: TextStyle(color: place.openNow ? RoamliColors.explorerGreen : RoamliColors.slate)),
                    ]),
                    if (onAddToTrip != null) ...[
                      const SizedBox(height: 8),
                      TextButton.icon(onPressed: onAddToTrip, icon: const Icon(Icons.add_circle_outline), label: const Text('Add to Trip')),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static IconData _iconFor(String category) => switch (category.toLowerCase()) {
    'restaurant' => Icons.restaurant,
    'stay' => Icons.hotel,
    'beach' => Icons.beach_access,
    'experience' => Icons.sailing,
    'hidden gem' => Icons.auto_awesome,
    _ => Icons.place,
  };
}

class MockMap extends StatelessWidget {
  final List<PlaceRef> places;
  final bool showRoute;
  const MockMap({super.key, required this.places, this.showRoute = false});

  @override
  Widget build(BuildContext context) => Container(
    height: 330,
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), color: const Color(0xFFDDE8DF)),
    child: Stack(
      children: [
        Positioned.fill(child: CustomPaint(painter: _MapPainter(showRoute: showRoute))),
        ...List.generate(places.length.clamp(0, 5), (i) {
          const positions = [Alignment(-.65, -.45), Alignment(.45, -.35), Alignment(-.15, .15), Alignment(.65, .45), Alignment(-.6, .65)];
          return Align(
            alignment: positions[i],
            child: Tooltip(
              message: places[i].name,
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(color: RoamliColors.coral, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Text('${i + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          );
        }),
        Positioned(left: 12, top: 12, child: DecoratedBox(decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(12)), child: const Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7), child: Text('Mock map · API ready')))),
      ],
    ),
  );
}

class _MapPainter extends CustomPainter {
  final bool showRoute;
  const _MapPainter({required this.showRoute});
  @override
  void paint(Canvas canvas, Size size) {
    final road = Paint()..color = Colors.white.withValues(alpha: .85)..strokeWidth = 15..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final minor = Paint()..color = Colors.white.withValues(alpha: .6)..strokeWidth = 7..style = PaintingStyle.stroke;
    canvas.drawPath(Path()..moveTo(0, size.height * .65)..cubicTo(size.width*.22,size.height*.35,size.width*.55,size.height*.9,size.width,size.height*.34), road);
    canvas.drawLine(Offset(size.width*.18,0), Offset(size.width*.35,size.height), minor);
    canvas.drawLine(Offset(size.width*.78,0), Offset(size.width*.58,size.height), minor);
    if (showRoute) {
      final route = Paint()..color = RoamliColors.coral..strokeWidth = 5..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
      canvas.drawPath(Path()..moveTo(size.width*.18,size.height*.68)..cubicTo(size.width*.32,size.height*.2,size.width*.68,size.height*.75,size.width*.82,size.height*.35), route);
    }
  }
  @override
  bool shouldRepaint(covariant _MapPainter oldDelegate) => oldDelegate.showRoute != showRoute;
}
