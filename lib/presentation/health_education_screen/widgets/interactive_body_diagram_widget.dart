import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class InteractiveBodyDiagramWidget extends StatefulWidget {
  final Function(String) onOrganTap;

  const InteractiveBodyDiagramWidget({
    super.key,
    required this.onOrganTap,
  });

  @override
  State<InteractiveBodyDiagramWidget> createState() =>
      _InteractiveBodyDiagramWidgetState();
}

class _InteractiveBodyDiagramWidgetState
    extends State<InteractiveBodyDiagramWidget> {
  String? _selectedOrgan;

  final Map<String, Map<String, dynamic>> _organData = {
    'head': {
      'name': 'Head & Brain',
      'diseases': ['Depression', 'Anxiety', 'Japanese Encephalitis'],
      'position': Offset(0.5, 0.15),
    },
    'chest': {
      'name': 'Chest & Lungs',
      'diseases': ['Tuberculosis', 'Pneumonia', 'Asthma'],
      'position': Offset(0.5, 0.35),
    },
    'heart': {
      'name': 'Heart',
      'diseases': ['Cardiovascular Disease', 'Hypertension'],
      'position': Offset(0.45, 0.32),
    },
    'liver': {
      'name': 'Liver',
      'diseases': ['Hepatitis A', 'Hepatitis B', 'Hepatitis C'],
      'position': Offset(0.55, 0.42),
    },
    'stomach': {
      'name': 'Stomach',
      'diseases': ['Cholera', 'Typhoid', 'Gastroenteritis'],
      'position': Offset(0.5, 0.48),
    },
    'blood': {
      'name': 'Blood System',
      'diseases': ['Malaria', 'Dengue', 'Anemia', 'Diabetes'],
      'position': Offset(0.3, 0.5),
    },
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final dialogWidth = size.width * 0.8;
    final dialogHeight = size.height * 0.7;

    return Container(
      width: dialogWidth,
      height: dialogHeight,
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          Text(
            'Interactive Body Diagram',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Tap on body parts to explore related diseases',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 20.h),
          Expanded(
            child: Stack(
              children: [
                // Body diagram background
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  child: CustomPaint(
                    painter: BodyDiagramPainter(theme.colorScheme),
                  ),
                ),

                // Organ markers
                ..._organData.entries.map((entry) {
                  final organ = entry.key;
                  final data = entry.value;
                  final position = data['position'] as Offset;

                  return Positioned(
                    left: position.dx * dialogWidth - 60.w,
                    top: position.dy * dialogHeight - 60.h,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedOrgan = organ;
                        });
                        _showOrganDetails(organ, data);
                      },
                      child: Container(
                        width: 30.w,
                        height: 30.w,
                        decoration: BoxDecoration(
                          color: _selectedOrgan == organ
                              ? theme.colorScheme.primary
                              : theme.colorScheme.primary
                                  .withValues(alpha: 0.7),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary
                                  .withValues(alpha: 0.3),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.add,
                          color: theme.colorScheme.onPrimary,
                          size: 16.w,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showOrganDetails(String organ, Map<String, dynamic> data) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data['name'],
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Common diseases affecting this area:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: (data['diseases'] as List)
                  .map((disease) => Chip(
                        label: Text(disease),
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        onDeleted: () {
                          Navigator.pop(context);
                          widget.onOrganTap(disease);
                        },
                        deleteIcon: Icon(Icons.search, size: 16.w),
                      ))
                  .toList(),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  widget.onOrganTap(organ);
                },
                child: Text('Explore ${data['name']} Diseases'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BodyDiagramPainter extends CustomPainter {
  final ColorScheme colorScheme;

  BodyDiagramPainter(this.colorScheme);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = colorScheme.outline.withValues(alpha: 0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = colorScheme.surface
      ..style = PaintingStyle.fill;

    // Draw simplified human body outline
    final bodyPath = Path();

    // Head
    bodyPath.addOval(Rect.fromCenter(
      center: Offset(size.width * 0.5, size.height * 0.15),
      width: size.width * 0.15,
      height: size.height * 0.12,
    ));

    // Neck
    bodyPath.addRect(Rect.fromLTWH(
      size.width * 0.47,
      size.height * 0.21,
      size.width * 0.06,
      size.height * 0.05,
    ));

    // Torso
    bodyPath.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.35,
        size.height * 0.26,
        size.width * 0.3,
        size.height * 0.35,
      ),
      Radius.circular(size.width * 0.05),
    ));

    // Arms
    bodyPath.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.2,
        size.height * 0.28,
        size.width * 0.12,
        size.height * 0.25,
      ),
      Radius.circular(size.width * 0.03),
    ));

    bodyPath.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.68,
        size.height * 0.28,
        size.width * 0.12,
        size.height * 0.25,
      ),
      Radius.circular(size.width * 0.03),
    ));

    // Legs
    bodyPath.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.38,
        size.height * 0.61,
        size.width * 0.1,
        size.height * 0.25,
      ),
      Radius.circular(size.width * 0.03),
    ));

    bodyPath.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.52,
        size.height * 0.61,
        size.width * 0.1,
        size.height * 0.25,
      ),
      Radius.circular(size.width * 0.03),
    ));

    canvas.drawPath(bodyPath, fillPaint);
    canvas.drawPath(bodyPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}