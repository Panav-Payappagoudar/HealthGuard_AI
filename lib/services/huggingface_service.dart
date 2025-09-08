import 'dart:async';

import 'package:dio/dio.dart';

class HuggingFaceService {
  static final HuggingFaceService _instance = HuggingFaceService._internal();
  late final Dio _dio;
  static const String apiKey = String.fromEnvironment('HUGGINGFACE_API_KEY');

  factory HuggingFaceService() {
    return _instance;
  }

  HuggingFaceService._internal() {
    _initializeService();
  }

  void _initializeService() {
    if (apiKey.isEmpty) {
      throw Exception('HUGGINGFACE_API_KEY must be provided via --dart-define');
    }

    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api-inference.huggingface.co',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 60),
      ),
    );
  }

  Dio get dio => _dio;
}

class HuggingFaceClient {
  final Dio dio;
  final String modelId;

  HuggingFaceClient(
    this.dio, {
    this.modelId = 'BioMistral/BioMistral-7B',
  });

  Future<HuggingFaceCompletion> generateChatCompletion({
    required List<ChatTurn> conversation,
    Map<String, dynamic>? parameters,
    int maxRetries = 2,
  }) async {
    final prompt = _buildPrompt(conversation);

    final body = {
      'inputs': prompt,
      'parameters': {
        'max_new_tokens': 512,  // Increased token limit for more comprehensive medical responses
        'temperature': 0.2,     // Lower temperature for more factual medical information
        'top_p': 0.92,         // Slightly adjusted for more focused responses
        'do_sample': true,
        'return_full_text': false,
        'repetition_penalty': 1.1,  // Prevent repetitive text in medical explanations
        if (parameters != null) ...parameters,
      },
      'options': {
        // Faster, non-streaming, wait for the model to load if sleeping
        'wait_for_model': true,
      },
    };

    int attempt = 0;
    while (true) {
      attempt += 1;
      try {
        final response = await dio.post(
          '/models/$modelId',
          data: body,
        );

        // HF Inference returns a list
        if (response.data is List && response.data.isNotEmpty) {
          final generated = response.data[0]['generated_text'] as String?;
          if (generated != null && generated.trim().isNotEmpty) {
            final cleaned = _postProcess(generated);
            return HuggingFaceCompletion(text: cleaned);
          }
        }
        throw const HuggingFaceException(
          statusCode: 500,
          message: 'Empty response from Hugging Face Inference API',
        );
      } on DioException catch (e) {
        final status = e.response?.statusCode ?? 500;
        // Model loading (503) or rate limiting (429): small retry with backoff
        if ((status == 503 || status == 429) && attempt <= maxRetries) {
          await Future.delayed(Duration(milliseconds: 800 * attempt));
          continue;
        }
        final msg = e.response?.data is Map
            ? ((e.response?.data['error'] ?? e.message) as String? ?? 'Unknown')
            : (e.message ?? 'Unknown');
        throw HuggingFaceException(statusCode: status, message: msg);
      }
    }
  }

  String _buildPrompt(List<ChatTurn> conversation) {
    final systemPreamble =
        'You are a helpful medical information assistant powered by BioMistral, a specialized AI model trained on medical literature. '
        'You provide evidence-based health information from reliable medical sources. '
        'Always include a short disclaimer that you are not a substitute for professional medical advice, '
        'and advise users to consult qualified clinicians for diagnosis or treatment. '
        'If the query indicates an emergency, instruct the user to seek immediate local emergency care. '
        'When discussing medical topics, cite general medical consensus where appropriate.';

    final buffer = StringBuffer();
    buffer.writeln(systemPreamble);
    buffer.writeln('\nConversation:');
    for (final turn in conversation) {
      final role = turn.isUser ? 'User' : 'Assistant';
      buffer.writeln('$role: ${turn.content}');
    }
    buffer.write('Assistant:');
    return buffer.toString();
  }

  String _postProcess(String text) {
    // Remove potential prompt echoes before "Assistant:"
    final idx = text.lastIndexOf('Assistant:');
    if (idx >= 0) {
      return text.substring(idx + 'Assistant:'.length).trim();
    }
    return text.trim();
  }
}

class ChatTurn {
  final bool isUser;
  final String content;

  ChatTurn({required this.isUser, required this.content});
}

class HuggingFaceCompletion {
  final String text;

  HuggingFaceCompletion({required this.text});
}

class HuggingFaceException implements Exception {
  final int statusCode;
  final String message;
  const HuggingFaceException({required this.statusCode, required this.message});

  @override
  String toString() => 'HuggingFaceException: $statusCode - $message';
}


