import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swim_college_app/core/l10n/generated/app_localizations.dart';
import '../../core/widgets/loading_widget.dart';
import '../../data/models/time_slot.dart';
import 'book_class_provider.dart';

class BookClassScreen extends ConsumerStatefulWidget {
  const BookClassScreen({super.key});

  @override
  ConsumerState<BookClassScreen> createState() => _BookClassScreenState();
}

class _BookClassScreenState extends ConsumerState<BookClassScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(bookClassProvider.notifier).loadCourses());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(bookClassProvider);
    final theme = Theme.of(context);

    // Handle booking success
    if (state.bookingSuccess) {
      Future.microtask(() {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.bookingSuccess),
            backgroundColor: Colors.green,
          ),
        );
        ref.read(bookClassProvider.notifier).reset();
        context.go('/bookings');
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.bookClass),
        actions: [
          if (state.currentStep > 0)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.read(bookClassProvider.notifier).reset(),
              tooltip: l10n.startOver,
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.selectDateTime,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.outline)),
          const SizedBox(height: 20),

          // Step 1: Course type
          _SectionHeader(
            step: 1,
            title: l10n.step1ChooseType,
            isActive: true,
          ),
          const SizedBox(height: 12),
          if (state.courseTypes.isEmpty && state.isLoading)
            const LoadingWidget()
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: state.courseTypes.map((course) {
                final isSelected = state.selectedCourse == course;
                return ChoiceChip(
                  label: Text(course),
                  selected: isSelected,
                  onSelected: (_) =>
                      ref.read(bookClassProvider.notifier).selectCourse(course),
                  selectedColor: theme.colorScheme.primaryContainer,
                  labelStyle: TextStyle(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                  ),
                );
              }).toList(),
            ),

          // Step 2: Date
          if (state.currentStep >= 1) ...[
            const SizedBox(height: 24),
            _SectionHeader(
              step: 2,
              title: l10n.step2SelectDate,
              isActive: state.currentStep >= 1,
            ),
            const SizedBox(height: 12),
            Card(
              child: CalendarDatePicker(
                initialDate: state.selectedDate ?? DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 90)),
                onDateChanged: (date) =>
                    ref.read(bookClassProvider.notifier).selectDate(date),
              ),
            ),
          ],

          // Step 3: Time slots
          if (state.currentStep >= 2) ...[
            const SizedBox(height: 24),
            _SectionHeader(
              step: 3,
              title: l10n.step3SelectTime,
              isActive: state.currentStep >= 2,
            ),
            const SizedBox(height: 12),
            if (state.isLoading && state.slots.isEmpty)
              const LoadingWidget()
            else if (state.slots.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      l10n.noCourses,
                      style: TextStyle(color: theme.colorScheme.outline),
                    ),
                  ),
                ),
              )
            else
              ...state.slots.map(
                (slot) => _SlotCard(
                  slot: slot,
                  isSelected: state.selectedSlot?.id == slot.id,
                  onTap: slot.canBook
                      ? () =>
                          ref.read(bookClassProvider.notifier).selectSlot(slot)
                      : null,
                ),
              ),
          ],

          // Step 4: Confirm
          if (state.currentStep >= 3) ...[
            const SizedBox(height: 24),
            _SectionHeader(
              step: 4,
              title: l10n.step4Confirm,
              isActive: state.currentStep >= 3,
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ConfirmRow(
                        label: l10n.classType,
                        value: state.selectedCourse ?? ''),
                    const SizedBox(height: 8),
                    _ConfirmRow(
                      label: l10n.dateLabel,
                      value: state.selectedDate != null
                          ? '${state.selectedDate!.day}/${state.selectedDate!.month}/${state.selectedDate!.year}'
                          : '',
                    ),
                    const SizedBox(height: 8),
                    _ConfirmRow(
                        label: l10n.timeLabel,
                        value: state.selectedSlot?.time ?? ''),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.info_outline,
                            size: 16, color: Colors.green[700]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.bookingInfo,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.green[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (state.error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  '${l10n.bookingFailed}${state.error}',
                  style: TextStyle(color: theme.colorScheme.error),
                  textAlign: TextAlign.center,
                ),
              ),
            FilledButton.icon(
              onPressed: state.isLoading
                  ? null
                  : () =>
                      ref.read(bookClassProvider.notifier).confirmBooking(),
              icon: state.isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.check),
              label: Text(l10n.confirmBooking),
            ),
          ],

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final int step;
  final String title;
  final bool isActive;

  const _SectionHeader({
    required this.step,
    required this.title,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: isActive
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceContainerHighest,
          child: Text(
            '$step',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.white : theme.colorScheme.outline,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: isActive ? null : theme.colorScheme.outline,
          ),
        ),
      ],
    );
  }
}

class _SlotCard extends StatelessWidget {
  final TimeSlot slot;
  final bool isSelected;
  final VoidCallback? onTap;

  const _SlotCard({
    required this.slot,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    Color statusColor;
    String statusText;
    IconData statusIcon;

    if (slot.isCancelled) {
      statusColor = Colors.orange;
      statusText = l10n.bookingStatusCancelled;
      statusIcon = Icons.block;
    } else if (slot.canBook) {
      statusColor = Colors.green;
      statusText = l10n.available;
      statusIcon = Icons.check_circle;
    } else {
      statusColor = Colors.red;
      statusText = l10n.full;
      statusIcon = Icons.cancel;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected
            ? BorderSide(color: theme.colorScheme.primary, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      slot.time,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSelected ? theme.colorScheme.primary : null,
                      ),
                    ),
                    if (slot.teacher.isNotEmpty)
                      Text(
                        slot.teacher,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: theme.colorScheme.outline),
                      ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(statusIcon, size: 16, color: statusColor),
                  const SizedBox(width: 4),
                  Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              if (slot.persons >= 0) ...[
                const SizedBox(width: 12),
                Icon(Icons.people, size: 16, color: theme.colorScheme.outline),
                const SizedBox(width: 4),
                Text(
                  '${slot.persons}',
                  style: TextStyle(
                    color: theme.colorScheme.outline,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ConfirmRow extends StatelessWidget {
  final String label;
  final String value;

  const _ConfirmRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text('$label: ',
            style: theme.textTheme.bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
        Text(value,
            style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
