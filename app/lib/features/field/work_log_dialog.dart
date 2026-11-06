import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/api.dart';
import '../../l10n/l10n.dart';
import '../../shared/photos.dart' show newClientId;

final _stamp = DateFormat('dd/MM/yyyy HH:mm');

/// Asks for a date and then a time; null when cancelled.
Future<DateTime?> pickDateTime(BuildContext context, DateTime initial) async {
  final date = await showDatePicker(
    context: context,
    initialDate: initial,
    firstDate: DateTime(2020),
    lastDate: DateTime(2100),
  );
  if (date == null || !context.mounted) return null;
  final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initial),
  );
  if (time == null) return null;
  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}

/// Logs work or travel on a job. The entry gets its id when the dialog opens, so pressing Save
/// again after a failed attempt cannot register the time twice.
Future<JobDetail?> showWorkLogDialog(BuildContext context, String jobId) =>
    showDialog<JobDetail>(
      context: context,
      builder: (_) => WorkLogDialog(jobId: jobId),
    );

class WorkLogDialog extends ConsumerStatefulWidget {
  const WorkLogDialog({super.key, required this.jobId});
  final String jobId;

  @override
  ConsumerState<WorkLogDialog> createState() => _WorkLogDialogState();
}

class _WorkLogDialogState extends ConsumerState<WorkLogDialog> {
  final _entryId = newClientId();
  final _notes = TextEditingController();
  String _kind = 'work';
  DateTime _from = DateTime.now().subtract(const Duration(hours: 1));
  DateTime _until = DateTime.now();
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final d = await ref
          .read(apiProvider)
          .field
          .addWorkLog(
            id: widget.jobId,
            body: WorkLogInput(
              id: _entryId,
              kind: _kind,
              startedAt: _from.toUtc(),
              endedAt: _until.toUtc(),
              notes: _notes.text.trim(),
            ),
          );
      if (mounted) Navigator.pop(context, d);
    } catch (e) {
      if (mounted) setState(() => _error = errorMessage(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final minutes = _until.difference(_from).inMinutes;
    Widget picker(String label, DateTime value, ValueChanged<DateTime> set) =>
        Expanded(
          child: OutlinedButton(
            onPressed: () async {
              final v = await pickDateTime(context, value);
              if (v != null) setState(() => set(v));
            },
            child: Text('$label\n${_stamp.format(value)}'),
          ),
        );
    return AlertDialog(
      title: Text(l.logWork),
      content: SizedBox(
        width: 440,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SegmentedButton<String>(
              segments: [
                ButtonSegment(
                  value: 'work',
                  icon: const Icon(Icons.build_outlined),
                  label: Text(l.workKindWork),
                ),
                ButtonSegment(
                  value: 'travel',
                  icon: const Icon(Icons.directions_car_outlined),
                  label: Text(l.workKindTravel),
                ),
              ],
              selected: {_kind},
              onSelectionChanged: (s) => setState(() => _kind = s.first),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                picker(l.workFrom, _from, (v) => _from = v),
                const SizedBox(width: 8),
                picker(l.workUntil, _until, (v) => _until = v),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(minutes > 0 ? minutesText(minutes) : '—'),
            ),
            TextField(
              controller: _notes,
              minLines: 2,
              maxLines: 5,
              decoration: InputDecoration(labelText: l.notes),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.cancel),
        ),
        FilledButton(
          onPressed: _busy || minutes <= 0 ? null : _save,
          child: Text(l.save),
        ),
      ],
    );
  }
}
