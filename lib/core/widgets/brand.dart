import 'package:flutter/material.dart';
import '../theme/roamli_colors.dart';

class RoamliMark extends StatelessWidget {
  final double size;
  const RoamliMark({super.key, this.size = 48});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size,
    child: CustomPaint(painter: _MarkPainter()),
  );
}

class RoamliWordmark extends StatelessWidget {
  final bool includeTagline;
  const RoamliWordmark({super.key, this.includeTagline = true});

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const RoamliMark(size: 72),
      const SizedBox(height: 12),
      Text('ROAMLI', style: Theme.of(context).textTheme.headlineLarge?.copyWith(letterSpacing: 4)),
      if (includeTagline) ...[
        const SizedBox(height: 7),
        Text('Your trip. Your way.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
      ],
    ],
  );
}

class _MarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final orange = Paint()..color = RoamliColors.coral..style = PaintingStyle.stroke..strokeWidth = s.width * .12..strokeCap = StrokeCap.round;
    final navy = Paint()..color = RoamliColors.midnight..style = PaintingStyle.stroke..strokeWidth = s.width * .10..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(s.width * .18, s.height * .82)
      ..cubicTo(s.width * .12, s.height * .58, s.width * .78, s.height * .66, s.width * .47, s.height * .40)
      ..cubicTo(s.width * .36, s.height * .30, s.width * .52, s.height * .22, s.width * .73, s.height * .17);
    canvas.drawPath(path, orange);
    canvas.drawArc(Rect.fromCircle(center: Offset(s.width * .73, s.height * .17), radius: s.width * .12), 3.6, 2.25, false, navy);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
