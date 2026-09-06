import 'package:flutter/material.dart';
import '../../core/store/roamli_store.dart';
import '../../core/theme/roamli_colors.dart';
import '../auth/auth_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();
  int page = 0;
  final data = const [
    (Icons.travel_explore, 'Discover your kind of trip.', 'Find places, food and experiences that match the way you like to travel.'),
    (Icons.tune, 'Plan around you.', 'Your preferences shape every trip, while each journey can still be adjusted independently.'),
    (Icons.route, 'Your trip. Your way.', 'From the first idea to the final day, keep everything organized in one beautiful place.'),
  ];

  Future<void> finish() async {
    await RoamliScope.of(context).completeOnboarding();
    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AuthHubScreen()));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Column(
        children: [
          Align(alignment: Alignment.centerRight, child: TextButton(onPressed: finish, child: const Text('Skip'))),
          Expanded(
            child: PageView.builder(
              controller: controller,
              itemCount: data.length,
              onPageChanged: (value) => setState(() => page = value),
              itemBuilder: (context, index) {
                final item = data[index];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(26, 20, 26, 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 285,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(36),
                          gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF1B3754), Color(0xFF62AEB7), Color(0xFFFFA36E)]),
                        ),
                        child: Center(child: Icon(item.$1, size: 120, color: Colors.white)),
                      ),
                      const SizedBox(height: 38),
                      Text(item.$2, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineLarge),
                      const SizedBox(height: 14),
                      Text(item.$3, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                    ],
                  ),
                );
              },
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(3, (i) => AnimatedContainer(duration: const Duration(milliseconds: 220), width: i == page ? 28 : 8, height: 8, margin: const EdgeInsets.all(4), decoration: BoxDecoration(color: i == page ? RoamliColors.coral : Colors.grey.shade400, borderRadius: BorderRadius.circular(8))))),
          Padding(
            padding: const EdgeInsets.all(22),
            child: ElevatedButton(
              onPressed: page == 2 ? finish : () => controller.nextPage(duration: const Duration(milliseconds: 280), curve: Curves.easeOut),
              child: Text(page == 2 ? 'Let’s Get Started' : 'Continue'),
            ),
          ),
        ],
      ),
    ),
  );
}
