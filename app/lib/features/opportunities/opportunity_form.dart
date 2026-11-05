import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/api.dart';
import '../../shared/format.dart';
import '../../shared/search_picker.dart';

/// Create or edit an opportunity. Returns the saved opportunity, or null when cancelled.
Future<Opportunity?> showOpportunityForm(
  BuildContext context, {
  Opportunity? opportunity,
}) => showDialog<Opportunity>(
  context: context,
  builder: (_) => OpportunityForm(opportunity: opportunity),
);

class OpportunityForm extends ConsumerStatefulWidget {
  const OpportunityForm({super.key, this.opportunity});
  final Opportunity? opportunity;

  @override
  ConsumerState<OpportunityForm> createState() => _OpportunityFormState();
}

class _OpportunityFormState extends ConsumerState<OpportunityForm> {
  late final o = widget.opportunity;
  late final _title = TextEditingController(text: o?.title);
  late final _value = TextEditingController(
    text: o == null ? '' : number(o!.expectedValue),
  );
  late final _probability = TextEditingController(
    text: o == null ? '' : '${o!.probability}',
  );
  late final _notes = TextEditingController(text: o?.notes);
  late String? _customerId = o?.customerId;
  late String? _customerLabel = o?.customerName;
  late DateTime? _close = o?.expectedClose;
  String? _error;

  Future<void> _save() async {
    final value = parseDecimalInput(_value.text.isEmpty ? '0' : _value.text);
    final probability = _probability.text.trim().isEmpty
        ? null
        : int.tryParse(_probability.text.trim());
    if (_title.text.trim().isEmpty || _customerId == null || value == null) {
      setState(
        () => _error = 'Title, customer and a valid value are required.',
      );
      return;
    }
    final body = OpportunityInput(
      title: _title.text.trim(),
      customerId: _customerId!,
      expectedValue: value,
      probability: probability,
      expectedClose: _close,
      notes: _notes.text,
    );
    try {
      final crm = ref.read(apiProvider).crm;
      final saved = o == null
          ? await crm.createOpportunity(body: body)
          : await crm.updateOpportunity(id: o!.id, body: body);
      if (mounted) Navigator.pop(context, saved);
    } catch (e) {
      setState(() => _error = errorMessage(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 12, width: 12);
    return AlertDialog(
      title: Text(o == null ? 'New opportunity' : o!.number),
      content: SizedBox(
        width: 520,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            gap,
            if (o == null)
              SearchPicker<Customer>(
                label: 'Customer',
                display: (c) => '${c.code} · ${c.name}',
                search: (q) async =>
                    (await ref
                            .read(apiProvider)
                            .crm
                            .listCustomers(q: q, limit: 20))
                        .items,
                onSelected: (c) => setState(() {
                  _customerId = c.id;
                  _customerLabel = c.name;
                }),
              )
            else
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Customer: $_customerLabel'),
              ),
            gap,
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _value,
                    decoration: const InputDecoration(
                      labelText: 'Expected value (€)',
                    ),
                  ),
                ),
                gap,
                SizedBox(
                  width: 140,
                  child: TextField(
                    controller: _probability,
                    decoration: const InputDecoration(
                      labelText: 'Probability %',
                      hintText: 'by stage',
                    ),
                  ),
                ),
              ],
            ),
            gap,
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                _close == null
                    ? 'No expected close date'
                    : 'Expected close ${date(_close)}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final d = await showDatePicker(
                  context: context,
                  initialDate: _close ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (d != null) setState(() => _close = d);
              },
            ),
            TextField(
              controller: _notes,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Notes'),
            ),
            if (_error != null) ...[
              gap,
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}
