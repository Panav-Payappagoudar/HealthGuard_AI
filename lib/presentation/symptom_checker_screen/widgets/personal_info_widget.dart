import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class PersonalInfoWidget extends StatefulWidget {
  final Map<String, dynamic> personalInfo;
  final Function(Map<String, dynamic>) onInfoChanged;

  const PersonalInfoWidget({
    super.key,
    required this.personalInfo,
    required this.onInfoChanged,
  });

  @override
  State<PersonalInfoWidget> createState() => _PersonalInfoWidgetState();
}

class _PersonalInfoWidgetState extends State<PersonalInfoWidget> {
  final TextEditingController _ageController = TextEditingController();
  final List<String> genderOptions = [
    'Male',
    'Female',
    'Other',
    'Prefer not to say'
  ];
  final List<String> medicalHistoryOptions = [
    'Diabetes',
    'Hypertension',
    'Heart Disease',
    'Asthma',
    'Allergies',
    'Kidney Disease',
    'Liver Disease',
    'Cancer',
    'Mental Health Conditions',
    'Autoimmune Disorders',
  ];

  @override
  void initState() {
    super.initState();
    _ageController.text = widget.personalInfo['age']?.toString() ?? '';
  }

  void _updateInfo(String key, dynamic value) {
    Map<String, dynamic> updatedInfo = Map.from(widget.personalInfo);
    updatedInfo[key] = value;
    widget.onInfoChanged(updatedInfo);
  }

  void _toggleMedicalHistory(String condition) {
    List<String> currentHistory =
        List<String>.from(widget.personalInfo['medicalHistory'] ?? []);

    if (currentHistory.contains(condition)) {
      currentHistory.remove(condition);
    } else {
      currentHistory.add(condition);
    }

    _updateInfo('medicalHistory', currentHistory);
  }

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
            'Personal Information',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),

          // Age input
          Text(
            'Age',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _ageController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3),
            ],
            decoration: const InputDecoration(
              hintText: 'Enter your age',
            ),
            onChanged: (value) {
              final age = int.tryParse(value);
              _updateInfo('age', age);
            },
          ),
          const SizedBox(height: 20),

          // Gender selection
          Text(
            'Gender',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: genderOptions.map((gender) {
              final isSelected = widget.personalInfo['gender'] == gender;
              return FilterChip(
                label: Text(gender),
                selected: isSelected,
                onSelected: (_) => _updateInfo('gender', gender),
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                selectedColor: theme.colorScheme.primaryContainer,
                labelStyle: theme.textTheme.bodySmall?.copyWith(
                  color: isSelected
                      ? theme.colorScheme.onPrimaryContainer
                      : theme.colorScheme.onSurface,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Medical history
          Text(
            'Medical History',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select any conditions you have or have had:',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),

          // Medical history options
          ...medicalHistoryOptions.map((condition) {
            final isSelected =
                (widget.personalInfo['medicalHistory'] as List<String>? ?? [])
                    .contains(condition);

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: () => _toggleMedicalHistory(condition),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primaryContainer
                            .withValues(alpha: 0.3)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: isSelected
                            ? 'check_box'
                            : 'check_box_outline_blank',
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          condition,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isSelected
                                ? theme.colorScheme.onPrimaryContainer
                                : theme.colorScheme.onSurface,
                            fontWeight:
                                isSelected ? FontWeight.w500 : FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),

          const SizedBox(height: 16),

          // None option
          InkWell(
            onTap: () => _updateInfo('medicalHistory', <String>[]),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: (widget.personalInfo['medicalHistory']
                                as List<String>? ??
                            [])
                        .isEmpty
                    ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color:
                      (widget.personalInfo['medicalHistory'] as List<String>? ??
                                  [])
                              .isEmpty
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: (widget.personalInfo['medicalHistory']
                                    as List<String>? ??
                                [])
                            .isEmpty
                        ? 'check_box'
                        : 'check_box_outline_blank',
                    color: (widget.personalInfo['medicalHistory']
                                    as List<String>? ??
                                [])
                            .isEmpty
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'None of the above',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: (widget.personalInfo['medicalHistory']
                                        as List<String>? ??
                                    [])
                                .isEmpty
                            ? theme.colorScheme.onPrimaryContainer
                            : theme.colorScheme.onSurface,
                        fontWeight: (widget.personalInfo['medicalHistory']
                                        as List<String>? ??
                                    [])
                                .isEmpty
                            ? FontWeight.w500
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _ageController.dispose();
    super.dispose();
  }
}
