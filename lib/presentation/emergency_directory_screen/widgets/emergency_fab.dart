import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class EmergencyFAB extends StatefulWidget {
  const EmergencyFAB({super.key});

  @override
  State<EmergencyFAB> createState() => _EmergencyFABState();
}

class _EmergencyFABState extends State<EmergencyFAB>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.125, // 45 degrees (1/8 of a full rotation)
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeInOut,
    ));

    // Start pulsing animation
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _rotationController.forward();
    } else {
      _rotationController.reverse();
    }
  }

  Future<void> _makeEmergencyCall(String number) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
    _toggleExpanded(); // Close the expanded menu after calling
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Expanded options
        if (_isExpanded) ...[
          _buildEmergencyOption(
            theme: theme,
            label: 'Ambulance',
            number: '102',
            icon: 'local_hospital',
            color: theme.colorScheme.tertiary,
            offset: const Offset(0, -80),
          ),
          _buildEmergencyOption(
            theme: theme,
            label: 'Police',
            number: '100',
            icon: 'local_police',
            color: theme.colorScheme.primary,
            offset: const Offset(-60, -60),
          ),
          _buildEmergencyOption(
            theme: theme,
            label: 'Fire',
            number: '101',
            icon: 'local_fire_department',
            color: theme.colorScheme.error,
            offset: const Offset(-80, 0),
          ),
        ],

        // Main FAB
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: AnimatedBuilder(
                animation: _rotationAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotationAnimation.value * 2 * 3.14159,
                    child: FloatingActionButton(
                      onPressed: _toggleExpanded,
                      backgroundColor: theme.colorScheme.error,
                      foregroundColor: Colors.white,
                      elevation: 8,
                      child: CustomIconWidget(
                        iconName: _isExpanded ? 'close' : 'emergency',
                        color: Colors.white,
                        size: 7.w,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildEmergencyOption({
    required ThemeData theme,
    required String label,
    required String number,
    required String icon,
    required Color color,
    required Offset offset,
  }) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.elasticOut,
      right: offset.dx,
      bottom: offset.dy,
      child: GestureDetector(
        onTap: () => _makeEmergencyCall(number),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: icon,
                color: Colors.white,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    number,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
