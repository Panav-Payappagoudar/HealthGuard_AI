import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class MapControlsWidget extends StatelessWidget {
  final VoidCallback onLocationPressed;
  final VoidCallback onLayerTogglePressed;
  final bool isLayerToggled;

  const MapControlsWidget({
    super.key,
    required this.onLocationPressed,
    required this.onLayerTogglePressed,
    required this.isLayerToggled,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        // Location button (bottom-right)
        Positioned(
          bottom: 20.h,
          right: 4.w,
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor,
                  offset: const Offset(0, 2),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onLocationPressed,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 12.w,
                  height: 6.h,
                  padding: EdgeInsets.all(2.w),
                  child: CustomIconWidget(
                    iconName: 'my_location',
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Layer toggle button (top-right)
        Positioned(
          top: 12.h,
          right: 4.w,
          child: Container(
            decoration: BoxDecoration(
              color: isLayerToggled
                  ? theme.colorScheme.primary.withValues(alpha: 0.1)
                  : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: isLayerToggled
                  ? Border.all(color: theme.colorScheme.primary, width: 1)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor,
                  offset: const Offset(0, 2),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onLayerTogglePressed,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 12.w,
                  height: 6.h,
                  padding: EdgeInsets.all(2.w),
                  child: CustomIconWidget(
                    iconName: 'layers',
                    color: isLayerToggled
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
