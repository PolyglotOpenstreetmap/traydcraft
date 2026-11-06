import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/api.dart';
import '../../l10n/l10n.dart';
import '../../shared/entity_list.dart';
import '../../shared/format.dart';
import '../../shared/search_picker.dart';
import 'call_dialogs.dart';

const ticketStatuses = [
  'new',
  'open',
  'pending_customer',
  'pending_internal',
  'closed',
];
const ticketPriorities = ['low', 'normal', 'high', 'urgent'];
const ticketCategories = [
  'question',
  'lead',
  'quote_change',
  'order_confirmation',
  'production_question',
  'service',
  'complaint',
  'other',
];

/// Ticket overview: my tickets, unassigned or all; open ones first.
class TicketsPage extends ConsumerStatefulWidget {
  const TicketsPage({super.key});

  @override
  ConsumerState<TicketsPage> createState() => _TicketsPageState();
}

class _TicketsPageState extends ConsumerState<TicketsPage> {
  final _list = GlobalKey<EntityListState<Ticket>>();
  String _owner = 'me';
  String _status = 'active';

  void _reload() => _list.currentState?.reload();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final api = ref.watch(apiProvider);
    final perms = ref.watch(meProvider).value?.permissions ?? const [];
    return EntityList<Ticket>(
      key: _list,
      title: l.helpdesk,
      load: (q, offset, limit) async {
        final page = await api.helpdesk.listTickets(
          q: q,
          owner: _owner == 'all' ? null : _owner,
          status: _status == 'all' ? null : _status,
          offset: offset,
          limit: limit,
        );
        return (page.items, page.total);
      },
      filters: Wrap(
        spacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SegmentedButton<String>(
            segments: [
              ButtonSegment(value: 'me', label: Text(l.myTickets)),
              ButtonSegment(value: 'none', label: Text(l.unassigned)),
              ButtonSegment(value: 'all', label: Text(l.all)),
            ],
            selected: {_owner},
            onSelectionChanged: (s) {
              setState(() => _owner = s.first);
              _reload();
            },
          ),
          DropdownButton<String>(
            value: _status,
            items: [
              DropdownMenuItem(value: 'active', child: Text(l.notClosed)),
              DropdownMenuItem(value: 'all', child: Text(l.allStatuses)),
              for (final s in ticketStatuses)
                DropdownMenuItem(value: s, child: Text(l.ticketStatus(s))),
            ],
            onChanged: (v) {
              setState(() => _status = v!);
              _reload();
            },
          ),
        ],
      ),
      actions: [
        if (perms.contains('helpdesk.write'))
          FilledButton.tonalIcon(
            icon: const Icon(Icons.phone_in_talk_outlined),
            label: Text(l.whoIsCalling),
            onPressed: () async {
              final d = await showCallerLookup(context);
              if (d != null && context.mounted) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(l.callLogged)));
                context.push('/helpdesk/${d.ticket.id}');
              }
            },
          ),
        OutlinedButton.icon(
          icon: const Icon(Icons.text_snippet_outlined),
          label: Text(l.preparedAnswers),
          onPressed: () => context.push('/helpdesk/answers'),
        ),
      ],
      columns: [
        EntityColumn(l.number, (t) => t.number),
        EntityColumn(l.subject, (t) => t.subject, flex: 3),
        EntityColumn(
          l.customer,
          (t) =>
              t.customerName ??
              (t.contactName.isEmpty ? t.contactEmail : t.contactName),
          flex: 2,
        ),
        EntityColumn(l.category, (t) => l.ticketCategory(t.category)),
        EntityColumn(l.status, (t) => l.ticketStatus(t.status)),
        EntityColumn(l.priority, (t) => l.ticketPriority(t.priority)),
        EntityColumn(l.owner, (t) => t.ownerName ?? '—'),
        EntityColumn(l.updated, (t) => date(t.updatedAt)),
      ],
      createLabel: l.newTicket,
      onCreate: perms.contains('helpdesk.write')
          ? () async {
              final created = await showDialog<TicketDetail>(
                context: context,
                builder: (_) => const NewTicketDialog(),
              );
              if (created != null && context.mounted) {
                context.push('/helpdesk/${created.ticket.id}');
              }
              return created != null;
            }
          : null,
      onOpen: (t) async =>
          await context.push<bool>('/helpdesk/${t.id}') ?? true,
    );
  }
}

/// A ticket for a phone call, visit or internal question.
class NewTicketDialog extends ConsumerStatefulWidget {
  const NewTicketDialog({super.key});

  @override
  ConsumerState<NewTicketDialog> createState() => _NewTicketDialogState();
}

class _NewTicketDialogState extends ConsumerState<NewTicketDialog> {
  final _subject = TextEditingController();
  final _contactName = TextEditingController();
  final _contactEmail = TextEditingController();
  final _body = TextEditingController();
  Customer? _customer;
  List<Contact> _contacts = [];
  Contact? _contact;
  String _category = 'question';
  String? _language;
  bool _internal = false;
  String? _error;

  Future<void> _customerSelected(Customer c) async {
    setState(() {
      _customer = c;
      _contact = null;
      _contacts = [];
      _language ??= c.language;
      if (_contactEmail.text.isEmpty) _contactEmail.text = c.email ?? '';
    });
    final people = await ref
        .read(apiProvider)
        .crm
        .listCustomerContacts(id: c.id)
        .then((p) => p, onError: (Object _) => <Contact>[]);
    if (mounted && _customer?.id == c.id) setState(() => _contacts = people);
  }

  /// A known person brings their name, address and the language to write in.
  void _contactSelected(Contact? c) => setState(() {
    _contact = c;
    if (c != null) {
      _contactName.text = c.fullName;
      _contactEmail.text = c.emails.isEmpty ? '' : c.emails.first.email;
      _language = c.effectiveLanguage;
    }
  });

  Future<void> _save() async {
    try {
      final d = await ref
          .read(apiProvider)
          .helpdesk
          .createTicket(
            body: NewTicketInput(
              subject: _subject.text.trim(),
              body: _body.text.trim(),
              customerId: _customer?.id,
              contactId: _contact?.id,
              contactName: _contactName.text.trim(),
              contactEmail: _contactEmail.text.trim(),
              category: _category,
              language: _language,
              internal: _internal,
            ),
          );
      if (mounted) Navigator.pop(context, d);
    } catch (e) {
      setState(() => _error = errorMessage(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    const gap = SizedBox(height: 12, width: 12);
    return AlertDialog(
      title: Text(l.newTicket),
      content: SizedBox(
        width: 560,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _subject,
                decoration: InputDecoration(labelText: l.subject),
              ),
              gap,
              SearchPicker<Customer>(
                label: l.customerOptional,
                display: (c) => '${c.code} · ${c.name}',
                search: (q) async =>
                    (await ref
                            .read(apiProvider)
                            .crm
                            .listCustomers(q: q, limit: 20))
                        .items,
                onSelected: _customerSelected,
              ),
              if (_contacts.isNotEmpty) ...[
                gap,
                DropdownButtonFormField<String?>(
                  isExpanded: true,
                  key: ValueKey('contact-${_contact?.id}'),
                  initialValue: _contact?.id,
                  decoration: InputDecoration(labelText: l.contactPerson),
                  items: [
                    DropdownMenuItem<String?>(
                      value: null,
                      child: Text(l.noContactLinked),
                    ),
                    for (final c in _contacts)
                      DropdownMenuItem<String?>(
                        value: c.id,
                        child: Text(
                          '${c.fullName} · ${languageName(c.effectiveLanguage)}',
                        ),
                      ),
                  ],
                  onChanged: (id) => _contactSelected(
                    id == null ? null : _contacts.firstWhere((c) => c.id == id),
                  ),
                ),
              ],
              gap,
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _contactName,
                      decoration: InputDecoration(labelText: l.contactName),
                    ),
                  ),
                  gap,
                  Expanded(
                    child: TextField(
                      controller: _contactEmail,
                      decoration: InputDecoration(labelText: l.email),
                    ),
                  ),
                ],
              ),
              gap,
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: _category,
                      decoration: InputDecoration(labelText: l.category),
                      items: [
                        for (final c in ticketCategories)
                          DropdownMenuItem(
                            value: c,
                            child: Text(l.ticketCategory(c)),
                          ),
                      ],
                      onChanged: (v) => setState(() => _category = v!),
                    ),
                  ),
                  gap,
                  SizedBox(
                    width: 160,
                    child: DropdownButtonFormField<String?>(
                      isExpanded: true,
                      key: ValueKey(_language),
                      initialValue: _language,
                      decoration: InputDecoration(labelText: l.language),
                      items: [
                        DropdownMenuItem<String?>(
                          value: null,
                          child: Text(l.automatic),
                        ),
                        for (final c in languageCodes)
                          DropdownMenuItem<String?>(
                            value: c,
                            child: Text(languageName(c)),
                          ),
                      ],
                      onChanged: (v) => setState(() => _language = v),
                    ),
                  ),
                ],
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l.internalTicket),
                subtitle: Text(l.internalTicketHelp),
                value: _internal,
                onChanged: (v) => setState(() => _internal = v ?? false),
              ),
              TextField(
                controller: _body,
                maxLines: 5,
                decoration: InputDecoration(labelText: l.whatWasAsked),
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
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.cancel),
        ),
        FilledButton(onPressed: _save, child: Text(l.create)),
      ],
    );
  }
}
