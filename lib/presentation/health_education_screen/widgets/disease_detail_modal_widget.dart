import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../services/openai_service.dart';

class DiseaseDetailModalWidget extends StatefulWidget {
  final Map<String, dynamic> disease;
  final bool isBookmarked;
  final VoidCallback onBookmarkToggle;

  const DiseaseDetailModalWidget({
    super.key,
    required this.disease,
    required this.isBookmarked,
    required this.onBookmarkToggle,
  });

  @override
  State<DiseaseDetailModalWidget> createState() =>
      _DiseaseDetailModalWidgetState();
}

class _DiseaseDetailModalWidgetState extends State<DiseaseDetailModalWidget> {
  bool _isTextToSpeechPlaying = false;
  bool _isLoadingAIAdvice = false;
  String? _aiAdvice;
  final OpenAIClient _openAIClient = OpenAIClient(OpenAIService().dio);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.85,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.disease['name'] ?? '',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: widget.onBookmarkToggle,
                  icon: Icon(
                    widget.isBookmarked
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    color: widget.isBookmarked
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                IconButton(
                  onPressed: _toggleTextToSpeech,
                  icon: Icon(
                    _isTextToSpeechPlaying ? Icons.stop : Icons.volume_up,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  _buildSection(
                    title: 'Description',
                    content: widget.disease['description'] ?? '',
                    theme: theme,
                  ),

                  SizedBox(height: 20.h),

                  // Severity and Prevalence
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          title: 'Severity',
                          value: widget.disease['severity']?.toUpperCase() ??
                              'N/A',
                          color: _getSeverityColor(widget.disease['severity']),
                          theme: theme,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildInfoCard(
                          title: 'Prevalence',
                          value: widget.disease['prevalence'] ?? 'N/A',
                          color: theme.colorScheme.primary,
                          theme: theme,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  // Symptoms
                  _buildListSection(
                    title: 'Symptoms',
                    items: widget.disease['symptoms'] as List? ?? [],
                    icon: Icons.medical_services_outlined,
                    theme: theme,
                  ),

                  SizedBox(height: 20.h),

                  // Prevention
                  _buildListSection(
                    title: 'Prevention',
                    items: widget.disease['prevention'] as List? ?? [],
                    icon: Icons.shield_outlined,
                    theme: theme,
                  ),

                  SizedBox(height: 20.h),

                  // Vaccine Information
                  if (widget.disease['vaccine'] != null)
                    _buildSection(
                      title: 'Vaccine',
                      content: widget.disease['vaccine'],
                      theme: theme,
                      icon: Icons.vaccines_outlined,
                    ),

                  SizedBox(height: 20.h),

                  // AI Advice Section
                  _buildAIAdviceSection(theme),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    required ThemeData theme,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 20.w,
                color: theme.colorScheme.primary,
              ),
              SizedBox(width: 8.w),
            ],
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Text(
            content,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildListSection({
    required String title,
    required List items,
    required IconData icon,
    required ThemeData theme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 20.w,
              color: theme.colorScheme.primary,
            ),
            SizedBox(width: 8.w),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: items
                .map((item) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 6.w,
                            height: 6.w,
                            margin: EdgeInsets.only(top: 6.h, right: 8.w),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              item.toString(),
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required Color color,
    required ThemeData theme,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIAdviceSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.psychology_outlined,
              size: 20.w,
              color: theme.colorScheme.primary,
            ),
            SizedBox(width: 8.w),
            Text(
              'AI Health Advice',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacer(),
            TextButton.icon(
              onPressed: _isLoadingAIAdvice ? null : _getAIAdvice,
              icon: _isLoadingAIAdvice
                  ? SizedBox(
                      width: 16.w,
                      height: 16.w,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(Icons.auto_awesome),
              label: Text(_isLoadingAIAdvice ? 'Generating...' : 'Get Advice'),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: _aiAdvice != null
              ? Text(
                  _aiAdvice!,
                  style: theme.textTheme.bodyMedium,
                )
              : Text(
                  'Tap "Get Advice" to receive personalized AI-powered health recommendations for ${widget.disease['name']}.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
        ),
      ],
    );
  }

  Color _getSeverityColor(String? severity) {
    final theme = Theme.of(context);
    switch (severity?.toLowerCase()) {
      case 'high':
        return theme.colorScheme.error;
      case 'medium':
        return Colors.orange;
      case 'low':
        return theme.colorScheme.tertiary;
      default:
        return theme.colorScheme.onSurfaceVariant;
    }
  }

  void _toggleTextToSpeech() {
    setState(() {
      _isTextToSpeechPlaying = !_isTextToSpeechPlaying;
    });

    if (_isTextToSpeechPlaying) {
      // Simulate TTS playback
      HapticFeedback.selectionClick();
      Future.delayed(Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _isTextToSpeechPlaying = false;
          });
        }
      });
    }
  }

  Future<void> _getAIAdvice() async {
    setState(() {
      _isLoadingAIAdvice = true;
    });

    try {
      final prompt = '''
      Provide brief health advice for ${widget.disease['name']}. 
      Include:
      - When to seek medical attention
      - Lifestyle recommendations
      - Prevention tips specific to India
      
      Keep it under 150 words and medically accurate.
      ''';

      final response = await _openAIClient.createChatCompletion(
        messages: [Message(role: 'user', content: prompt)],
        options: {
          'max_tokens': 150,
          'temperature': 0.3,
        },
      );

      setState(() {
        _aiAdvice = response.text;
        _isLoadingAIAdvice = false;
      });
    } catch (e) {
      setState(() {
        _aiAdvice =
            'Unable to generate AI advice at the moment. Please try again later or consult with a healthcare professional for personalized guidance.';
        _isLoadingAIAdvice = false;
      });
    }
  }
}