import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/api.dart';
import '../../l10n/l10n.dart';
import '../../shared/actions.dart';
import '../../shared/format.dart';

final _calendarProvider = FutureProvider.autoDispose<BusinessCalendar>(
  (ref) => ref.watch(apiProvider).helpdesk.getCalendar(),
);

/// Business hours and holidays for the service levels (helpdesk administrators).
class CalendarPage extends ConsumerWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final canAdmin =
        ref.watch(meProvider).value?.permissions.contains('helpdesk.admin') ??
        false;
    final calendar = ref.watch(_calendarProvider);
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => context.canPop()
                    ? context.pop()
                    : context.go('/helpdesk/settings'),
                icon: const Icon(Icons.arrow_back),
              ),
              Text(
                l.businessHours,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
          if (!canAdmin)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(l.noPermission),
            )
          else
            calendar.when(
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text(errorMessage(e)),
              data: (c) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _HoursCard(key: ValueKey('hours-${c.hashCode}'), calendar: c),
                  const SizedBox(height: 16),
                  _HolidaysCard(calendar: c),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

String _weekday(AppLocalizations l, int n) => switch (n) {
  1 => l.weekdayMonday,
  2 => l.weekdayTuesday,
  3 => l.weekdayWednesday,
  4 => l.weekdayThursday,
  5 => l.weekdayFriday,
  6 => l.weekdaySaturday,
  _ => l.weekdaySunday,
};

final _time = RegExp(r'^([01]?\d|2[0-3]):[0-5]\d$');

class _HoursCard extends ConsumerStatefulWidget {
  const _HoursCard({super.key, required this.calendar});
  final BusinessCalendar calendar;

  @override
  ConsumerState<_HoursCard> createState() => _HoursCardState();
}

class _HoursCardState extends ConsumerState<_HoursCard> {
  late bool _enabled = widget.calendar.enabled;
  late final _zone = TextEditingController(text: widget.calendar.timeZone);
  final _open = <int, bool>{};
  final _start = <int, TextEditingController>{};
  final _end = <int, TextEditingController>{};
  String? _error;

  @override
  void initState() {
    super.initState();
    for (var d = 1; d <= 7; d++) {
      final h = widget.calendar.hours.where((h) => h.weekday == d).firstOrNull;
      _open[d] = h != null;
      _start[d] = TextEditingController(text: h?.startTime ?? '09:00');
      _end[d] = TextEditingController(text: h?.endTime ?? '17:00');
    }
  }

  Future<void> _save() async {
    final l = context.l10n;
    final hours = <WorkingHours>[];
    for (var d = 1; d <= 7; d++) {
      if (_open[d] != true) continue;
      final (s, e) = (_start[d]!.text.trim(), _end[d]!.text.trim());
      if (!_time.hasMatch(s) || !_time.hasMatch(e)) {
        setState(() => _error = l.businessHoursInvalidTime);
        return;
      }
      hours.add(WorkingHours(weekday: d, startTime: s, endTime: e));
    }
    setState(() => _error = null);
    final ok = await runAction(context, () async {
      await ref
          .read(apiProvider)
          .helpdesk
          .putCalendar(
            body: CalendarInput(
              enabled: _enabled,
              timeZone: _zone.text.trim(),
              hours: hours,
            ),
          );
      ref.invalidate(_calendarProvider);
    }, success: l.businessHoursSaved);
    if (!ok && mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Card(
      key: const ValueKey('business-hours'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.businessHours, style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(l.businessHoursHelp, style: theme.textTheme.bodySmall),
            SwitchListTile(
              key: const ValueKey('calendar-enabled'),
              contentPadding: EdgeInsets.zero,
              title: Text(l.businessHoursEnabled),
              value: _enabled,
              onChanged: (v) => setState(() => _enabled = v),
            ),
            SizedBox(
              width: 320,
              child: TextField(
                key: const ValueKey('calendar-zone'),
                controller: _zone,
                decoration: InputDecoration(
                  labelText: l.timeZone,
                  helperText: 'Europe/Brussels',
                ),
              ),
            ),
            const SizedBox(height: 8),
            for (var d = 1; d <= 7; d++)
              Row(
                children: [
                  SizedBox(
                    width: 180,
                    child: CheckboxListTile(
                      key: ValueKey('open-$d'),
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      value: _open[d],
                      onChanged: (v) => setState(() => _open[d] = v ?? false),
                      title: Text(_weekday(l, d)),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: TextField(
                      key: ValueKey('start-$d'),
                      controller: _start[d],
                      enabled: _open[d] == true,
                      decoration: InputDecoration(
                        labelText: l.opens,
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 100,
                    child: TextField(
                      key: ValueKey('end-$d'),
                      controller: _end[d],
                      enabled: _open[d] == true,
                      decoration: InputDecoration(
                        labelText: l.closes,
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _error!,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
            const SizedBox(height: 8),
            Text(l.businessHoursRecompute, style: theme.textTheme.bodySmall),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                key: const ValueKey('save-calendar'),
                onPressed: _save,
                child: Text(l.save),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HolidaysCard extends ConsumerStatefulWidget {
  const _HolidaysCard({required this.calendar});
  final BusinessCalendar calendar;

  @override
  ConsumerState<_HolidaysCard> createState() => _HolidaysCardState();
}

class _HolidaysCardState extends ConsumerState<_HolidaysCard> {
  final _day = TextEditingController();
  final _name = TextEditingController();

  Future<void> _pick() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (d != null) {
      _day.text =
          '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _add() async {
    final l = context.l10n;
    final day = DateTime.tryParse(_day.text.trim());
    if (day == null || _name.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.holidayInvalid)));
      return;
    }
    final ok = await runAction(
      context,
      () => ref
          .read(apiProvider)
          .helpdesk
          .addHoliday(
            body: HolidayInput(day: day, name: _name.text.trim()),
          ),
      success: l.saved,
    );
    if (ok) {
      _day.clear();
      _name.clear();
      ref.invalidate(_calendarProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Card(
      key: const ValueKey('holidays'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.holidays, style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(l.holidaysHelp, style: theme.textTheme.bodySmall),
            for (final h in widget.calendar.holidays)
              ListTile(
                key: ValueKey('holiday-${h.id}'),
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(h.name),
                subtitle: Text(date(h.day)),
                trailing: IconButton(
                  tooltip: l.remove,
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () async {
                    final ok = await runAction(
                      context,
                      () => ref
                          .read(apiProvider)
                          .helpdesk
                          .deleteHoliday(id: h.id),
                    );
                    if (ok) ref.invalidate(_calendarProvider);
                  },
                ),
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                SizedBox(
                  width: 170,
                  child: TextField(
                    key: const ValueKey('holiday-day'),
                    controller: _day,
                    decoration: InputDecoration(
                      labelText: l.holidayDate,
                      hintText: 'YYYY-MM-DD',
                      isDense: true,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.event, size: 18),
                        onPressed: _pick,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    key: const ValueKey('holiday-name'),
                    controller: _name,
                    decoration: InputDecoration(
                      labelText: l.name,
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton.tonal(
                  key: const ValueKey('add-holiday'),
                  onPressed: _add,
                  child: Text(l.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
