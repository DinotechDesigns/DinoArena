import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/constants/brand.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/common.dart';
import '../providers/auth_providers.dart';
import '../widgets/auth_scaffold.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phone = TextEditingController();
  bool _loading = false;
  bool _accepted = true;

  bool get _valid => RegExp(r'^[6-9]\d{9}$').hasMatch(_phone.text);

  Future<void> _submit() async {
    if (!_valid || _loading) return;
    FocusScope.of(context).unfocus();
    setState(() => _loading = true);
    try {
      await ref.read(authControllerProvider.notifier).requestOtp('91${_phone.text}');
      if (mounted) context.push(Routes.otp, extra: _phone.text);
    } catch (e) {
      if (mounted) showAppSnack(context, e.toString(), icon: Icons.error_outline_rounded);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return AuthScaffold(
      title: 'Welcome to\n${Brand.name}',
      subtitle: 'Log in with your mobile number to book slots, join events and compete.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Mobile number', style: t.labelLarge),
          const SizedBox(height: 10),
          TextField(
            controller: _phone,
            keyboardType: TextInputType.phone,
            autofillHints: const [AutofillHints.telephoneNumberNational],
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
            style: t.titleMedium?.copyWith(letterSpacing: 1.2),
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              hintText: '98765 43210',
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 16, right: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('🇮🇳  +91', style: t.titleMedium),
                    const SizedBox(width: 10),
                    Container(width: 1, height: 22, color: AppColors.border),
                  ],
                ),
              ),
              suffixIcon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _valid
                    ? const Icon(Icons.check_circle_rounded, color: AppColors.primaryGreen, key: ValueKey('ok'))
                    : const SizedBox.shrink(),
              ),
            ),
          ),
          const SizedBox(height: 14),
          InkWell(
            onTap: () => setState(() => _accepted = !_accepted),
            borderRadius: BorderRadius.circular(8),
            child: Row(
              children: [
                Checkbox(
                  value: _accepted,
                  onChanged: (v) => setState(() => _accepted = v ?? false),
                  activeColor: AppColors.primaryGreen,
                  visualDensity: VisualDensity.compact,
                ),
                Expanded(
                  child: Text(
                    'I agree to the ${Brand.name} Terms of Service and Privacy Policy.',
                    style: t.bodySmall?.copyWith(color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          AppButton(
            label: 'Get OTP',
            trailingIcon: Icons.arrow_forward_rounded,
            loading: _loading,
            onPressed: _valid && _accepted ? _submit : null,
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.limeSoft, borderRadius: BorderRadius.circular(14)),
            child: Row(
              children: [
                const Icon(Icons.bolt_rounded, color: AppColors.primaryGreen),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Demo build — enter any valid Indian mobile number. No SMS is sent.',
                    style: t.bodySmall?.copyWith(color: AppColors.secondaryDark),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
