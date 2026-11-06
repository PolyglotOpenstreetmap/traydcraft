import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/api.dart';
import '../../l10n/l10n.dart';
import '../../shared/actions.dart';
import '../../shared/photos.dart';
import 'job_form.dart';
import 'jobs_page.dart' show whenText;
import 'work_log_dialog.dart';

final _stamp = DateFormat('dd/MM HH:mm');

/// One job, as the technician needs it on site: where to go, what to do, the checklist, time
/// and photos. Planners can also edit, cancel and reopen it.
class JobScreen extends ConsumerStatefulWidget {
  const JobScreen({super.key, required this.id});
  final String id;

  @override
  ConsumerState<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends ConsumerState<JobScreen> {
  JobDetail? _d;
  String? _error;
  bool _busy = false;
  final _newTask = TextEditingController();

  FieldClient get _field => ref.read(apiProvider).field;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _newTask.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final d = await _field.getJob(id: widget.id);
      if (mounted) setState(() => _d = d);
    } catch (e) {
      if (mounted) setState(() => _error = errorMessage(e));
    }
  }

  Future<void> _run(Future<JobDetail> Function() action) async {
    setState(() => _busy = true);
    JobDetail? d;
    final ok = await runAction(context, () async => d = await action());
    if (mounted) setState(() => _busy = false);
    if (ok && d != null && mounted) setState(() => _d = d);
  }

  Future<void> _complete() async {
    final l = context.l10n;
    final notes = await showDialog<String>(
      context: context,
      builder: (_) =>
          _CompleteDialog(done: _d!.job.tasksDone, total: _d!.job.tasksTotal),
    );
    if (notes == null || notes.isEmpty || !mounted) return;
    await _run(
      () => _field.completeJob(
        id: widget.id,
        body: CompleteInput(notes: notes),
      ),
    );
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.saved)));
    }
  }

  Future<void> _open(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null ||
        !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(url)));
      }
    }
  }

  Future<void> _addPhotos(List<PickedPhoto> photos) async {
    final dio = ref.read(dioProvider);
    for (final p in photos) {
      await uploadPhoto(dio, '/api/v1/field/jobs/${widget.id}/photos', p);
    }
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final d = _d;
    if (d == null) {
      return Scaffold(
        body: Center(
          child: _error != null
              ? Text(_error!)
              : const CircularProgressIndicator(),
        ),
      );
    }
    final j = d.job;
    final perms = ref.watch(meProvider).value?.permissions ?? const [];
    final planner = perms.contains('field.plan');
    final canWork = planner || perms.contains('field.work');
    final open = j.status == 'planned' || j.status == 'in_progress';

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () =>
                    context.canPop() ? context.pop(true) : context.go('/jobs'),
                icon: const Icon(Icons.arrow_back),
              ),
              Expanded(
                child: Text(
                  '${j.number}  ${j.title}',
                  style: theme.textTheme.titleLarge,
                ),
              ),
              Chip(label: Text(l.jobStatus(j.status))),
            ],
          ),
          Text(
            '${j.customerName} · ${l.jobKind(j.kind)} · ${whenText(j, l)}',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          // Where to go
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.siteAddress, style: theme.textTheme.labelMedium),
                  if (j.siteName.isNotEmpty) Text(j.siteName),
                  SelectableText(j.address.isEmpty ? '—' : j.address),
                  Wrap(
                    spacing: 8,
                    children: [
                      if (j.mapsUrl != null)
                        FilledButton.tonalIcon(
                          icon: const Icon(Icons.directions),
                          label: Text(l.navigate),
                          onPressed: () => _open(j.mapsUrl!),
                        ),
                      for (final p in d.contactPhones)
                        OutlinedButton.icon(
                          icon: const Icon(Icons.call),
                          label: Text(
                            '${j.contactName ?? l.onSiteContact} · ${p.number}',
                          ),
                          onPressed: () =>
                              _open('tel:${p.number.replaceAll(' ', '')}'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (j.instructions.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(l.instructions, style: theme.textTheme.titleSmall),
            SelectableText(j.instructions),
          ],
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (canWork && j.status == 'planned')
                FilledButton.icon(
                  icon: const Icon(Icons.play_arrow),
                  label: Text(l.startJob),
                  onPressed: _busy
                      ? null
                      : () => _run(() => _field.startJob(id: widget.id)),
                ),
              if (canWork && open)
                OutlinedButton.icon(
                  icon: const Icon(Icons.timer_outlined),
                  label: Text(l.logWork),
                  onPressed: _busy
                      ? null
                      : () async {
                          final r = await showWorkLogDialog(context, widget.id);
                          if (r != null && mounted) setState(() => _d = r);
                        },
                ),
              if (canWork && open)
                FilledButton.icon(
                  icon: const Icon(Icons.check_circle_outline),
                  label: Text(l.completeJob),
                  onPressed: _busy ? null : _complete,
                ),
              if (planner && open)
                OutlinedButton.icon(
                  icon: const Icon(Icons.edit_outlined),
                  label: Text(l.editJob),
                  onPressed: () async {
                    final r = await showJobForm(context, detail: d);
                    if (r != null && mounted) setState(() => _d = r);
                  },
                ),
              if (planner && open)
                OutlinedButton.icon(
                  icon: const Icon(Icons.cancel_outlined),
                  label: Text(l.cancelJob),
                  onPressed: _busy
                      ? null
                      : () async {
                          final reason = await askText(
                            context,
                            title: l.cancelJob,
                            label: l.notes,
                          );
                          if (reason == null) return;
                          await _run(
                            () => _field.cancelJob(
                              id: widget.id,
                              body: ReasonInput(reason: reason),
                            ),
                          );
                        },
                ),
              if (planner && !open)
                OutlinedButton.icon(
                  icon: const Icon(Icons.undo),
                  label: Text(l.reopenJob),
                  onPressed: _busy
                      ? null
                      : () => _run(() => _field.reopenJob(id: widget.id)),
                ),
            ],
          ),
          if (j.completionNotes.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(l.completionNotes, style: theme.textTheme.labelMedium),
            SelectableText(j.completionNotes),
          ],
          const Divider(height: 32),
          // The checklist
          Row(
            children: [
              Text(l.tasks, style: theme.textTheme.titleSmall),
              const SizedBox(width: 8),
              Text(l.tasksProgress('${j.tasksDone}', '${j.tasksTotal}')),
            ],
          ),
          for (final t in d.tasks)
            CheckboxListTile(
              dense: true,
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              value: t.done,
              title: Text(
                t.description,
                style: t.done
                    ? const TextStyle(decoration: TextDecoration.lineThrough)
                    : null,
              ),
              subtitle: t.done && t.doneByName != null
                  ? Text(t.doneByName!)
                  : null,
              onChanged: canWork && open && !_busy
                  ? (v) => _run(
                      () => _field.setJobTaskDone(
                        id: widget.id,
                        taskId: t.id,
                        body: DoneInput(done: v ?? false),
                      ),
                    )
                  : null,
            ),
          if (canWork && open)
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newTask,
                    decoration: InputDecoration(labelText: l.addTask),
                    onSubmitted: (_) => _submitTask(),
                  ),
                ),
                IconButton(onPressed: _submitTask, icon: const Icon(Icons.add)),
              ],
            ),
          const Divider(height: 32),
          // Time
          Row(
            children: [
              Text(l.workLogs, style: theme.textTheme.titleSmall),
              const Spacer(),
              Text(
                l.timeTotals(
                  minutesText(d.workMinutes),
                  minutesText(d.travelMinutes),
                ),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
          for (final w in d.workLogs)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                w.kind == 'travel'
                    ? Icons.directions_car_outlined
                    : Icons.build_outlined,
                size: 20,
              ),
              title: Text(
                '${minutesText(w.minutes)}${w.notes.isEmpty ? '' : ' — ${w.notes}'}',
              ),
              subtitle: Text(
                '${w.userName} · ${_stamp.format(w.startedAt.toLocal())}',
              ),
            ),
          const Divider(height: 32),
          PhotoGallery(
            photos: [
              for (final p in d.photos)
                PhotoItem(id: p.id, caption: p.caption, by: p.uploaderName),
            ],
            dio: ref.watch(dioProvider),
            pathFor: (id) => '/api/v1/field/jobs/${widget.id}/photos/$id',
            onAdd: canWork && j.status != 'cancelled' ? _addPhotos : null,
          ),
        ],
      ),
    );
  }

  void _submitTask() {
    final text = _newTask.text.trim();
    if (text.isEmpty) return;
    _newTask.clear();
    _run(
      () => _field.addJobTask(
        id: widget.id,
        body: TaskInput(description: text),
      ),
    );
  }
}

class _CompleteDialog extends StatefulWidget {
  const _CompleteDialog({required this.done, required this.total});
  final int done;
  final int total;

  @override
  State<_CompleteDialog> createState() => _CompleteDialogState();
}

class _CompleteDialogState extends State<_CompleteDialog> {
  final _notes = TextEditingController();

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AlertDialog(
      title: Text(l.completeJob),
      content: SizedBox(
        width: 440,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Unticked tasks are allowed, but the technician should say why in the report.
            if (widget.done < widget.total)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  l.tasksProgress('${widget.done}', '${widget.total}'),
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            TextField(
              controller: _notes,
              autofocus: true,
              minLines: 3,
              maxLines: 8,
              decoration: InputDecoration(labelText: l.completionNotes),
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
          onPressed: () => Navigator.pop(context, _notes.text.trim()),
          child: Text(l.completeJob),
        ),
      ],
    );
  }
}
