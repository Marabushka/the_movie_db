import 'package:the_movie_db/domain/data_providers/session_data_provider.dart';

class MyAppModel {
  final _sessionProvider = SessionDataProvider();
  var _isAuth = false;
  bool get isAuth => _isAuth;

  Future<void> checkAuth() async {
    final sessionId = await _sessionProvider.getSessionId();
    _isAuth = sessionId != null;
  }
}
