import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/api.dart';
import '../../l10n/l10n.dart';
import '../../shared/actions.dart';
import '../../shared/format.dart';
import '../../shared/search_picker.dart';
import '../customers/customer_form.dart';
import '../repairs/repairs_page.dart' show showNewRepairDialog;
import 'call_dialogs.dart';
import 'tickets_page.dart';

final usersProvider = FutureProvider<List<CompanyUser>>(
  (ref) => ref.watch(apiProvider).core.listUsers(),
);

/// One ticket: the conversation, a composer for replies and internal notes (with prepared answers
/// in the ticket's language), the ticket's properties and links, and the actions on it.
class TicketScreen extends ConsumerStatefulWidget {
  const TicketScreen({super.key, required this.id});
  final String id;

  @override
  ConsumerState<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends ConsumerState<TicketScreen> {
  TicketDetail? _d;
  String? _error;
  bool _busy = false;

  // Properties.
  final _subject = TextEditingController();
  final _contactName = TextEditingController();
  final _contactEmail = TextEditingController();
  String _status = 'open';
  String _priority = 'normal';
  String _category = 'question';
  String _language = 'nl';
  String? _ownerId;
  String? _customerId;
  String? _contactId;
  String? _customerName;
  String? _quotationId;
  String? _opportunityId;
  List<QuotationSummary> _quotations = [];
  List<Opportunity> _opportunities = [];
  List<Contact> _contacts = [];
  List<Repair> _repairs = [];

  // Composer.
  /// The composer mode the user chose; replying also needs the helpdesk.reply permission.
  bool _replyChosen = true;
  bool get _reply =>
      _replyChosen &&
      (ref.read(meProvider).value?.permissions.contains('helpdesk.reply') ??
          false);
  final _to = TextEditingController();
  final _cc = TextEditingController();
  final _replySubject = TextEditingController();
  final _body = TextEditingController();
  String? _statusAfter;
  String? _answerInfo;

  TraydcraftApi get _api => ref.read(apiProvider);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final d = await _api.helpdesk.getTicket(id: widget.id);
      _apply(d);
    } catch (e) {
      setState(() => _error = errorMessage(e));
    }
  }

  void _apply(TicketDetail d) {
    final t = d.ticket;
    setState(() {
      _d = d;
      _error = null;
      _subject.text = t.subject;
      _contactName.text = t.contactName;
      _contactEmail.text = t.contactEmail;
      _status = t.status;
      _priority = t.priority;
      _category = t.category;
      _language = t.language;
      _ownerId = t.ownerUserId;
      _customerId = t.customerId;
      _contactId = t.contactId;
      _customerName = t.customerName;
      _quotationId = t.quotationId;
      _opportunityId = t.opportunityId;
      if (_to.text.isEmpty) _to.text = t.contactEmail;
    });
    _loadLinks();
  }

  Future<void> _loadLinks() async {
    final c = _customerId;
    if (c == null) {
      setState(() {
        _quotations = [];
        _opportunities = [];
        _contacts = [];
        _repairs = [];
      });
      return;
    }
    final quotes = await _api.sales
        .listQuotations(customerId: c, limit: 100)
        .then((p) => p.items, onError: (Object _) => <QuotationSummary>[]);
    final opps = await _api.crm
        .listOpportunities(customerId: c, limit: 100)
        .then((p) => p.items, onError: (Object _) => <Opportunity>[]);
    final people = await _api.crm
        .listCustomerContacts(id: c)
        .then((p) => p, onError: (Object _) => <Contact>[]);
    final repairs = await _api.repairs
        .listTicketRepairs(id: widget.id)
        .then((p) => p, onError: (Object _) => <Repair>[]);
    if (mounted) {
      setState(() {
        _repairs = repairs;
        _quotations = quotes;
        _opportunities = opps;
        _contacts = people;
      });
    }
  }

  Future<void> _run(
    Future<TicketDetail> Function() action, {
    String? success,
  }) async {
    setState(() => _busy = true);
    TicketDetail? d;
    final ok = await runAction(
      context,
      () async => d = await action(),
      success: success,
    );
    if (mounted) setState(() => _busy = false);
    if (ok && d != null) _apply(d!);
  }

  Future<void> _saveProperties() => _run(
    () => _api.helpdesk.updateTicket(
      id: widget.id,
      body: TicketInput(
        subject: _subject.text.trim(),
        status: _status,
        priority: _priority,
        category: _category,
        language: _language,
        ownerUserId: _ownerId,
        customerId: _customerId,
        contactId: _contactId,
        contactName: _contactName.text.trim(),
        contactEmail: _contactEmail.text.trim(),
        quotationId: _quotationId,
        opportunityId: _opportunityId,
      ),
    ),
    success: context.l10n.saved,
  );

  Future<void> _send() async {
    final l = context.l10n;
    if (_body.text.trim().isEmpty) return;
    List<String> split(String s) =>
        s.split(RegExp(r'[,;\s]+')).where((e) => e.isNotEmpty).toList();
    await _run(
      () => _reply
          ? _api.helpdesk.reply(
              id: widget.id,
              body: ReplyInput(
                to: split(_to.text),
                cc: split(_cc.text),
                subject: _replySubject.text.trim().isEmpty
                    ? null
                    : _replySubject.text.trim(),
                body: _body.text,
                status: _statusAfter,
              ),
            )
          : _api.helpdesk.addNote(
              id: widget.id,
              body: NoteInput(body: _body.text, status: _statusAfter),
            ),
      success: _reply ? l.replyQueued : l.noteAdded,
    );
    if (_d != null) {
      setState(() {
        _body.clear();
        _replySubject.clear();
        _statusAfter = null;
        _answerInfo = null;
      });
    }
  }

  Future<void> _insertAnswer() async {
    final answer = await showDialog<PreparedAnswer>(
      context: context,
      builder: (_) => const _AnswerPicker(),
    );
    if (answer == null || !mounted) return;
    final l = context.l10n;
    try {
      final r = await _api.helpdesk.renderAnswer(
        id: widget.id,
        answerId: answer.id,
      );
      setState(() {
        if (r.subject.isNotEmpty) _replySubject.text = r.subject;
        _body.text = _body.text.trim().isEmpty
            ? r.body
            : '${_body.text.trimRight()}\n\n${r.body}';
        _answerInfo = r.fallback
            ? l.answerFallback(
                languageName(_language),
                languageName(r.language),
              )
            : null;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(errorMessage(e))));
      }
    }
  }

  Future<void> _createLead() async {
    final l = context.l10n;
    final value = await askText(
      context,
      title: l.createLead,
      label: l.expectedValueOptional,
    );
    if (value == null) return;
    await _run(
      () => _api.helpdesk.createLead(
        id: widget.id,
        body: LeadInput(expectedValue: parseDecimalInput(value)),
      ),
      success: l.leadCreated,
    );
  }

  Future<void> _convert() async {
    final l = context.l10n;
    final reference = await askText(
      context,
      title: l.convertToOrder,
      label: l.customerReference,
    );
    if (reference == null) return;
    await _run(
      () => _api.helpdesk.convert(
        id: widget.id,
        body: ConvertTicketInput(customerReference: reference),
      ),
      success: l.orderCreated,
    );
  }

  /// Links the ticket to a person of the customer: name, address and language follow.
  void _selectContact(Contact? c) {
    setState(() {
      _contactId = c?.id;
      if (c != null) {
        _contactName.text = c.fullName;
        _contactEmail.text = c.emails.isEmpty ? '' : c.emails.first.email;
        _language = c.effectiveLanguage;
      }
    });
  }

  Future<void> _logCall() async {
    final t = _d!.ticket;
    Contact? who;
    for (final c in _contacts) {
      if (c.id == _contactId) who = c;
    }
    final d = await showCallDialog(context, ticketId: t.id, contact: who);
    if (d != null && mounted) {
      _apply(d);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.callLogged)));
    }
  }

  Future<void> _newCustomer() async {
    final t = _d!.ticket;
    final c = await showNewCustomerForm(
      context,
      name: t.contactName,
      email: t.contactEmail,
      language: t.language,
    );
    if (c != null) {
      setState(() {
        _customerId = c.id;
        _customerName = c.name;
      });
      await _saveProperties();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
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
    final perms = ref.watch(meProvider).value?.permissions ?? const [];
    final wide = MediaQuery.sizeOf(context).width >= 1100;
    final conversation = _conversation(context, d, perms);
    final panel = _panel(context, d, perms);
    return Scaffold(
      body: wide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: conversation),
                const VerticalDivider(width: 1),
                SizedBox(
                  width: 380,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: panel,
                  ),
                ),
              ],
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ExpansionTile(title: Text(l.ticketDetails), children: [panel]),
                SizedBox(height: 900, child: conversation),
              ],
            ),
    );
  }

  Widget _conversation(
    BuildContext context,
    TicketDetail d,
    List<String> perms,
  ) {
    final l = context.l10n;
    final t = d.ticket;
    final theme = Theme.of(context);
    final canReply = perms.contains('helpdesk.reply');
    final canWrite = perms.contains('helpdesk.write');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 16, 16, 0),
          child: Row(
            children: [
              IconButton(
                onPressed: () => context.canPop()
                    ? context.pop(true)
                    : context.go('/helpdesk'),
                icon: const Icon(Icons.arrow_back),
              ),
              Expanded(
                child: Text(
                  '${t.number}  ${t.subject}',
                  style: theme.textTheme.titleLarge,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (canWrite && !t.internal)
                TextButton.icon(
                  onPressed: _logCall,
                  icon: const Icon(Icons.phone_in_talk_outlined),
                  label: Text(l.logCall),
                ),
              Chip(label: Text(l.ticketStatus(t.status))),
              const SizedBox(width: 8),
              Chip(
                avatar: const Icon(Icons.translate, size: 16),
                label: Text(languageName(t.language)),
              ),
            ],
          ),
        ),
        if (t.internal || t.category == 'production_question')
          MaterialBanner(
            leading: const Icon(Icons.precision_manufacturing_outlined),
            content: Text(l.internalQuestionHelp(languageName(t.language))),
            actions: const [SizedBox.shrink()],
          ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [for (final a in d.articles) _ArticleCard(article: a)],
          ),
        ),
        if (canWrite) _composer(context, canReply),
      ],
    );
  }

  Widget _composer(BuildContext context, bool canReply) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SegmentedButton<bool>(
                  segments: [
                    ButtonSegment(
                      value: true,
                      enabled: canReply,
                      icon: const Icon(Icons.mail_outline),
                      label: Text(l.replyToCustomer),
                    ),
                    ButtonSegment(
                      value: false,
                      icon: const Icon(Icons.lock_outline),
                      label: Text(l.internalNote),
                    ),
                  ],
                  selected: {_reply},
                  onSelectionChanged: (s) =>
                      setState(() => _replyChosen = s.first),
                ),
                if (_reply)
                  OutlinedButton.icon(
                    onPressed: _insertAnswer,
                    icon: const Icon(Icons.text_snippet_outlined),
                    label: Text(l.insertPreparedAnswer),
                  ),
                if (_reply)
                  Text(
                    l.writeIn(languageName(_d!.ticket.language)),
                    style: theme.textTheme.bodySmall,
                  ),
              ],
            ),
            if (_answerInfo != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  _answerInfo!,
                  style: TextStyle(color: theme.colorScheme.tertiary),
                ),
              ),
            const SizedBox(height: 8),
            if (_reply)
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _to,
                      decoration: InputDecoration(labelText: l.to),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _cc,
                      decoration: InputDecoration(labelText: l.cc),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _replySubject,
                      decoration: InputDecoration(
                        labelText: l.subject,
                        hintText: 'Re: ${_d!.ticket.subject}',
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 8),
            TextField(
              controller: _body,
              minLines: 4,
              maxLines: 12,
              decoration: InputDecoration(
                labelText: _reply ? l.message : l.internalNote,
                filled: !_reply,
                fillColor: Colors.amber.shade50,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                SizedBox(
                  width: 260,
                  child: DropdownButtonFormField<String?>(
                    isExpanded: true,
                    key: ValueKey('after-$_reply-$_statusAfter'),
                    initialValue: _statusAfter,
                    decoration: InputDecoration(labelText: l.statusAfterwards),
                    items: [
                      DropdownMenuItem<String?>(
                        value: null,
                        child: Text(
                          _reply
                              ? l.ticketStatus('pending_customer')
                              : l.unchanged,
                        ),
                      ),
                      for (final s in ticketStatuses)
                        DropdownMenuItem<String?>(
                          value: s,
                          child: Text(l.ticketStatus(s)),
                        ),
                    ],
                    onChanged: (v) => setState(() => _statusAfter = v),
                  ),
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: _busy ? null : _send,
                  icon: Icon(_reply ? Icons.send : Icons.note_add_outlined),
                  label: Text(_reply ? l.send : l.addNote),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _panel(BuildContext context, TicketDetail d, List<String> perms) {
    final l = context.l10n;
    final t = d.ticket;
    final theme = Theme.of(context);
    final canWrite = perms.contains('helpdesk.write');
    final users = ref.watch(usersProvider).value ?? const <CompanyUser>[];
    const gap = SizedBox(height: 12);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l.ticketDetails, style: theme.textTheme.titleMedium),
        gap,
        TextField(
          controller: _subject,
          decoration: InputDecoration(labelText: l.subject),
        ),
        gap,
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                initialValue: _status,
                decoration: InputDecoration(labelText: l.status),
                items: [
                  for (final s in ticketStatuses)
                    DropdownMenuItem(value: s, child: Text(l.ticketStatus(s))),
                ],
                onChanged: (v) => setState(() => _status = v!),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                initialValue: _priority,
                decoration: InputDecoration(labelText: l.priority),
                items: [
                  for (final p in ticketPriorities)
                    DropdownMenuItem(
                      value: p,
                      child: Text(l.ticketPriority(p)),
                    ),
                ],
                onChanged: (v) => setState(() => _priority = v!),
              ),
            ),
          ],
        ),
        gap,
        DropdownButtonFormField<String>(
          isExpanded: true,
          initialValue: _category,
          decoration: InputDecoration(
            labelText: l.category,
            helperText:
                t.suggestedCategory != null && t.suggestedCategory != _category
                ? l.suggested(l.ticketCategory(t.suggestedCategory!))
                : null,
          ),
          items: [
            for (final c in ticketCategories)
              DropdownMenuItem(value: c, child: Text(l.ticketCategory(c))),
          ],
          onChanged: (v) => setState(() => _category = v!),
        ),
        gap,
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                initialValue: _language,
                decoration: InputDecoration(labelText: l.customerLanguage),
                items: [
                  for (final c in languageCodes)
                    DropdownMenuItem(value: c, child: Text(languageName(c))),
                ],
                onChanged: (v) => setState(() => _language = v!),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: DropdownButtonFormField<String?>(
                isExpanded: true,
                key: ValueKey('owner-${users.length}-$_ownerId'),
                initialValue: users.any((u) => u.id == _ownerId)
                    ? _ownerId
                    : null,
                decoration: InputDecoration(labelText: l.owner),
                items: [
                  DropdownMenuItem<String?>(
                    value: null,
                    child: Text(l.unassigned),
                  ),
                  for (final u in users)
                    DropdownMenuItem<String?>(
                      value: u.id,
                      child: Text(u.displayName),
                    ),
                ],
                onChanged: (v) => setState(() => _ownerId = v),
              ),
            ),
          ],
        ),
        const Divider(height: 32),
        Text(l.customer, style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        SearchPicker<Customer>(
          key: ValueKey('cust-$_customerId'),
          label: l.customer,
          initial: null,
          display: (c) => '${c.code} · ${c.name}',
          search: (q) async =>
              (await _api.crm.listCustomers(q: q, limit: 20)).items,
          onSelected: (c) {
            setState(() {
              // The person belongs to the previous customer.
              if (c.id != _customerId) _contactId = null;
              _customerId = c.id;
              _customerName = c.name;
              _quotationId = null;
              _opportunityId = null;
            });
            _loadLinks();
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _customerName ?? l.noCustomerLinked,
                  style: theme.textTheme.bodyLarge,
                ),
              ),
              if (_customerId == null && canWrite)
                TextButton.icon(
                  onPressed: _newCustomer,
                  icon: const Icon(Icons.person_add_alt),
                  label: Text(l.newCustomer),
                ),
            ],
          ),
        ),
        if (_customerId != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: DropdownButtonFormField<String?>(
              isExpanded: true,
              key: ValueKey('contact-${_contacts.length}-$_contactId'),
              initialValue: _contacts.any((c) => c.id == _contactId)
                  ? _contactId
                  : null,
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
                      [
                        c.fullName,
                        if (c.jobTitle.isNotEmpty) c.jobTitle,
                        languageName(c.effectiveLanguage),
                      ].join(' · '),
                    ),
                  ),
              ],
              onChanged: (id) => _selectContact(
                id == null ? null : _contacts.firstWhere((c) => c.id == id),
              ),
            ),
          ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _contactName,
                decoration: InputDecoration(labelText: l.contactName),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _contactEmail,
                decoration: InputDecoration(labelText: l.email),
              ),
            ),
          ],
        ),
        gap,
        DropdownButtonFormField<String?>(
          isExpanded: true,
          key: ValueKey('q-${_quotations.length}-$_quotationId'),
          initialValue: _quotations.any((q) => q.id == _quotationId)
              ? _quotationId
              : null,
          decoration: InputDecoration(labelText: l.quotation),
          items: [
            DropdownMenuItem<String?>(value: null, child: Text(l.none)),
            for (final q in _quotations)
              DropdownMenuItem<String?>(
                value: q.id,
                child: Text(
                  '${q.number} rev. ${q.revision} · ${l.quotationStatus(q.status.json ?? '')} · ${money(q.subtotal)}',
                ),
              ),
          ],
          onChanged: (v) => setState(() => _quotationId = v),
        ),
        gap,
        DropdownButtonFormField<String?>(
          isExpanded: true,
          key: ValueKey('o-${_opportunities.length}-$_opportunityId'),
          initialValue: _opportunities.any((o) => o.id == _opportunityId)
              ? _opportunityId
              : null,
          decoration: InputDecoration(labelText: l.opportunity),
          items: [
            DropdownMenuItem<String?>(value: null, child: Text(l.none)),
            for (final o in _opportunities)
              DropdownMenuItem<String?>(
                value: o.id,
                child: Text(
                  '${o.number} · ${o.title} · ${l.opportunityStage(o.stage.json ?? '')}',
                ),
              ),
          ],
          onChanged: (v) => setState(() => _opportunityId = v),
        ),
        gap,
        if (canWrite)
          FilledButton.tonal(
            onPressed: _busy ? null : _saveProperties,
            child: Text(l.saveChanges),
          ),
        const Divider(height: 32),
        Text(l.actions, style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            // A customer who says a product is coming (or arrived) gets a repair, linked here.
            if (perms.contains('repairs.write') &&
                t.customerId != null &&
                !t.internal)
              OutlinedButton.icon(
                icon: const Icon(Icons.build_circle_outlined),
                label: Text(l.createRepair),
                onPressed: _busy
                    ? null
                    : () async {
                        final d = await showNewRepairDialog(
                          context,
                          ticketId: t.id,
                          customer: Customer.fromJson({
                            'id': t.customerId,
                            'code': '',
                            'name': t.customerName ?? '',
                            'street': '',
                            'postal_code': '',
                            'city': '',
                            'country_code': 'BE',
                            'language': t.language,
                            'active': true,
                          }),
                          contactId: t.contactId,
                          fault: t.subject,
                        );
                        if (d != null && context.mounted) {
                          await _load();
                          if (context.mounted) {
                            context.push('/repairs/${d.repair.id}');
                          }
                        }
                      },
              ),
            for (final r in _repairs)
              ActionChip(
                avatar: const Icon(Icons.build_circle_outlined, size: 18),
                label: Text('${r.number} · ${l.repairStatus(r.status)}'),
                onPressed: () => context.push('/repairs/${r.id}'),
              ),
            if (t.opportunityId != null)
              OutlinedButton.icon(
                icon: const Icon(Icons.trending_up),
                label: Text(t.opportunityNumber ?? l.opportunity),
                onPressed: () =>
                    context.push('/opportunities/${t.opportunityId}'),
              )
            else if (canWrite && perms.contains('opportunities.write'))
              OutlinedButton.icon(
                icon: const Icon(Icons.trending_up),
                label: Text(l.createLead),
                onPressed: t.customerId == null ? null : _createLead,
              ),
            if (t.quotationId != null)
              OutlinedButton.icon(
                icon: const Icon(Icons.request_quote_outlined),
                label: Text('${t.quotationNumber} rev. ${t.quotationRevision}'),
                onPressed: () async {
                  await context.push('/quotations/${t.quotationId}');
                  _load();
                },
              ),
            if (t.customerId != null && perms.contains('quotations.write'))
              OutlinedButton.icon(
                icon: const Icon(Icons.add),
                label: Text(l.newQuotation),
                onPressed: () async {
                  final opp = t.opportunityId == null
                      ? ''
                      : '&opportunity=${t.opportunityId}';
                  await context.push(
                    '/quotations/new?customer=${t.customerId}$opp',
                  );
                  _loadLinks();
                },
              ),
            if (t.orderId != null)
              OutlinedButton.icon(
                icon: const Icon(Icons.inventory_outlined),
                label: Text(t.orderNumber ?? l.order),
                onPressed: () => context.push('/orders/${t.orderId}'),
              )
            else if (t.quotationId != null && perms.contains('orders.write'))
              FilledButton.icon(
                icon: const Icon(Icons.check_circle_outline),
                label: Text(l.convertToOrder),
                onPressed: _busy ? null : _convert,
              ),
          ],
        ),
        if (t.quotationId != null && t.orderId == null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(l.convertHelp, style: theme.textTheme.bodySmall),
          ),
      ],
    );
  }
}

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({required this.article});
  final Article article;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final a = article;
    final theme = Theme.of(context);
    final when = DateFormat('dd/MM/yyyy HH:mm').format(a.createdAt.toLocal());
    final (
      Color color,
      IconData icon,
      String label,
      Alignment align,
    ) = switch (a.kind) {
      'email_in' => (
        theme.colorScheme.surfaceContainerHighest,
        Icons.call_received,
        a.fromName.isEmpty ? a.fromAddress : '${a.fromName} <${a.fromAddress}>',
        Alignment.centerLeft,
      ),
      'email_out' => (
        theme.colorScheme.primaryContainer,
        Icons.call_made,
        '${a.authorName ?? a.fromName} → ${a.toAddresses.join(', ')}',
        Alignment.centerRight,
      ),
      'call_in' || 'call_out' => (
        a.kind == 'call_in'
            ? theme.colorScheme.surfaceContainerHighest
            : theme.colorScheme.primaryContainer,
        a.kind == 'call_in' ? Icons.phone_callback : Icons.phone_forwarded,
        [
          a.kind == 'call_in' ? l.callIncoming : l.callOutgoing,
          if (a.contactName != null) a.contactName!,
          if (a.authorName != null) a.authorName!,
        ].join(' · '),
        a.kind == 'call_in' ? Alignment.centerLeft : Alignment.centerRight,
      ),
      'portal_in' => (
        theme.colorScheme.surfaceContainerHighest,
        Icons.language,
        '${a.contactName ?? a.fromName} · ${l.viaPortal}',
        Alignment.centerLeft,
      ),
      _ => (
        Colors.amber.shade100,
        Icons.lock_outline,
        '${l.internalNote} · ${a.authorName ?? ''}',
        Alignment.center,
      ),
    };
    return Align(
      alignment: align,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: Card(
          color: color,
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        label,
                        style: theme.textTheme.labelLarge,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (a.delivery != null) ...[
                      Icon(
                        switch (a.delivery) {
                          'sent' => Icons.done_all,
                          'failed' => Icons.error_outline,
                          _ => Icons.schedule,
                        },
                        size: 16,
                        color: a.delivery == 'failed'
                            ? theme.colorScheme.error
                            : null,
                      ),
                      const SizedBox(width: 4),
                      Text(switch (a.delivery) {
                        'sent' => l.deliverySent,
                        'failed' => l.deliveryFailed,
                        _ => l.deliveryQueued,
                      }, style: theme.textTheme.bodySmall),
                      const SizedBox(width: 8),
                    ],
                    Text(when, style: theme.textTheme.bodySmall),
                  ],
                ),
                if (a.subject.isNotEmpty && a.kind != 'note')
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(a.subject, style: theme.textTheme.titleSmall),
                  ),
                if (a.phoneNumber != null || a.durationSeconds != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      [
                        if (a.phoneNumber != null) a.phoneNumber!,
                        if (a.durationSeconds != null)
                          l.minutesShort(
                            (a.durationSeconds! / 60).ceil().toString(),
                          ),
                      ].join('  ·  '),
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                const SizedBox(height: 6),
                SelectableText(a.body),
                if (a.deliveryError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      a.deliveryError!,
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Searchable list of prepared answers; returns the chosen one.
class _AnswerPicker extends ConsumerStatefulWidget {
  const _AnswerPicker();

  @override
  ConsumerState<_AnswerPicker> createState() => _AnswerPickerState();
}

class _AnswerPickerState extends ConsumerState<_AnswerPicker> {
  String _q = '';
  late Future<List<PreparedAnswer>> _answers = ref
      .read(apiProvider)
      .helpdesk
      .listAnswers(active: true);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AlertDialog(
      title: Text(l.preparedAnswers),
      content: SizedBox(
        width: 560,
        height: 460,
        child: Column(
          children: [
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: l.search,
              ),
              onChanged: (v) => setState(() => _q = v.toLowerCase()),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: FutureBuilder<List<PreparedAnswer>>(
                future: _answers,
                builder: (context, snap) {
                  if (snap.hasError) {
                    return Center(
                      child: TextButton(
                        onPressed: () => setState(
                          () => _answers = ref
                              .read(apiProvider)
                              .helpdesk
                              .listAnswers(active: true),
                        ),
                        child: Text(errorMessage(snap.error!)),
                      ),
                    );
                  }
                  final list = (snap.data ?? const <PreparedAnswer>[])
                      .where(
                        (a) =>
                            _q.isEmpty ||
                            '${a.code} ${a.name} ${a.category ?? ''}'
                                .toLowerCase()
                                .contains(_q),
                      )
                      .toList();
                  return ListView(
                    children: [
                      for (final a in list)
                        ListTile(
                          title: Text(a.name),
                          subtitle: Text(
                            [
                              a.code,
                              if (a.category != null) a.category!,
                            ].join(' · '),
                          ),
                          trailing: Text(
                            a.texts
                                .map((t) => t.language.toUpperCase())
                                .join(' '),
                          ),
                          onTap: () => Navigator.pop(context, a),
                        ),
                    ],
                  );
                },
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
      ],
    );
  }
}
