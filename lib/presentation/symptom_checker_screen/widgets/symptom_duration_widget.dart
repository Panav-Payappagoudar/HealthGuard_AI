import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SymptomDurationWidget extends StatefulWidget {
  final String duration;
  final Function(String) onDurationChanged;

  const SymptomDurationWidget({
    super.key,
    required this.duration,
    required this.onDurationChanged,
  });

  @override
  State<SymptomDurationWidget> createState() => _SymptomDurationWidgetState();
}

class _SymptomDurationWidgetState extends State<SymptomDurationWidget> {
  final List<Map<String, dynamic>> durationOptions = [
    {'value': 'Less than 1 hour', 'icon': 'schedule', 'color': Colors.blue},
    {'value': '1-6 hours', 'icon': 'access_time', 'color': Colors.green},
    {'value': '6-24 hours', 'icon': 'today', 'color': Colors.orange},
    {'value': '1-3 days', 'icon': 'date_range', 'color': Colors.deepOrange},
    {'value': '3-7 days', 'icon': 'calendar_today', 'color': Colors.red},
    {'value': 'More than 1 week', 'icon': 'event', 'color': Colors.purple},
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
            'How long have you been experiencing this symptom?',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),

          // Duration options grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: durationOptions.length,
            itemBuilder: (context, index) {
              final option = durationOptions[index];
              final isSelected = widget.duration == option['value'];

              return GestureDetector(
                onTap: () => widget.onDurationChanged(option['value']),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? option['color'].withValues(alpha: 0.1)
                        : theme.colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? option['color']
                          : theme.colorScheme.outline.withValues(alpha: 0.3),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: option['icon'],
                        color: isSelected
                            ? option['color']
                            : theme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          option['value'],
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isSelected
                                ? option['color']
                                : theme.colorScheme.onSurfaceVariant,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
