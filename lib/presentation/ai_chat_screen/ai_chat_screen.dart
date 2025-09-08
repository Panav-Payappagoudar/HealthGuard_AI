import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/chat_input_widget.dart';
import './widgets/chat_message_widget.dart';
import './widgets/offline_indicator_widget.dart';
import './widgets/quick_action_buttons_widget.dart';
import './widgets/typing_indicator_widget.dart';
import '../../services/huggingface_service.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;
  bool _isOnline = true;
  bool _showQuickActions = true;
  int _currentBottomIndex = 2; // AI Chat tab
  late final HuggingFaceClient _hfClient;

  // Mock AI responses for different health queries
  final List<Map<String, dynamic>> _mockResponses = [
    {
      "keywords": ["symptom", "fever", "headache", "pain", "sick", "ill"],
      "response":
          "I understand you're experiencing symptoms. For fever and headache, ensure you stay hydrated, get adequate rest, and consider taking paracetamol as per dosage instructions. However, if symptoms persist for more than 2-3 days or worsen, please consult a healthcare professional immediately. Would you like me to help you find nearby doctors or hospitals?"
    },
    {
      "keywords": ["medicine", "medication", "drug", "tablet", "dosage"],
      "response":
          "I can provide general information about medications, but please remember that I cannot replace professional medical advice. Always consult with a qualified doctor or pharmacist before starting, stopping, or changing any medication. What specific medicine would you like to know about? I can share general information about common medications used in India."
    },
    {
      "keywords": ["doctor", "hospital", "clinic", "appointment"],
      "response":
          "I can help you find healthcare providers in your area. For immediate assistance, you can contact:\n\n• Apollo Hospitals: 1860-500-1066\n• Fortis Healthcare: 1800-102-4444\n• Max Healthcare: 1800-120-4444\n\nFor government hospitals, dial 102 for ambulance services. Would you like me to help you with specific specialties or locations?"
    },
    {
      "keywords": ["emergency", "urgent", "help", "ambulance", "911", "102"],
      "response":
          "For medical emergencies in India, please call:\n\n🚨 Ambulance: 102 or 108\n🚨 Police: 100\n🚨 Fire: 101\n\nIf this is a life-threatening emergency, please call immediately. For mental health crisis, contact: 1800-599-0019 (KIRAN Helpline). I can also help you find the nearest hospital. Stay calm and seek immediate professional help."
    },
    {
      "keywords": ["covid", "coronavirus", "vaccine", "vaccination"],
      "response":
          "For COVID-19 related information:\n\n• Helpline: 1075 (Ministry of Health)\n• Vaccination: Visit CoWIN portal or nearby vaccination centers\n• Symptoms: Fever, cough, difficulty breathing, loss of taste/smell\n\nIf you suspect COVID-19, isolate yourself and get tested. Follow government guidelines and consult healthcare providers for proper guidance."
    },
    {
      "keywords": ["diet", "nutrition", "food", "healthy", "weight"],
      "response":
          "A balanced Indian diet should include:\n\n• Whole grains (brown rice, wheat, millets)\n• Pulses and legumes (dal, rajma, chana)\n• Fresh vegetables and fruits\n• Dairy products (milk, yogurt)\n• Healthy fats (nuts, seeds, olive oil)\n\nStay hydrated with 8-10 glasses of water daily. Limit processed foods, excess sugar, and salt. For personalized diet plans, consult a qualified nutritionist."
    }
  ];

  @override
  void initState() {
    super.initState();
    _hfClient = HuggingFaceClient(HuggingFaceService().dio);
    _initializeChat();
    _checkConnectivity();
    _loadCachedMessages();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeChat() {
    // Add welcome message
    _messages.add({
      'message':
          'Hello! I\'m your AI health assistant powered by BioMistral. I can help you with health queries, symptom checking, finding doctors, and emergency assistance. I\'m trained on medical literature to provide evidence-based information. How can I help you today?',
      'isUser': false,
      'timestamp': DateTime.now(),
      'model': 'BioMistral',
    });
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isOnline = connectivityResult != ConnectivityResult.none;
    });

    // Listen for connectivity changes
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _isOnline = result != ConnectivityResult.none;
      });
    });
  }

  Future<void> _loadCachedMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedMessages = prefs.getString('ai_chat_messages');
      if (cachedMessages != null) {
        final List<dynamic> messageList = json.decode(cachedMessages);
        setState(() {
          _messages.clear();
          _messages.addAll(messageList
              .map((msg) => {
                    'message': msg['message'] as String,
                    'isUser': msg['isUser'] as bool,
                    'timestamp': DateTime.parse(msg['timestamp'] as String),
                    'model': msg['model'] as String?, // Load model information if available
                  })
              .toList());
        });
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _saveCachedMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final messageList = _messages
          .map((msg) => {
                'message': msg['message'],
                'isUser': msg['isUser'],
                'timestamp': (msg['timestamp'] as DateTime).toIso8601String(),
                'model': msg['model'], // Save model information
              })
          .toList();
      await prefs.setString('ai_chat_messages', json.encode(messageList));
    } catch (e) {
      // Handle error silently
    }
  }

  void _sendMessage(String message) {
    if (message.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'message': message,
        'isUser': true,
        'timestamp': DateTime.now(),
      });
      _isLoading = true;
      _showQuickActions = false;
    });

    _scrollToBottom();
    _generateAIResponse(message);
    _saveCachedMessages();
  }

  Future<void> _generateAIResponse(String userMessage) async {
    try {
      // Convert previous messages to chat turns for context
      final conversation = _messages
          .map((m) => ChatTurn(
                isUser: m['isUser'] as bool,
                content: m['message'] as String,
              ))
          .toList()
        ..add(ChatTurn(isUser: true, content: userMessage));

      // Determine if this is a medical query to adjust parameters
      final isMedicalQuery = _isMedicalQuery(userMessage);
      
      final completion = await _hfClient.generateChatCompletion(
        conversation: conversation,
        parameters: {
          // Adjust parameters based on query type
          'max_new_tokens': isMedicalQuery ? 512 : 256,
          'temperature': isMedicalQuery ? 0.2 : 0.3,
          'repetition_penalty': isMedicalQuery ? 1.1 : 1.0,
        },
      );

      setState(() {
        _messages.add({
          'message': completion.text,
          'isUser': false,
          'timestamp': DateTime.now(),
          'model': 'BioMistral', // Track which model generated the response
        });
        _isLoading = false;
      });
    } catch (e) {
      // Fallback to contextual canned response on error
      final response = _getContextualResponse(userMessage.toLowerCase());
      setState(() {
        _messages.add({
          'message': response,
          'isUser': false,
          'timestamp': DateTime.now(),
          'model': 'Fallback', // Indicate this is a fallback response
        });
        _isLoading = false;
      });
    }

    _scrollToBottom();
    _saveCachedMessages();
  }

  String _getContextualResponse(String message) {
    // Find matching response based on keywords
    for (final mockResponse in _mockResponses) {
      final keywords = mockResponse['keywords'] as List<String>;
      if (keywords.any((keyword) => message.contains(keyword))) {
        return mockResponse['response'] as String;
      }
    }

    // Default response for unmatched queries
    return "I understand you have a health-related question. While I can provide general health information, I recommend consulting with a qualified healthcare professional for personalized medical advice. You can:\n\n• Call 102 for medical emergencies\n• Visit your nearest hospital or clinic\n• Consult with a licensed doctor\n\nIs there something specific about your health I can help you with?";
  }
  
  bool _isMedicalQuery(String query) {
    // List of medical keywords to check against
    final medicalKeywords = [
      'symptom', 'disease', 'condition', 'treatment', 'medicine', 'drug',
      'diagnosis', 'pain', 'doctor', 'hospital', 'clinic', 'prescription',
      'health', 'medical', 'illness', 'infection', 'virus', 'bacteria',
      'chronic', 'acute', 'emergency', 'surgery', 'procedure', 'therapy',
      'cancer', 'diabetes', 'heart', 'blood', 'pressure', 'cholesterol',
      'covid', 'vaccine', 'vaccination', 'immunization', 'allergy',
      'diet', 'nutrition', 'vitamin', 'supplement', 'exercise',
      'mental health', 'depression', 'anxiety', 'stress', 'sleep',
      'pregnancy', 'pediatric', 'geriatric', 'specialist', 'referral'
    ];
    
    // Convert query to lowercase for case-insensitive matching
    final lowercaseQuery = query.toLowerCase();
    
    // Check if any medical keyword is present in the query
    return medicalKeywords.any((keyword) => lowercaseQuery.contains(keyword));
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleQuickAction(String action) {
    _sendMessage(action);
  }

  void _handleMicrophonePressed() {
    // Placeholder for speech-to-text functionality
    HapticFeedback.lightImpact();
    // In a real implementation, this would start speech recognition
  }

  void _copyMessage(String message) {
    Clipboard.setData(ClipboardData(text: message));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Message copied to clipboard'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
      ),
    );
  }

  void _shareMessage(String message) {
    // Placeholder for share functionality
    HapticFeedback.lightImpact();
    // In a real implementation, this would use the share plugin
  }

  void _generateReport() {
    // Navigate to symptom checker or generate health report
    Navigator.pushNamed(context, '/symptom-checker-screen');
  }

  void _showSettingsMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildSettingsBottomSheet(),
    );
  }

  Widget _buildSettingsBottomSheet() {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4.w),
          topRight: Radius.circular(4.w),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline,
                borderRadius: BorderRadius.circular(0.25.h),
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'settings',
                color: theme.colorScheme.onSurface,
                size: 6.w,
              ),
              title: Text(
                'Chat Settings',
                style: theme.textTheme.titleMedium,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings-screen');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'delete_outline',
                color: theme.colorScheme.error,
                size: 6.w,
              ),
              title: Text(
                'Clear Conversation',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _clearConversation();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _clearConversation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Conversation'),
        content: const Text(
            'Are you sure you want to clear all messages? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _messages.clear();
                _showQuickActions = true;
              });
              _initializeChat();
              _saveCachedMessages();
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'AI Health Assistant',
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: theme.colorScheme.onSurface,
              size: 6.w,
            ),
            onPressed: _showSettingsMenu,
          ),
        ],
      ),
      body: Column(
        children: [
          if (!_isOnline) const OfflineIndicatorWidget(),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(vertical: 2.h),
              itemCount: _messages.length +
                  (_isLoading ? 1 : 0) +
                  (_showQuickActions ? 1 : 0),
              itemBuilder: (context, index) {
                if (_showQuickActions && index == 0) {
                  return QuickActionButtonsWidget(
                    onQuickAction: _handleQuickAction,
                  );
                }

                final messageIndex = _showQuickActions ? index - 1 : index;

                if (_isLoading && messageIndex == _messages.length) {
                  return const TypingIndicatorWidget();
                }

                if (messageIndex < _messages.length) {
                  final message = _messages[messageIndex];
                  return ChatMessageWidget(
                    message: message['message'] as String,
                    isUser: message['isUser'] as bool,
                    timestamp: message['timestamp'] as DateTime,
                    model: message['model'] as String?, // Pass model information
                    onCopy: () => _copyMessage(message['message'] as String),
                    onShare: () => _shareMessage(message['message'] as String),
                    onGenerateReport: _generateReport,
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
          ChatInputWidget(
            onSendMessage: _sendMessage,
            onMicrophonePressed: _handleMicrophonePressed,
            isLoading: _isLoading,
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomIndex,
        onTap: (index) {
          setState(() {
            _currentBottomIndex = index;
          });
        },
      ),
    );
  }
}
