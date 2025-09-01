import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MapSearchWidget extends StatefulWidget {
  final Function(String) onSearchChanged;
  final Function(Map<String, dynamic>) onLocationSelected;

  const MapSearchWidget({
    super.key,
    required this.onSearchChanged,
    required this.onLocationSelected,
  });

  @override
  State<MapSearchWidget> createState() => _MapSearchWidgetState();
}

class _MapSearchWidgetState extends State<MapSearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isSearching = false;
  List<Map<String, dynamic>> _searchResults = [];

  // Mock search results for demonstration
  final List<Map<String, dynamic>> _mockLocations = [
    {
      'name': 'Mumbai, Maharashtra',
      'subtitle': 'High Risk Zone',
      'latitude': 19.0760,
      'longitude': 72.8777,
      'riskLevel': 'high',
    },
    {
      'name': 'Delhi, India',
      'subtitle': 'Medium Risk Zone',
      'latitude': 28.7041,
      'longitude': 77.1025,
      'riskLevel': 'medium',
    },
    {
      'name': 'Bangalore, Karnataka',
      'subtitle': 'Low Risk Zone',
      'latitude': 12.9716,
      'longitude': 77.5946,
      'riskLevel': 'low',
    },
    {
      'name': 'Chennai, Tamil Nadu',
      'subtitle': 'Medium Risk Zone',
      'latitude': 13.0827,
      'longitude': 80.2707,
      'riskLevel': 'medium',
    },
    {
      'name': 'Kolkata, West Bengal',
      'subtitle': 'High Risk Zone',
      'latitude': 22.5726,
      'longitude': 88.3639,
      'riskLevel': 'high',
    },
    {
      'name': 'Hyderabad, Telangana',
      'subtitle': 'Low Risk Zone',
      'latitude': 17.3850,
      'longitude': 78.4867,
      'riskLevel': 'low',
    },
    {
      'name': 'Pune, Maharashtra',
      'subtitle': 'Medium Risk Zone',
      'latitude': 18.5204,
      'longitude': 73.8567,
      'riskLevel': 'medium',
    },
    {
      'name': 'Ahmedabad, Gujarat',
      'subtitle': 'Low Risk Zone',
      'latitude': 23.0225,
      'longitude': 72.5714,
      'riskLevel': 'low',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        _searchResults.clear();
      } else {
        _searchResults = _mockLocations
            .where((location) => (location['name'] as String)
                .toLowerCase()
                .contains(query.toLowerCase()))
            .take(5)
            .toList();
      }
    });
    widget.onSearchChanged(query);
  }

  void _selectLocation(Map<String, dynamic> location) {
    _searchController.text = location['name'] as String;
    setState(() {
      _isSearching = false;
      _searchResults.clear();
    });
    _focusNode.unfocus();
    widget.onLocationSelected(location);
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
      _searchResults.clear();
    });
    widget.onSearchChanged('');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Positioned(
      top: 10.h,
      left: 4.w,
      right: 4.w,
      child: Column(
        children: [
          // Search bar
          Container(
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
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              onChanged: _performSearch,
              decoration: InputDecoration(
                hintText: 'Search locations...',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'search',
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _clearSearch,
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: EdgeInsets.all(3.w),
                            child: CustomIconWidget(
                              iconName: 'close',
                              color: theme.colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                          ),
                        ),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 2.h,
                ),
              ),
            ),
          ),

          // Search results
          if (_isSearching && _searchResults.isNotEmpty)
            Container(
              margin: EdgeInsets.only(top: 1.h),
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
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _searchResults.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
                itemBuilder: (context, index) {
                  final location = _searchResults[index];
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _selectLocation(location),
                      borderRadius: index == 0
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            )
                          : index == _searchResults.length - 1
                              ? const BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                )
                              : null,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 2.h,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 4.w,
                              height: 2.h,
                              decoration: BoxDecoration(
                                color: _getRiskColor(
                                    location['riskLevel'] as String, theme),
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    location['name'] as String,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: theme.colorScheme.onSurface,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    location['subtitle'] as String,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            CustomIconWidget(
                              iconName: 'arrow_forward_ios',
                              color: theme.colorScheme.onSurfaceVariant,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Color _getRiskColor(String riskLevel, ThemeData theme) {
    switch (riskLevel.toLowerCase()) {
      case 'high':
        return theme.colorScheme.error;
      case 'medium':
        return AppTheme.warningLight;
      case 'low':
        return AppTheme.successLight;
      default:
        return theme.colorScheme.onSurfaceVariant;
    }
  }
}
