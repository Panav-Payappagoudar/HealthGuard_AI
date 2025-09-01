import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SymptomIntensityWidget extends StatefulWidget {
  final double intensity;
  final Function(double) onIntensityChanged;

  const SymptomIntensityWidget({
    super.key,
    required this.intensity,
    required this.onIntensityChanged,
  });

  @override
  State<SymptomIntensityWidget> createState() => _SymptomIntensityWidgetState();
}

class _SymptomIntensityWidgetState extends State<SymptomIntensityWidget> {
  final List<Map<String, dynamic>> intensityLevels = [
    {
      'value': 1.0,
      'label': 'Mild',
      'color': Colors.green,
      'icon': 'sentiment_satisfied'
    },
    {
      'value': 2.0,
      'label': 'Moderate',
      'color': Colors.orange,
      'icon': 'sentiment_neutral'
    },
    {
      'value': 3.0,
      'label': 'Severe',
      'color': Colors.red,
      'icon': 'sentiment_dissatisfied'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
          Text(
            'Symptom Intensity',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),

          // Intensity levels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: intensityLevels.map((level) {
              final isSelected = widget.intensity == level['value'];

              return GestureDetector(
                onTap: () => widget.onIntensityChanged(level['value']),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? level['color'].withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? level['color']
                          : theme.colorScheme.outline.withValues(alpha: 0.3),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      CustomIconWidget(
                        iconName: level['icon'],
                        color: isSelected
                            ? level['color']
                            : theme.colorScheme.onSurfaceVariant,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        level['label'],
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isSelected
                              ? level['color']
                              : theme.colorScheme.onSurfaceVariant,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Slider for fine-tuning
          Text(
            'Fine-tune intensity: ${widget.intensity.toStringAsFixed(1)}/3.0',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: _getIntensityColor(widget.intensity),
              thumbColor: _getIntensityColor(widget.intensity),
              overlayColor:
                  _getIntensityColor(widget.intensity).withValues(alpha: 0.2),
              inactiveTrackColor:
                  theme.colorScheme.outline.withValues(alpha: 0.3),
              trackHeight: 6.0,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
            ),
            child: Slider(
              value: widget.intensity,
              min: 1.0,
              max: 3.0,
              divisions: 20,
              onChanged: widget.onIntensityChanged,
            ),
          ),
        ],
      ),
    );
  }

  Color _getIntensityColor(double intensity) {
    if (intensity <= 1.5) return Colors.green;
    if (intensity <= 2.5) return Colors.orange;
    return Colors.red;
  }
}
