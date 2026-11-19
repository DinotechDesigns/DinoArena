import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/brand.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/common.dart';
import '../providers/auth_providers.dart';
import '../widgets/auth_scaffold.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  bool _loading = false;

  bool get _valid => _name.text.trim().length >= 2;

  Future<void> _save() async {
    if (!_valid) return;
    setState(() => _loading = true);
    try {
      await ref.read(authControllerProvider.notifier).updateProfile(name: _name.text, email: _email.text);
    } catch (e) {
      if (mounted) showAppSnack(context, e.toString(), icon: Icons.error_outline_rounded);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return AuthScaffold(
      title: 'One last\nthing',
      subtitle: 'Tell us what to call you on your ${Brand.name} passes and team sheets.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Full name', style: t.labelLarge),
          const SizedBox(height: 10),
          TextField(
            controller: _name,
            textCapitalization: TextCapitalization.words,
            autofillHints: const [AutofillHints.name],
            textInputAction: TextInputAction.next,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              hintText: 'e.g. Arjun Mehta',
              prefixIcon: Icon(Icons.person_outline_rounded),
            ),
          ),
          const SizedBox(height: 18),
          Text('Email (optional)', style: t.labelLarge),
          const SizedBox(height: 10),
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            onSubmitted: (_) => _save(),
            decoration: const InputDecoration(hintText: 'For receipts', prefixIcon: Icon(Icons.mail_outline_rounded)),
          ),
          const SizedBox(height: 28),
          AppButton(
            label: 'Enter the arena',
            trailingIcon: Icons.arrow_forward_rounded,
            variant: AppButtonVariant.dark,
            loading: _loading,
            onPressed: _valid ? _save : null,
          ),
        ],
      ),
    );
  }
}
