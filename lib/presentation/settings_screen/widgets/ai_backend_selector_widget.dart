import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class AiBackendSelectorWidget extends StatelessWidget {
  final String selectedBackend;
  final ValueChanged<String> onBackendChanged;

  const AiBackendSelectorWidget({
    super.key,
    required this.selectedBackend,
    required this.onBackendChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> backends = [
      {
        'id': 'openai',
        'name': 'OpenAI GPT',
        'description': 'Advanced AI with internet access',
        'status': 'Connected',
        'statusColor': theme.colorScheme.tertiary,
      },
      {
        'id': 'ollama',
        'name': 'Ollama Local',
        'description': 'Privacy-focused local AI',
        'status': 'Available',
        'statusColor': theme.colorScheme.primary,
      },
      {
        'id': 'local',
        'name': 'Local LLM',
        'description': 'On-device processing',
        'status': 'Offline',
        'statusColor': theme.colorScheme.onSurfaceVariant,
      },
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'psychology',
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Backend Selection',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Choose your preferred AI service',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          ...backends.map((backend) => _buildBackendOption(
                context,
                backend,
                selectedBackend == backend['id'],
              )),
        ],
      ),
    );
  }

  Widget _buildBackendOption(
    BuildContext context,
    Map<String, dynamic> backend,
    bool isSelected,
  ) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onBackendChanged(backend['id']),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primary.withValues(alpha: 0.05)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? theme.colorScheme.primary.withValues(alpha: 0.3)
                    : theme.colorScheme.outline.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Radio<String>(
                  value: backend['id'],
                  groupValue: selectedBackend,
                  onChanged: (value) => onBackendChanged(value!),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        backend['name'],
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        backend['description'],
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: backend['statusColor'].withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    backend['status'],
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: backend['statusColor'],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
