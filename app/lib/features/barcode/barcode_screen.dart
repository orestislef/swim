import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swim_college_app/core/l10n/generated/app_localizations.dart';
import '../../core/widgets/loading_widget.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/error_state.dart';
import '../../data/models/barcode_data.dart';
import '../dashboard/dashboard_provider.dart';

final barcodeProvider = FutureProvider<BarcodeData?>((ref) {
  return ref.watch(dataRepositoryProvider).getBarcode();
});

class BarcodeScreen extends ConsumerWidget {
  const BarcodeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final asyncData = ref.watch(barcodeProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.myBarcode)),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(barcodeProvider.future),
        child: asyncData.when(
          loading: () => const LoadingWidget(),
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
                              // Use BarcodeWidget to render locally from code
                              if (data.code.isNotEmpty)
                                BarcodeWidget(
                                  barcode: Barcode.code128(),
                                  data: data.code,
                                  width: 280,
                                  height: 100,
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
