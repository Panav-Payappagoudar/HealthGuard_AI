import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class PersonalInfoSectionWidget extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String userAge;
  final List<String> medicalConditions;
  final List<String> emergencyContacts;
  final Function(String) onUserNameChanged;
  final Function(String) onUserEmailChanged;
  final Function(String) onUserAgeChanged;
  final Function(List<String>) onMedicalConditionsChanged;
  final Function(List<String>) onEmergencyContactsChanged;

  const PersonalInfoSectionWidget({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.userAge,
    required this.medicalConditions,
    required this.emergencyContacts,
    required this.onUserNameChanged,
    required this.onUserEmailChanged,
    required this.onUserAgeChanged,
    required this.onMedicalConditionsChanged,
    required this.onEmergencyContactsChanged,
  });

  @override
  State<PersonalInfoSectionWidget> createState() => _PersonalInfoSectionWidgetState();
}

class _PersonalInfoSectionWidgetState extends State<PersonalInfoSectionWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.userName;
    _emailController.text = widget.userEmail;
    _ageController.text = widget.userAge;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              Icon(
                Icons.person_outline,
                size: 24.w,
                color: theme.colorScheme.primary,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Personal Information',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _toggleEditing(),
                icon: Icon(
                  _isEditing ? Icons.check : Icons.edit,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Name field
          _buildInfoField(
            label: 'Full Name',
            value: widget.userName,
            controller: _nameController,
            isEditing: _isEditing,
            onChanged: widget.onUserNameChanged,
            keyboardType: TextInputType.text,
            theme: theme,
          ),

          SizedBox(height: 16.h),

          // Email field
          _buildInfoField(
            label: 'Email Address',
            value: widget.userEmail,
            controller: _emailController,
            isEditing: _isEditing,
            onChanged: widget.onUserEmailChanged,
            keyboardType: TextInputType.emailAddress,
            theme: theme,
          ),

          SizedBox(height: 16.h),

          // Age field
          _buildInfoField(
            label: 'Age',
            value: widget.userAge,
            controller: _ageController,
            isEditing: _isEditing,
            onChanged: widget.onUserAgeChanged,
            keyboardType: TextInputType.number,
            theme: theme,
          ),

          SizedBox(height: 16.h),

          // Medical conditions
          _buildChipListSection(
            title: 'Medical Conditions',
            items: widget.medicalConditions,
            onItemsChanged: widget.onMedicalConditionsChanged,
            suggestions: ['Diabetes', 'Hypertension', 'Asthma', 'Heart Disease', 'Allergies'],
            icon: Icons.medical_services_outlined,
            theme: theme,
          ),

          SizedBox(height: 16.h),

          // Emergency contacts
          _buildChipListSection(
            title: 'Emergency Contacts',
            items: widget.emergencyContacts,
            onItemsChanged: widget.onEmergencyContactsChanged,
            suggestions: [],
            icon: Icons.emergency_outlined,
            theme: theme,
            isContact: true,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoField({
    required String label,
    required String value,
    required TextEditingController controller,
    required bool isEditing,
    required Function(String) onChanged,
    required TextInputType keyboardType,
    required ThemeData theme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: isEditing 
                ? theme.colorScheme.primaryContainer.withValues(alpha: 0.1)
                : theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isEditing 
                  ? theme.colorScheme.primary.withValues(alpha: 0.3)
                  : theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: isEditing
              ? TextField(
                  controller: controller,
                  onChanged: onChanged,
                  keyboardType: keyboardType,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Enter $label',
                  ),
                  style: theme.textTheme.bodyMedium,
                )
              : Text(
                  value.isNotEmpty ? value : 'Not provided',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: value.isNotEmpty 
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onSurfaceVariant,
                    fontStyle: value.isEmpty ? FontStyle.italic : FontStyle.normal,
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildChipListSection({
    required String title,
    required List<String> items,
    required Function(List<String>) onItemsChanged,
    required List<String> suggestions,
    required IconData icon,
    required ThemeData theme,
    bool isContact = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16.w,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            SizedBox(width: 8.w),
            Text(
              title,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Spacer(),
            IconButton(
              onPressed: () => _showAddItemDialog(title, items, onItemsChanged, suggestions, isContact),
              icon: Icon(
                Icons.add,
                size: 20.w,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 50,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: items.isEmpty
              ? Center(
                  child: Text(
                    'No ${title.toLowerCase()} added',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                )
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: items.map((item) => Chip(
                    label: Text(item),
                    backgroundColor: theme.colorScheme.primaryContainer,
                    deleteIcon: Icon(Icons.close, size: 16),
                    onDeleted: () {
                      final updatedItems = List<String>.from(items);
                      updatedItems.remove(item);
                      onItemsChanged(updatedItems);
                    },
                  )).toList(),
                ),
        ),
      ],
    );
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
    
    if (!_isEditing) {
      // Save changes when exiting edit mode
      widget.onUserNameChanged(_nameController.text);
      widget.onUserEmailChanged(_emailController.text);
      widget.onUserAgeChanged(_ageController.text);
    }
  }

  void _showAddItemDialog(
    String title,
    List<String> currentItems,
    Function(List<String>) onItemsChanged,
    List<String> suggestions,
    bool isContact,
  ) {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add $title'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: isContact ? 'Contact Name' : 'Item',
                hintText: isContact ? 'Enter contact name' : 'Enter item',
                border: OutlineInputBorder(),
              ),
              keyboardType: isContact ? TextInputType.text : TextInputType.text,
            ),
            if (suggestions.isNotEmpty) ...[
              SizedBox(height: 16.h),
              Text(
                'Suggestions:',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              SizedBox(height: 8.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: suggestions.map((suggestion) => ActionChip(
                  label: Text(suggestion),
                  onPressed: () {
                    controller.text = suggestion;
                  },
                )).toList(),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                final updatedItems = List<String>.from(currentItems);
                if (!updatedItems.contains(controller.text)) {
                  updatedItems.add(controller.text);
                  onItemsChanged(updatedItems);
                }
              }
              Navigator.pop(context);
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}