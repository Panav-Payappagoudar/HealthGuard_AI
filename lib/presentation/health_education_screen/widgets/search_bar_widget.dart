import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final VoidCallback onVoiceSearch;
  final bool isVoiceActive;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onVoiceSearch,
    required this.isVoiceActive,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.0.r),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search diseases, symptoms...',
          prefixIcon: Icon(
            Icons.search,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (controller.text.isNotEmpty)
                IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                ),
              IconButton(
                icon: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  child: Icon(
                    isVoiceActive ? Icons.mic : Icons.mic_none,
                    color: isVoiceActive
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                onPressed: onVoiceSearch,
              ),
            ],
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
        ),
      ),
    );
  }
}