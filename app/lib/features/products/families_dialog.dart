import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/api.dart';
import '../../shared/actions.dart';

final familiesProvider = FutureProvider<List<ProductFamily>>(
  (ref) => ref.watch(apiProvider).products.listFamilies(),
);

/// Lists product families and lets product managers add or rename them.
class FamiliesDialog extends ConsumerWidget {
  const FamiliesDialog({super.key});

  Future<void> _edit(
    BuildContext context,
    WidgetRef ref, [
    ProductFamily? f,
  ]) async {
    final code = TextEditingController(text: f?.code);
    final name = TextEditingController(text: f?.name);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(f == null ? 'New family' : f.code),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: code,
              decoration: const InputDecoration(labelText: 'Code'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    final body = ProductFamilyInput(
      code: code.text.trim(),
      name: name.text.trim(),
    );
    final api = ref.read(apiProvider).products;
    await runAction(
      context,
      () => f == null
          ? api.createFamily(body: body)
          : api.updateFamily(id: f.id, body: body),
    );
    ref.invalidate(familiesProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final families = ref.watch(familiesProvider);
    final canWrite =
        ref.watch(meProvider).value?.permissions.contains('products.write') ??
        false;
    return AlertDialog(
      title: const Text('Product families'),
      content: SizedBox(
        width: 480,
        child: families.when(
          loading: () => const LinearProgressIndicator(),
          error: (e, _) => Text(errorMessage(e)),
          data: (list) => ListView(
            shrinkWrap: true,
            children: [
              for (final f in list)
                ListTile(
                  title: Text('${f.code} · ${f.name}'),
                  subtitle: Text('${f.productCount} products'),
                  trailing: canWrite
                      ? IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _edit(context, ref, f),
                        )
                      : null,
                ),
            ],
          ),
        ),
      ),
      actions: [
        if (canWrite)
          TextButton.icon(
            onPressed: () => _edit(context, ref),
            icon: const Icon(Icons.add),
            label: const Text('New family'),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
