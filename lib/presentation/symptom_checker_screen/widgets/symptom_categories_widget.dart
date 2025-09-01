import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SymptomCategoriesWidget extends StatefulWidget {
  final List<String> selectedSymptoms;
  final Function(List<String>) onSymptomsChanged;

  const SymptomCategoriesWidget({
    super.key,
    required this.selectedSymptoms,
    required this.onSymptomsChanged,
  });

  @override
  State<SymptomCategoriesWidget> createState() =>
      _SymptomCategoriesWidgetState();
}

class _SymptomCategoriesWidgetState extends State<SymptomCategoriesWidget> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> symptomCategories = [
    {
      'category': 'General',
      'symptoms': [
        'Fever',
        'Fatigue',
        'Weakness',
        'Loss of appetite',
        'Weight loss',
        'Night sweats'
      ]
    },
    {
      'category': 'Pain',
      'symptoms': [
        'Headache',
        'Back pain',
        'Joint pain',
        'Muscle pain',
        'Chest pain',
        'Abdominal pain'
      ]
    },
    {
      'category': 'Respiratory',
      'symptoms': [
        'Cough',
        'Shortness of breath',
        'Wheezing',
        'Sore throat',
        'Runny nose',
        'Congestion'
      ]
    },
    {
      'category': 'Digestive',
      'symptoms': [
        'Nausea',
        'Vomiting',
        'Diarrhea',
        'Constipation',
        'Bloating',
        'Heartburn'
      ]
    },
    {
      'category': 'Neurological',
      'symptoms': [
        'Dizziness',
        'Confusion',
        'Memory problems',
        'Numbness',
        'Tingling',
        'Seizures'
      ]
    },
    {
      'category': 'Skin',
      'symptoms': [
        'Rash',
        'Itching',
        'Dry skin',
        'Swelling',
        'Bruising',
        'Changes in moles'
      ]
    },
  ];

  List<String> get filteredSymptoms {
    if (_searchQuery.isEmpty) return [];

    List<String> allSymptoms = [];
    for (var category in symptomCategories) {
      allSymptoms.addAll((category['symptoms'] as List).cast<String>());
    }

    return allSymptoms
        .where((symptom) =>
            symptom.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void _toggleSymptom(String symptom) {
    List<String> updatedSymptoms = List.from(widget.selectedSymptoms);

    if (updatedSymptoms.contains(symptom)) {
      updatedSymptoms.remove(symptom);
    } else {
      updatedSymptoms.add(symptom);
    }

    widget.onSymptomsChanged(updatedSymptoms);
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
            'Select your symptoms',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),

          // Search field
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search symptoms...',
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12),
                child: CustomIconWidget(
                  iconName: 'search',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: CustomIconWidget(
                        iconName: 'clear',
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          const SizedBox(height: 20),

          // Selected symptoms chips
          if (widget.selectedSymptoms.isNotEmpty) ...[
            Text(
              'Selected symptoms (${widget.selectedSymptoms.length})',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.selectedSymptoms.map((symptom) {
                return Chip(
                  label: Text(symptom),
                  deleteIcon: CustomIconWidget(
                    iconName: 'close',
                    color: theme.colorScheme.onPrimary,
                    size: 16,
                  ),
                  onDeleted: () => _toggleSymptom(symptom),
                  backgroundColor: theme.colorScheme.primary,
                  labelStyle: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],

          // Search results or categories
          if (_searchQuery.isNotEmpty) ...[
            Text(
              'Search results',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            if (filteredSymptoms.isEmpty)
              Text(
                'No symptoms found',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: filteredSymptoms.map((symptom) {
                  final isSelected = widget.selectedSymptoms.contains(symptom);
                  return FilterChip(
                    label: Text(symptom),
                    selected: isSelected,
                    onSelected: (_) => _toggleSymptom(symptom),
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
          ] else ...[
            // Symptom categories
            ...symptomCategories.map((category) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category['category'],
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (category['symptoms'] as List)
                        .map((symptom) {
                          final isSelected =
                              widget.selectedSymptoms.contains(symptom);
                          return FilterChip(
                            label: Text(symptom),
                            selected: isSelected,
                            onSelected: (_) => _toggleSymptom(symptom),
                            backgroundColor:
                                theme.colorScheme.surfaceContainerHighest,
                            selectedColor: theme.colorScheme.primaryContainer,
                            labelStyle: theme.textTheme.bodySmall?.copyWith(
                              color: isSelected
                                  ? theme.colorScheme.onPrimaryContainer
                                  : theme.colorScheme.onSurface,
                            ),
                          );
                        })
                        .cast<Widget>()
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            }).toList(),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
