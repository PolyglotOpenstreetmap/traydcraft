import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/api.dart';
import '../../shared/format.dart';

/// Shows the customer form; returns true when saved.
Future<bool?> showCustomerForm(
  BuildContext context, {
  Customer? customer,
  bool readOnly = false,
}) => showDialog<bool>(
  context: context,
  builder: (_) => CustomerForm(customer: customer, readOnly: readOnly),
);

class CustomerForm extends ConsumerStatefulWidget {
  const CustomerForm({super.key, this.customer, this.readOnly = false});

  final Customer? customer;
  final bool readOnly;

  @override
  ConsumerState<CustomerForm> createState() => _CustomerFormState();
}

class _CustomerFormState extends ConsumerState<CustomerForm> {
  final _form = GlobalKey<FormState>();
  late final c = widget.customer;
  late final _code = TextEditingController(text: c?.code);
  late final _name = TextEditingController(text: c?.name);
  late final _vat = TextEditingController(text: c?.vatNumber);
  late final _email = TextEditingController(text: c?.email);
  late final _phone = TextEditingController(text: c?.phone);
  late final _street = TextEditingController(text: c?.street);
  late final _postal = TextEditingController(text: c?.postalCode);
  late final _city = TextEditingController(text: c?.city);
  late final _country = TextEditingController(text: c?.countryCode ?? 'BE');
  late final _discount = TextEditingController(
    text: number(c?.discountPercent ?? '0'),
  );
  late final _terms = TextEditingController(
    text: '${c?.paymentTermsDays ?? 30}',
  );
  late String _language = c?.language ?? 'nl';
  late String? _zoneId = c?.priceZoneId;
  bool _saving = false;
  String? _error;

  String? _nn(TextEditingController t) =>
      t.text.trim().isEmpty ? null : t.text.trim();

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final input = CustomerInput(
      code: _code.text.trim(),
      name: _name.text.trim(),
      vatNumber: _nn(_vat),
      email: _nn(_email),
      phone: _nn(_phone),
      street: _street.text.trim(),
      postalCode: _postal.text.trim(),
      city: _city.text.trim(),
      countryCode: _country.text.trim().toUpperCase(),
      language: _language,
      priceZoneId: _zoneId!,
      discountPercent: parseDecimalInput(_discount.text) ?? '0',
      paymentTermsDays: int.parse(_terms.text.trim()),
    );
    try {
      final crm = ref.read(apiProvider).crm;
      if (c == null) {
        await crm.createCustomer(body: input);
      } else {
        await crm.updateCustomer(id: c!.id, body: input);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      setState(() => _error = errorMessage(e));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget _field(
    TextEditingController t,
    String label, {
    bool required = false,
    String? Function(String)? check,
  }) => TextFormField(
    controller: t,
    readOnly: widget.readOnly,
    decoration: InputDecoration(labelText: label),
    validator: (v) {
      final s = (v ?? '').trim();
      if (required && s.isEmpty) return 'Required';
      return check?.call(s);
    },
  );

  @override
  Widget build(BuildContext context) {
    final zones = ref.watch(priceZonesProvider);
    const gap = SizedBox(width: 12, height: 12);
    return AlertDialog(
      title: Text(c == null ? 'New customer' : c!.name),
      content: SizedBox(
        width: 560,
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 140,
                      child: _field(_code, 'Code', required: true),
                    ),
                    gap,
                    Expanded(child: _field(_name, 'Name', required: true)),
                  ],
                ),
                gap,
                Row(
                  children: [
                    Expanded(child: _field(_vat, 'VAT number')),
                    gap,
                    Expanded(child: _field(_email, 'E-mail')),
                    gap,
                    Expanded(child: _field(_phone, 'Phone')),
                  ],
                ),
                gap,
                _field(_street, 'Street'),
                gap,
                Row(
                  children: [
                    SizedBox(width: 110, child: _field(_postal, 'Postal code')),
                    gap,
                    Expanded(child: _field(_city, 'City')),
                    gap,
                    SizedBox(
                      width: 80,
                      child: _field(
                        _country,
                        'Country',
                        check: (s) => s.length == 2 ? null : '2 letters',
                      ),
                    ),
                    gap,
                    SizedBox(
                      width: 110,
                      child: DropdownButtonFormField<String>(
                        initialValue: _language,
                        decoration: const InputDecoration(
                          labelText: 'Language',
                        ),
                        items: const [
                          DropdownMenuItem(value: 'nl', child: Text('NL')),
                          DropdownMenuItem(value: 'fr', child: Text('FR')),
                          DropdownMenuItem(value: 'en', child: Text('EN')),
                        ],
                        onChanged: widget.readOnly
                            ? null
                            : (v) => setState(() => _language = v!),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: zones.when(
                        data: (list) => DropdownButtonFormField<String>(
                          initialValue: _zoneId,
                          decoration: const InputDecoration(
                            labelText: 'Price zone',
                          ),
                          items: [
                            for (final z in list)
                              DropdownMenuItem(
                                value: z.id,
                                child: Text('${z.code} – ${z.name}'),
                              ),
                          ],
                          onChanged: widget.readOnly
                              ? null
                              : (v) => setState(() => _zoneId = v),
                          validator: (v) => v == null ? 'Required' : null,
                        ),
                        loading: () => const LinearProgressIndicator(),
                        error: (e, _) => Text(errorMessage(e)),
                      ),
                    ),
                    gap,
                    SizedBox(
                      width: 110,
                      child: _field(
                        _discount,
                        'Discount %',
                        check: (s) =>
                            parseDecimalInput(s.isEmpty ? '0' : s) == null
                            ? 'Number'
                            : null,
                      ),
                    ),
                    gap,
                    SizedBox(
                      width: 120,
                      child: _field(
                        _terms,
                        'Payment days',
                        check: (s) => int.tryParse(s) == null ? 'Number' : null,
                      ),
                    ),
                  ],
                ),
                if (_error != null) ...[
                  gap,
                  Text(
                    _error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(widget.readOnly ? 'Close' : 'Cancel'),
        ),
        if (!widget.readOnly)
          FilledButton(
            onPressed: _saving ? null : _save,
            child: const Text('Save'),
          ),
      ],
    );
  }
}
