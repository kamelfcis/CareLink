import 'dart:typed_data';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static const String _systemPrompt = '''
You are CareLink AI, a friendly and knowledgeable medical assistant integrated into the CareLink healthcare app.

Your role:
- Answer medical inquiries clearly and accurately.
- Explain medications, lab results, symptoms, chronic conditions, allergies, vaccinations, and surgeries in simple language.
- Provide general health tips and wellness advice.
- Help users understand their medical records.
- Analyze medical images such as lab test results, MRI scans, X-rays, prescriptions, and other medical documents when provided.

Guidelines:
- Always be empathetic, professional, and supportive.
- Use clear, simple language that patients can understand.
- When a question is beyond your scope or requires urgent attention, advise the user to consult their doctor or call emergency services.
- Never diagnose conditions or prescribe medications — always recommend professional consultation for specific medical decisions.
- Keep responses concise but thorough.
- Use bullet points and formatting when listing information.
- If the user asks something unrelated to health/medicine, politely redirect them to medical topics.
- When analyzing medical images, describe what you observe and explain the results in simple terms, but always remind the user to confirm with their healthcare provider.
''';

  late final GenerativeModel _model;
  ChatSession? _chatSession;

  GeminiService() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('Missing GEMINI_API_KEY in .env');
    }

    final modelId = dotenv.env['GEMINI_MODEL']?.trim();
    final resolvedModel = (modelId != null && modelId.isNotEmpty)
        ? modelId
        : 'gemini-2.5-flash';

    _model = GenerativeModel(
      model: resolvedModel,
      apiKey: apiKey,
      systemInstruction: Content.system(_systemPrompt),
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 1024,
      ),
    );
  }

  Future<String> sendMessage(String message) async {
    _chatSession ??= _model.startChat();

    try {
      final response = await _chatSession!.sendMessage(
        Content.text(message),
      );
      try {
        final text = response.text;
        if (text == null || text.trim().isEmpty) {
          return 'Sorry, I could not generate a response.';
        }
        return text;
      } on GenerativeAIException catch (e) {
        // Blocked by safety filters, recitation, etc.
        return e.message;
      }
    } catch (e) {
      throw Exception('Failed to get response: $e');
    }
  }

  Future<String> sendMessageWithImage({
    required Uint8List imageBytes,
    String? message,
  }) async {
    _chatSession ??= _model.startChat();

    try {
      final prompt = message?.trim().isNotEmpty == true
          ? message!
          : 'Please analyze this medical image and explain what you see.';

      final content = Content.multi([
        TextPart(prompt),
        DataPart('image/jpeg', imageBytes),
      ]);

      final response = await _chatSession!.sendMessage(content);
      try {
        final text = response.text;
        if (text == null || text.trim().isEmpty) {
          return 'Sorry, I could not analyze the image.';
        }
        return text;
      } on GenerativeAIException catch (e) {
        return e.message;
      }
    } catch (e) {
      throw Exception('Failed to analyze image: $e');
    }
  }

  void resetChat() {
    _chatSession = null;
  }
}
