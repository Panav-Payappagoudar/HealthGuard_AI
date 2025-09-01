import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class AnalysisResultsWidget extends StatefulWidget {
  final Map<String, dynamic> analysisResults;
  final VoidCallback onGenerateReport;
  final VoidCallback onSaveToChat;

  const AnalysisResultsWidget({
    super.key,
    required this.analysisResults,
    required this.onGenerateReport,
    required this.onSaveToChat,
  });

  @override
  State<AnalysisResultsWidget> createState() => _AnalysisResultsWidgetState();
}

class _AnalysisResultsWidgetState extends State<AnalysisResultsWidget> {
  bool _showDetailedAnalysis = false;

  Color _getRiskColor(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'low':
        return Colors.green;
      case 'moderate':
        return Colors.orange;
      case 'high':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getRiskIcon(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'low':
        return Icons.check_circle;
      case 'moderate':
        return Icons.warning;
      case 'high':
        return Icons.error;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final riskLevel = widget.analysisResults['riskLevel'] ?? 'Unknown';
    final riskColor = _getRiskColor(riskLevel);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CustomIconWidget(
                iconName: 'analytics',
                color: theme.colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'AI Analysis Results',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Risk assessment card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: riskColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: riskColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                CustomIconWidget(
                  iconName: _getRiskIcon(riskLevel).codePoint.toString(),
                  color: riskColor,
                  size: 48,
                ),
                const SizedBox(height: 12),
                Text(
                  '$riskLevel Risk Level',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: riskColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.analysisResults['summary'] ??
                      'Analysis completed successfully.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Recommended actions
          if (widget.analysisResults['recommendations'] != null) ...[
            Text(
              'Recommended Actions',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            ...(widget.analysisResults['recommendations'] as List)
                .map((recommendation) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomIconWidget(
                          iconName: 'lightbulb',
                          color: theme.colorScheme.primary,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            recommendation,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                })
                .cast<Widget>()
                .toList(),
            const SizedBox(height: 20),
          ],

          // Detailed analysis toggle
          InkWell(
            onTap: () {
              setState(() {
                _showDetailedAnalysis = !_showDetailedAnalysis;
              });
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName:
                        _showDetailedAnalysis ? 'expand_less' : 'expand_more',
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Detailed Analysis',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Detailed analysis content
          if (_showDetailedAnalysis) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Symptom correlation
                  if (widget.analysisResults['symptomCorrelation'] != null) ...[
                    Text(
                      'Symptom Correlation',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.analysisResults['symptomCorrelation'],
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Possible conditions
                  if (widget.analysisResults['possibleConditions'] != null) ...[
                    Text(
                      'Possible Conditions',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...(widget.analysisResults['possibleConditions'] as List)
                        .map((condition) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '• ',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    condition,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        })
                        .cast<Widget>()
                        .toList(),
                  ],
                ],
              ),
            ),
          ],

          const SizedBox(height: 20),

          // Disclaimer
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.colorScheme.error.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomIconWidget(
                  iconName: 'info',
                  color: theme.colorScheme.error,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'This analysis is for informational purposes only and should not replace professional medical advice. Please consult with a healthcare provider for proper diagnosis and treatment.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: widget.onGenerateReport,
                  icon: CustomIconWidget(
                    iconName: 'download',
                    color: theme.colorScheme.primary,
                    size: 18,
                  ),
                  label: const Text('Download Report'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: widget.onSaveToChat,
                  icon: CustomIconWidget(
                    iconName: 'chat',
                    color: theme.colorScheme.onPrimary,
                    size: 18,
                  ),
                  label: const Text('Save to Chat'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
