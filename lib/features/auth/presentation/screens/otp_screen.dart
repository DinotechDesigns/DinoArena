import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/common.dart';
import '../providers/auth_providers.dart';
import '../widgets/auth_scaffold.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key, required this.phone});

  final String phone;

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  static const _length = 4;
  final _code = TextEditingController();
  final _focus = FocusNode();
  bool _loading = false;
  String? _error;
  int _shakeKey = 0;
  int _seconds = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _seconds = 30);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_seconds <= 1) t.cancel();
      if (mounted) setState(() => _seconds--);
    });
  }

  Future<void> _verify() async {
    if (_code.text.length != _length || _loading) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      // Router redirect takes over once the session is stored.
      await ref.read(authControllerProvider.notifier).verifyOtp('91${widget.phone}', _code.text);
      HapticFeedback.mediumImpact();
    } catch (e) {
      HapticFeedback.heavyImpact();
      if (mounted) {
        setState(() {
          _error = e.toString();
          _shakeKey++;
          _code.clear();
        });
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _resend() async {
    await ref.read(authControllerProvider.notifier).requestOtp('91${widget.phone}');
    _startTimer();
    if (mounted) showAppSnack(context, 'A new code is on its way', icon: Icons.sms_outlined);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _code.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final masked = '+91 ${widget.phone.substring(0, 5)} ${widget.phone.substring(5)}';
    return AuthScaffold(
      showBack: true,
      title: 'Verify your\nnumber',
      subtitle: 'Enter the 4-digit code sent to $masked',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () => _focus.requestFocus(),
            child: Stack(
              children: [
                // Invisible field captures input, autofill and paste.
                Opacity(
                  opacity: 0,
                  child: TextField(
                    controller: _code,
                    focusNode: _focus,
                    autofillHints: const [AutofillHints.oneTimeCode],
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(_length),
                    ],
                    onChanged: (v) {
                      setState(() => _error = null);
                      if (v.length == _length) _verify();
                    },
                  ),
                ),
                ListenableBuilder(
                  listenable: Listenable.merge([_code, _focus]),
                  builder: (context, _) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(_length, (i) {
                      final filled = i < _code.text.length;
                      final active = _focus.hasFocus && i == _code.text.length;
                      return Flexible(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 68,
                          height: 72,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: filled ? AppColors.limeSoft : AppColors.surface,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            border: Border.all(
                              color: _error != null
                                  ? AppColors.error
                                  : (active
                                        ? AppColors.primaryGreen
                                        : (filled ? AppColors.primaryGreen.withValues(alpha: .4) : AppColors.border)),
                              width: active ? 2 : 1.4,
                            ),
                          ),
                          child: filled
                              ? Text(_code.text[i], style: t.headlineMedium).animate().scale(
                                  begin: const Offset(.6, .6),
                                  curve: Curves.easeOutBack,
                                  duration: 250.ms,
                                )
                              : (active
                                    ? Container(
                                        width: 2,
                                        height: 26,
                                        color: AppColors.primaryGreen,
                                      ).animate(onPlay: (c) => c.repeat(reverse: true)).fadeOut(duration: 500.ms)
                                    : null),
                        ),
                      );
                    }),
                  ),
                ).animate(key: ValueKey(_shakeKey)).shakeX(hz: _shakeKey == 0 ? 0 : 5, amount: 6, duration: 400.ms),
              ],
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: _error == null
                ? const SizedBox(height: 12)
                : Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(_error!, style: t.bodySmall?.copyWith(color: AppColors.error)),
                  ),
          ),
          const SizedBox(height: 12),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text('Didn’t get it? ', style: t.bodyMedium?.copyWith(color: AppColors.textSecondary)),
              _seconds > 0
                  ? Text(
                      'Resend in 0:${_seconds.toString().padLeft(2, '0')}',
                      style: t.labelLarge?.copyWith(color: AppColors.textMuted),
                    )
                  : GestureDetector(
                      onTap: _resend,
                      child: Text('Resend code', style: t.labelLarge?.copyWith(color: AppColors.primaryGreen)),
                    ),
            ],
          ),
          const SizedBox(height: 24),
          AppButton(
            label: 'Verify & continue',
            loading: _loading,
            onPressed: _code.text.length == _length ? _verify : null,
          ),
          const SizedBox(height: 16),
          const Center(
            child: Pill(
              label: 'Demo code: ${AppConfig.demoOtp}',
              icon: Icons.key_rounded,
              color: AppColors.secondaryDark,
              background: AppColors.limeSoft,
            ),
          ),
        ],
      ),
    );
  }
}
