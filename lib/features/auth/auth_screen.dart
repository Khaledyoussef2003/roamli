import 'package:flutter/material.dart';
import '../../core/store/roamli_store.dart';
import '../../core/widgets/app_shell.dart';
import '../../core/widgets/brand.dart';
import '../preferences/preferences_flow.dart';

class AuthHubScreen extends StatelessWidget {
  const AuthHubScreen({super.key});

  Future<void> _continue(BuildContext context, {required bool guest}) async {
    final store = RoamliScope.of(context);
    if (guest) {
      await store.continueAsGuest();
    } else {
      store.mockSignIn();
    }
    if (!context.mounted) return;
    final next = store.preferencesComplete ? const AppShell() : const PreferencesFlow();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => next));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 34, 24, 28),
        children: [
          const RoamliWordmark(),
          const SizedBox(height: 44),
          Text('Let’s get you started', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 10),
          Text('Save your preferences and trips, or continue as a guest.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          const SizedBox(height: 30),
          _AuthButton(icon: Icons.apple, label: 'Continue with Apple', onTap: () => _continue(context, guest: false)),
          const SizedBox(height: 12),
          _AuthButton(icon: Icons.g_mobiledata, label: 'Continue with Google', onTap: () => _continue(context, guest: false)),
          const SizedBox(height: 12),
          _AuthButton(icon: Icons.mail_outline, label: 'Continue with Email', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EmailAuthScreen(signUp: true)))),
          const SizedBox(height: 16),
          TextButton(onPressed: () => _continue(context, guest: true), child: const Text('Continue as Guest')),
          const SizedBox(height: 6),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text('Already have an account? '),
            TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EmailAuthScreen(signUp: false))), child: const Text('Sign In')),
          ]),
          const SizedBox(height: 18),
          Text('By continuing, you agree to ROAMLI’s Terms and Privacy Policy.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    ),
  );
}

class _AuthButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _AuthButton({required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) => OutlinedButton.icon(onPressed: onTap, icon: Icon(icon), label: Text(label));
}

class EmailAuthScreen extends StatefulWidget {
  final bool signUp;
  const EmailAuthScreen({super.key, required this.signUp});
  @override
  State<EmailAuthScreen> createState() => _EmailAuthScreenState();
}

class _EmailAuthScreenState extends State<EmailAuthScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool hidden = true;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void submit() {
    RoamliScope.of(context).mockSignIn();
    final store = RoamliScope.of(context);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => store.preferencesComplete ? const AppShell() : const PreferencesFlow()), (_) => false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.signUp ? 'Create Account' : 'Sign In')),
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(widget.signUp ? 'Create your ROAMLI account' : 'Welcome back', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 12),
        Text(widget.signUp ? 'Keep trips, preferences and saved places together.' : 'Sign in to continue your trips.', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 28),
        TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.mail_outline))),
        const SizedBox(height: 14),
        TextField(controller: password, obscureText: hidden, decoration: InputDecoration(labelText: 'Password', prefixIcon: const Icon(Icons.lock_outline), suffixIcon: IconButton(onPressed: () => setState(() => hidden = !hidden), icon: Icon(hidden ? Icons.visibility_outlined : Icons.visibility_off_outlined)))),
        const SizedBox(height: 22),
        ElevatedButton(onPressed: submit, child: Text(widget.signUp ? 'Create Account' : 'Sign In')),
        if (!widget.signUp) TextButton(onPressed: () {}, child: const Text('Forgot password?')),
        const SizedBox(height: 12),
        Text('Authentication is running in local mock mode until the production provider is connected.', style: Theme.of(context).textTheme.bodySmall),
      ],
    ),
  );
}
