import 'dart:typed_data';

import 'package:care_link/core/di/dependancy_injection.dart';
import 'package:care_link/core/network/gemini/gemini_service.dart';
import 'package:care_link/features/chatbot/models/chat_message_model.dart';
import 'package:care_link/features/chatbot/view_models/cubit/chatbot_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBotCubit extends Cubit<ChatBotState> {
  ChatBotCubit() : super(const ChatBotInitial());

  final GeminiService _geminiService = getIt<GeminiService>();

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessage(text: text.trim(), isUser: true);
    final updatedMessages = [...state.messages, userMessage];

    emit(ChatBotLoading(updatedMessages));

    try {
      final response = await _geminiService.sendMessage(text.trim());
      final aiMessage = ChatMessage(text: response, isUser: false);
      emit(ChatBotSuccess([...updatedMessages, aiMessage]));
    } catch (e) {
      emit(ChatBotError(
        updatedMessages,
        'somethingWentWrong',
      ));
    }
  }

  Future<void> sendMessageWithImage({
    required Uint8List imageBytes,
    required String imagePath,
    String? text,
  }) async {
    final userMessage = ChatMessage(
      text: text?.trim().isNotEmpty == true ? text! : '',
      isUser: true,
      imagePath: imagePath,
      imageBytes: imageBytes,
    );
    final updatedMessages = [...state.messages, userMessage];

    emit(ChatBotLoading(updatedMessages));

    try {
      final response = await _geminiService.sendMessageWithImage(
        imageBytes: imageBytes,
        message: text,
      );
      final aiMessage = ChatMessage(text: response, isUser: false);
      emit(ChatBotSuccess([...updatedMessages, aiMessage]));
    } catch (e) {
      emit(ChatBotError(
        updatedMessages,
        'failedToAnalyzeImage',
      ));
    }
  }

  void resetChat() {
    _geminiService.resetChat();
    emit(const ChatBotInitial());
  }
}
