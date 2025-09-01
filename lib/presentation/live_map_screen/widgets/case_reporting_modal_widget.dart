import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CaseReportingModalWidget extends StatefulWidget {
  final double latitude;
  final double longitude;
  final VoidCallback onClose;
  final Function(Map<String, dynamic>) onSubmit;

  const CaseReportingModalWidget({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.onClose,
    required this.onSubmit,
  });

  @override
  State<CaseReportingModalWidget> createState() =>
      _CaseReportingModalWidgetState();
}

class _CaseReportingModalWidgetState extends State<CaseReportingModalWidget> {
  final _formKey = GlobalKey<FormState>();
  final _symptomsController = TextEditingController();
  final _additionalInfoController = TextEditingController();

  String _selectedSeverity = 'mild';
  bool _isAnonymous = true;
  bool _isSubmitting = false;

  final List<String> _commonSymptoms = [
    'Fever',
    'Cough',
    'Shortness of breath',
    'Fatigue',
    'Body aches',
    'Headache',
    'Sore throat',
    'Loss of taste/smell',
  ];

  final List<String> _selectedSymptoms = [];

  @override
  void dispose() {
    _symptomsController.dispose();
    _additionalInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'report',
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Report Health Case',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.onClose,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: EdgeInsets.all(1.w),
                      child: CustomIconWidget(
                        iconName: 'close',
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Form content
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Location confirmation
                    _buildLocationSection(context),

                    SizedBox(height: 3.h),

                    // Symptoms selection
                    _buildSymptomsSection(context),

                    SizedBox(height: 3.h),

                    // Severity selection
                    _buildSeveritySection(context),

                    SizedBox(height: 3.h),

                    // Additional information
                    _buildAdditionalInfoSection(context),

                    SizedBox(height: 3.h),

                    // Privacy settings
                    _buildPrivacySection(context),

                    SizedBox(height: 4.h),

                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitReport,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isSubmitting
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    theme.colorScheme.onPrimary,
                                  ),
                                ),
                              )
                            : const Text('Submit Report'),
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Disclaimer
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'This report helps improve community health monitoring. For medical emergencies, please contact emergency services immediately.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'location_on',
                color: theme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Lat: ${widget.latitude.toStringAsFixed(4)}, Lng: ${widget.longitude.toStringAsFixed(4)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSymptomsSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Symptoms (Select all that apply)',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _commonSymptoms.map((symptom) {
            final isSelected = _selectedSymptoms.contains(symptom);
            return FilterChip(
              label: Text(symptom),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedSymptoms.add(symptom);
                  } else {
                    _selectedSymptoms.remove(symptom);
                  }
                });
              },
              selectedColor: theme.colorScheme.primary.withValues(alpha: 0.2),
              checkmarkColor: theme.colorScheme.primary,
              labelStyle: theme.textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSeveritySection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Severity Level',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Mild'),
                value: 'mild',
                groupValue: _selectedSeverity,
                onChanged: (value) {
                  setState(() {
                    _selectedSeverity = value!;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Moderate'),
                value: 'moderate',
                groupValue: _selectedSeverity,
                onChanged: (value) {
                  setState(() {
                    _selectedSeverity = value!;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Severe'),
                value: 'severe',
                groupValue: _selectedSeverity,
                onChanged: (value) {
                  setState(() {
                    _selectedSeverity = value!;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdditionalInfoSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Information (Optional)',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _additionalInfoController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText:
                'Any additional details about symptoms, timeline, or relevant information...',
          ),
        ),
      ],
    );
  }

  Widget _buildPrivacySection(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'privacy_tip',
                color: theme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Privacy Settings',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          CheckboxListTile(
            title: const Text('Submit anonymously'),
            subtitle:
                const Text('Your personal information will not be stored'),
            value: _isAnonymous,
            onChanged: (value) {
              setState(() {
                _isAnonymous = value!;
              });
            },
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ],
      ),
    );
  }

  void _submitReport() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      final reportData = {
        'latitude': widget.latitude,
        'longitude': widget.longitude,
        'symptoms': _selectedSymptoms,
        'severity': _selectedSeverity,
        'additionalInfo': _additionalInfoController.text,
        'isAnonymous': _isAnonymous,
        'timestamp': DateTime.now().toIso8601String(),
      };

      widget.onSubmit(reportData);

      setState(() {
        _isSubmitting = false;
      });

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Report submitted successfully'),
            backgroundColor: AppTheme.successLight,
            behavior: SnackBarBehavior.floating,
          ),
        );
        widget.onClose();
      }
    }
  }
}
