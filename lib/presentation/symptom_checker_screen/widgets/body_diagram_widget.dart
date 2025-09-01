import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class BodyDiagramWidget extends StatefulWidget {
  final Function(String) onBodyPartSelected;
  final String? selectedBodyPart;

  const BodyDiagramWidget({
    super.key,
    required this.onBodyPartSelected,
    this.selectedBodyPart,
  });

  @override
  State<BodyDiagramWidget> createState() => _BodyDiagramWidgetState();
}

class _BodyDiagramWidgetState extends State<BodyDiagramWidget> {
  final List<Map<String, dynamic>> bodyParts = [
    {
      'name': 'Head',
      'position': const Offset(0.5, 0.15),
      'icon': 'psychology',
    },
    {
      'name': 'Chest',
      'position': const Offset(0.5, 0.35),
      'icon': 'favorite',
    },
    {
      'name': 'Abdomen',
      'position': const Offset(0.5, 0.5),
      'icon': 'circle',
    },
    {
      'name': 'Left Arm',
      'position': const Offset(0.25, 0.35),
      'icon': 'back_hand',
    },
    {
      'name': 'Right Arm',
      'position': const Offset(0.75, 0.35),
      'icon': 'back_hand',
    },
    {
      'name': 'Left Leg',
      'position': const Offset(0.4, 0.75),
      'icon': 'directions_walk',
    },
    {
      'name': 'Right Leg',
      'position': const Offset(0.6, 0.75),
      'icon': 'directions_walk',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 80.w,
      height: 50.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          // Background body outline
          Center(
            child: Container(
              width: 60.w,
              height: 45.h,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),

          // Body part selection points
          ...bodyParts.map((bodyPart) {
            final isSelected = widget.selectedBodyPart == bodyPart['name'];

            return Positioned(
              left: bodyPart['position'].dx * 80.w - 24,
              top: bodyPart['position'].dy * 50.h - 24,
              child: GestureDetector(
                onTap: () => widget.onBodyPartSelected(bodyPart['name']),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.shadowColor,
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: bodyPart['icon'],
                      color: isSelected
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurface,
                      size: 20,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),

          // Instructions
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Tap on the body part where you\'re experiencing symptoms',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
