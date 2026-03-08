import 'package:care_link/features/chatbot/models/chat_message_model.dart';

abstract class ChatBotState {
  final List<ChatMessage> messages;
  const ChatBotState(this.messages);
}

class ChatBotInitial extends ChatBotState {
  const ChatBotInitial() : super(const []);
}

class ChatBotLoading extends ChatBotState {
  const ChatBotLoading(super.messages);
}

class ChatBotSuccess extends ChatBotState {
  const ChatBotSuccess(super.messages);
}

class ChatBotError extends ChatBotState {
  final String error;
  const ChatBotError(super.messages, this.error);
}








