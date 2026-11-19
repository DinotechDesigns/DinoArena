import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/constants/brand.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/common.dart';
import '../../../../shared/widgets/detail_header.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../booking/domain/entities/booking.dart';
import '../../../payment/domain/entities/payment.dart';
import '../../../payment/presentation/providers/checkout_providers.dart';
import '../../domain/entities/tournament.dart';
import '../providers/tournament_providers.dart';

class TournamentRegisterScreen extends ConsumerStatefulWidget {
  const TournamentRegisterScreen({super.key, required this.tournamentId});

  final String tournamentId;

  @override
  ConsumerState<TournamentRegisterScreen> createState() => _TournamentRegisterScreenState();
}

class _TournamentRegisterScreenState extends ConsumerState<TournamentRegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _team = TextEditingController();
  late final _captain = TextEditingController(text: ref.read(authControllerProvider).user?.name ?? '');
  late final _phone = TextEditingController(
    text: (ref.read(authControllerProvider).user?.phone ?? '').replaceFirst(RegExp(r'^91'), ''),
  );
  bool _acceptedRules = false;
  int? _players;

  @override
  void dispose() {
    _team.dispose();
    _captain.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _submit(Tournament tr) {
    if (!(_form.currentState?.validate() ?? false)) return;
    if (!_acceptedRules) {
      showAppSnack(context, 'Please accept the tournament rules to continue.', icon: Icons.rule_rounded);
      return;
    }
    final solo = tr.teamSize == 1;
    final players = _players ?? tr.teamSize;
    ref
        .read(checkoutControllerProvider.notifier)
        .begin(
          CheckoutRequest(
            kind: BookingKind.tournament,
            title: tr.name,
            subtitle:
                '${solo ? _captain.text.trim() : _team.text.trim()} · ${Fmt.dateShort(tr.startDate)} – ${Fmt.dateShort(tr.endDate)}',
            venue: '${Brand.name} Sports Hub',
            sport: tr.sport,
            start: tr.startDate.add(const Duration(hours: 8)),
            end: tr.endDate.add(const Duration(hours: 22)),
            players: players,
            unitLabel: solo ? null : _team.text.trim(),
            referenceId: tr.id,
            lineItems: [
              LineItem(label: solo ? 'Entry fee (incl. taxes)' : 'Team entry fee (incl. taxes)', amount: tr.entryFee),
            ],
            total: tr.entryFee,
            registration: TournamentRegistration(
              tournamentId: tr.id,
              teamName: solo ? _captain.text.trim() : _team.text.trim(),
              captainName: _captain.text.trim(),
              captainPhone: '91${_phone.text}',
              players: players,
            ),
          ),
        );
    context.push(Routes.checkout);
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return ref
        .watch(tournamentProvider(widget.tournamentId))
        .when(
          loading: () => const Scaffold(
            body: Center(child: CircularProgressIndicator(color: AppColors.primaryGreen)),
          ),
          error: (e, _) => Scaffold(
            appBar: const AppTopBar(title: 'Register'),
            body: ErrorView(message: e.toString()),
          ),
          data: (tr) {
            final solo = tr.teamSize == 1;
            final players = _players ?? tr.teamSize;
            return Scaffold(
              appBar: AppTopBar(title: solo ? 'Register' : 'Register your team'),
              body: Form(
                key: _form,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.gutter, 8, AppSpacing.gutter, 40),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: AppColors.darkGradient,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.accentLime,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.emoji_events_rounded, color: AppColors.primaryDark),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(tr.name, style: t.titleMedium?.copyWith(color: Colors.white)),
                                Text(
                                  '${tr.format} · starts ${Fmt.date(tr.startDate)}',
                                  style: t.bodySmall?.copyWith(color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (!solo) ...[
                      Text('Team name', style: t.labelLarge),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _team,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          hintText: 'e.g. Velociraptors XI',
                          prefixIcon: Icon(Icons.shield_outlined),
                        ),
                        validator: (v) => (v?.trim().length ?? 0) < 3 ? 'Give your team a name (3+ characters)' : null,
                      ),
                      const SizedBox(height: 18),
                    ],
                    Text(solo ? 'Player name' : 'Captain name', style: t.labelLarge),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _captain,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(prefixIcon: Icon(Icons.person_outline_rounded)),
                      validator: (v) => (v?.trim().length ?? 0) < 2 ? 'Enter a name' : null,
                    ),
                    const SizedBox(height: 18),
                    Text('Contact number', style: t.labelLarge),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _phone,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                      decoration: const InputDecoration(prefixText: '+91  ', prefixIcon: Icon(Icons.phone_outlined)),
                      validator: (v) =>
                          RegExp(r'^[6-9]\d{9}$').hasMatch(v ?? '') ? null : 'Enter a valid 10-digit mobile number',
                    ),
                    if (!solo) ...[
                      const SizedBox(height: 18),
                      Text('Squad size', style: t.labelLarge),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Minimum ${tr.teamSize - 2 < 2 ? tr.teamSize : tr.teamSize - 2}, maximum ${tr.teamSize}',
                                style: t.bodySmall?.copyWith(color: AppColors.textSecondary),
                              ),
                            ),
                            IconButton(
                              tooltip: 'Fewer players',
                              onPressed: players > (tr.teamSize - 2 < 2 ? tr.teamSize : tr.teamSize - 2)
                                  ? () => setState(() => _players = players - 1)
                                  : null,
                              icon: const Icon(Icons.remove_circle_outline_rounded),
                            ),
                            Text('$players', style: t.titleMedium),
                            IconButton(
                              tooltip: 'More players',
                              onPressed: players < tr.teamSize ? () => setState(() => _players = players + 1) : null,
                              icon: const Icon(Icons.add_circle_outline_rounded),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    Text('Rules', style: t.titleMedium),
                    const SizedBox(height: 10),
                    BulletList(items: tr.rules, icon: Icons.rule_rounded),
                    CheckboxListTile(
                      value: _acceptedRules,
                      onChanged: (v) => setState(() => _acceptedRules = v ?? false),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: AppColors.primaryGreen,
                      title: Text('I’ve read and accept the tournament rules', style: t.bodyMedium),
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: BottomActionBar(
                child: AppButton(
                  label: 'Continue to pay ${Fmt.money(tr.entryFee)}',
                  icon: Icons.lock_rounded,
                  onPressed: () => _submit(tr),
                ),
              ),
            );
          },
        );
  }
}
