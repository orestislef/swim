import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:swim_college_app/core/l10n/generated/app_localizations.dart';
import '../../core/date_utils.dart' as du;
import '../../core/widgets/loading_widget.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/error_state.dart';
import '../../data/models/barcode_data.dart';
import '../dashboard/dashboard_provider.dart';
import '../settings/settings_provider.dart';

final barcodeProvider = FutureProvider<BarcodeData?>((ref) {
  return ref.watch(dataRepositoryProvider).getBarcode();
});

class BarcodeScreen extends ConsumerStatefulWidget {
  const BarcodeScreen({super.key});

  @override
  ConsumerState<BarcodeScreen> createState() => _BarcodeScreenState();
}

class _BarcodeScreenState extends ConsumerState<BarcodeScreen> {
  double? _previousBrightness;

  @override
  void initState() {
    super.initState();
    _boostBrightness();
  }

  Future<void> _boostBrightness() async {
    try {
      _previousBrightness = await ScreenBrightness().current;
      await ScreenBrightness().setScreenBrightness(1.0);
    } catch (_) {}
  }

  Future<void> _restoreBrightness() async {
    try {
      if (_previousBrightness != null) {
        await ScreenBrightness().setScreenBrightness(_previousBrightness!);
      } else {
        await ScreenBrightness().resetScreenBrightness();
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _restoreBrightness();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final asyncData = ref.watch(barcodeProvider);
    final theme = Theme.of(context);
    final dashState = ref.watch(dashboardProvider);
    final locale = ref.watch(settingsProvider).locale.languageCode;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.myBarcode)),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(barcodeProvider.future),
        child: asyncData.when(
          loading: () => const ShimmerBarcode(),
          error: (e, _) => ListView(children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: ErrorState(
                message: e.toString(),
                onRetry: () => ref.invalidate(barcodeProvider),
              ),
            )
          ]),
          data: (data) {
            if (data == null ||
                (data.code.isEmpty && data.svg.isEmpty)) {
              return ListView(children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: EmptyState(
                    icon: Icons.qr_code_2,
                    title: l10n.barcodeNotAvailable,
                  ),
                ),
              ]);
            }
            return ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.qr_code_2,
                          size: 48, color: theme.colorScheme.primary),
                      const SizedBox(height: 16),
                      Text(
                        l10n.showAtEntrance,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.presentBarcode,
                        style: TextStyle(color: theme.colorScheme.outline),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              if (data.code.isNotEmpty)
                                BarcodeWidget(
                                  barcode: Barcode.code128(),
                                  data: data.code,
                                  width: 280,
                                  height: 140,
                                  drawText: false,
                                  color: theme.colorScheme.onSurface,
                                ),
                              if (data.code.isNotEmpty) ...[
                                const SizedBox(height: 16),
                                Text(
                                  data.code,
                                  style:
                                      theme.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 4,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),

                      // Member info
                      if (dashState.user != null) ...[
                        const SizedBox(height: 20),
                        Text(
                          dashState.user!.name,
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        if (dashState.user!.expiry.isNotEmpty)
                          Text(
                            '${l10n.expires}: ${dashState.user!.expiry}',
                            style: TextStyle(color: theme.colorScheme.outline),
                          ),
                      ],

                      // Next upcoming class
                      if (dashState.bookings.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        const Divider(),
                        const SizedBox(height: 16),
                        () {
                          final now = DateTime.now();
                          final nextBooking = dashState.bookings.where((b) {
                            final dt = du.parseBookingDateTime(b.date, b.time);
                            return dt != null && dt.isAfter(now);
                          }).toList();

                          if (nextBooking.isEmpty) return const SizedBox.shrink();
                          final next = nextBooking.first;
                          final classTime = du.parseBookingDateTime(next.date, next.time);
                          final countdown = classTime != null
                              ? du.formatCountdown(classTime, locale: locale)
                              : '';

                          return Card(
                            color: theme.colorScheme.primaryContainer.withAlpha(80),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.pool,
                                          size: 20, color: theme.colorScheme.primary),
                                      const SizedBox(width: 8),
                                      Text(
                                        l10n.nextClass,
                                        style: theme.textTheme.titleSmall
                                            ?.copyWith(fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    next.course,
                                    style: theme.textTheme.bodyLarge
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    '${next.date}  ${next.time}',
                                    style: TextStyle(color: theme.colorScheme.outline),
                                  ),
                                  if (countdown.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        countdown,
                                        style: TextStyle(
                                          color: theme.colorScheme.primary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        }(),
                      ],
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
