import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Connection and identity of the signed-in user.
///
/// Two modes:
/// * development: the API runs with AUTH_MODE=dev and trusts the `X-Dev-User` e-mail;
/// * token: an OpenID Connect access token is sent as `Authorization: Bearer`.
///   (An interactive OIDC sign-in flow replaces the pasted token in a later release.)
class Session {
  const Session({
    required this.serverUrl,
    this.devUser,
    this.accessToken,
    this.companyId,
  });

  final String serverUrl;
  final String? devUser;
  final String? accessToken;
  final String? companyId;

  bool get isSignedIn =>
      (devUser?.isNotEmpty ?? false) || (accessToken?.isNotEmpty ?? false);

  Map<String, String> get headers => {
    if (devUser?.isNotEmpty ?? false) 'X-Dev-User': devUser!,
    if (accessToken?.isNotEmpty ?? false)
      'Authorization': 'Bearer $accessToken',
    'X-Company-Id': ?companyId,
  };

  static const signedOut = Session(serverUrl: 'http://localhost:8080');
}

class SessionStore {
  static const _server = 'server_url',
      _dev = 'dev_user',
      _token = 'access_token',
      _company = 'company_id';

  static Future<Session> load() async {
    final p = await SharedPreferences.getInstance();
    return Session(
      serverUrl: p.getString(_server) ?? Session.signedOut.serverUrl,
      devUser: p.getString(_dev),
      accessToken: p.getString(_token),
      companyId: p.getString(_company),
    );
  }

  static Future<void> save(Session s) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_server, s.serverUrl);
    Future<void> put(String k, String? v) =>
        v == null ? p.remove(k) : p.setString(k, v);
    await put(_dev, s.devUser);
    await put(_token, s.accessToken);
    await put(_company, s.companyId);
  }
}

/// Session read from storage at start-up (overridden in main / tests).
final initialSessionProvider = Provider<Session>((ref) => Session.signedOut);

class SessionNotifier extends Notifier<Session> {
  @override
  Session build() => ref.read(initialSessionProvider);

  Future<void> signIn(Session s) async {
    state = s;
    await SessionStore.save(s);
  }

  Future<void> signOut() async {
    state = Session(serverUrl: state.serverUrl);
    await SessionStore.save(state);
  }
}

final sessionProvider = NotifierProvider<SessionNotifier, Session>(
  SessionNotifier.new,
);
