import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/api.dart';
import '../../app/session.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late final _server = TextEditingController(
    text: ref.read(sessionProvider).serverUrl,
  );
  final _user = TextEditingController(text: 'sales@example.com');
  final _token = TextEditingController();
  bool _useToken = false;
  bool _busy = false;
  String? _error;

  Future<void> _signIn() async {
    final session = Session(
      serverUrl: _server.text.trim(),
      devUser: _useToken ? null : _user.text.trim(),
      accessToken: _useToken ? _token.text.trim() : null,
    );
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      // Verify the credentials before storing them.
      final probe = ProviderContainer(
        overrides: [initialSessionProvider.overrideWithValue(session)],
      );
      try {
        await probe.read(apiProvider).core.me();
      } finally {
        probe.dispose();
      }
      await ref.read(sessionProvider.notifier).signIn(session);
    } catch (e) {
      setState(() => _error = errorMessage(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'traydcraft',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _server,
                    decoration: const InputDecoration(labelText: 'Server'),
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment(
                        value: false,
                        label: Text('Development user'),
                      ),
                      ButtonSegment(value: true, label: Text('Access token')),
                    ],
                    selected: {_useToken},
                    onSelectionChanged: (s) =>
                        setState(() => _useToken = s.first),
                  ),
                  const SizedBox(height: 12),
                  if (_useToken)
                    TextField(
                      controller: _token,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'OIDC access token',
                      ),
                    )
                  else
                    TextField(
                      controller: _user,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        helperText: 'Server must run with AUTH_MODE=dev',
                      ),
                      onSubmitted: (_) => _signIn(),
                    ),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: _busy ? null : _signIn,
                    child: const Text('Sign in'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
