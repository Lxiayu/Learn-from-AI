import '../../../shared/models/chat_session_models.dart';

class LoadedChatSession {
  const LoadedChatSession({
    required this.sessionId,
    required this.state,
  });

  final String sessionId;
  final ChatSessionState state;
}
