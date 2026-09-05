import 'package:flutter/material.dart';
import '../../core/store/roamli_store.dart';
import '../../core/theme/roamli_colors.dart';
import '../../core/widgets/app_shell.dart';
import '../../core/widgets/brand.dart';
import '../auth/auth_screen.dart';
import '../onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  final bool storeReady;
  const SplashScreen({super.key, required this.storeReady});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1900))..forward();
  bool navigated = false;

  @override
  void didUpdateWidget(covariant SplashScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _tryNavigate();
  }

  @override
  void initState() {
    super.initState();
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) _tryNavigate();
    });
  }

  void _tryNavigate() {
    if (navigated || !widget.storeReady || !controller.isCompleted || !mounted) return;
    navigated = true;
    final store = RoamliScope.of(context);
    final Widget next = !store.onboardingComplete
      ? const OnboardingScreen()
      : (store.guestMode || store.signedIn ? const AppShell() : const AuthHubScreen());
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => next));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) => Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: _RoadPainter(controller.value, Theme.of(context).brightness == Brightness.dark))),
            Center(
              child: FadeTransition(
                opacity: CurvedAnimation(parent: controller, curve: const Interval(.35, 1)),
                child: const RoamliWordmark(),
              ),
            ),
            Positioned(
              left: 48,
              right: 48,
              bottom: 52,
              child: LinearProgressIndicator(value: controller.value, minHeight: 4, borderRadius: BorderRadius.circular(8), color: RoamliColors.coral),
            ),
          ],
        ),
      ),
    ),
  );
}

class _RoadPainter extends CustomPainter {
  final double t;
  final bool dark;
  const _RoadPainter(this.t, this.dark);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (dark ? Colors.white : RoamliColors.coral).withValues(alpha: .17)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 30
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(size.width * .42, size.height * .88)
      ..cubicTo(size.width * .10, size.height * .68, size.width * .88, size.height * .65, size.width * .55, size.height * .47)
      ..cubicTo(size.width * .38, size.height * .38, size.width * .52, size.height * .28, size.width * .64, size.height * .18);
    final metric = path.computeMetrics().first;
    canvas.drawPath(metric.extractPath(0, metric.length * t), paint);
  }
  @override
  bool shouldRepaint(covariant _RoadPainter oldDelegate) => oldDelegate.t != t || oldDelegate.dark != dark;
}
