import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/emergency_contact_card.dart';
import './widgets/emergency_fab.dart';
import './widgets/emergency_search_bar.dart';
import './widgets/find_hospital_button.dart';

class EmergencyDirectoryScreen extends StatefulWidget {
  const EmergencyDirectoryScreen({super.key});

  @override
  State<EmergencyDirectoryScreen> createState() =>
      _EmergencyDirectoryScreenState();
}

class _EmergencyDirectoryScreenState extends State<EmergencyDirectoryScreen>
    with TickerProviderStateMixin {
  late TextEditingController _searchController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  List<String> _favoriteContacts = [];
  String _searchQuery = '';
  int _currentBottomNavIndex = 3; // Emergency tab is active

  // Mock emergency contacts data
  final List<Map<String, dynamic>> _emergencyContacts = [
    {
      "id": "ambulance_102",
      "name": "Ambulance Service",
      "primaryNumber": "102",
      "secondaryNumber": "108",
      "category": "medical",
      "icon": "local_hospital",
      "description": "Emergency medical services and ambulance dispatch",
      "availability": "24/7 Available",
    },
    {
      "id": "police_100",
      "name": "Police Emergency",
      "primaryNumber": "100",
      "secondaryNumber": null,
      "category": "emergency",
      "icon": "local_police",
      "description": "Police emergency response and law enforcement",
      "availability": "24/7 Available",
    },
    {
      "id": "fire_101",
      "name": "Fire Department",
      "primaryNumber": "101",
      "secondaryNumber": null,
      "category": "emergency",
      "icon": "local_fire_department",
      "description": "Fire emergency response and rescue services",
      "availability": "24/7 Available",
    },
    {
      "id": "women_helpline",
      "name": "Women Helpline",
      "primaryNumber": "1091",
      "secondaryNumber": "181",
      "category": "support",
      "icon": "support_agent",
      "description": "24x7 helpline for women in distress",
      "availability": "24/7 Available",
    },
    {
      "id": "mental_health",
      "name": "Mental Health Helpline",
      "primaryNumber": "1800-599-0019",
      "secondaryNumber": null,
      "category": "support",
      "icon": "psychology",
      "description": "Mental health support and counseling services",
      "availability": "24/7 Available",
    },
    {
      "id": "child_helpline",
      "name": "Child Helpline",
      "primaryNumber": "1098",
      "secondaryNumber": null,
      "category": "support",
      "icon": "child_care",
      "description": "Emergency helpline for children in need",
      "availability": "24/7 Available",
    },
    {
      "id": "blood_bank",
      "name": "Blood Bank Services",
      "primaryNumber": "104",
      "secondaryNumber": null,
      "category": "medical",
      "icon": "bloodtype",
      "description": "Blood bank information and emergency blood services",
      "availability": "24/7 Available",
    },
    {
      "id": "disaster_response",
      "name": "Disaster Response",
      "primaryNumber": "1078",
      "secondaryNumber": null,
      "category": "emergency",
      "icon": "warning",
      "description": "Natural disaster response and emergency management",
      "availability": "24/7 Available",
    },
    {
      "id": "railway_helpline",
      "name": "Railway Helpline",
      "primaryNumber": "139",
      "secondaryNumber": null,
      "category": "safety",
      "icon": "train",
      "description": "Railway emergency and passenger assistance",
      "availability": "24/7 Available",
    },
    {
      "id": "tourist_helpline",
      "name": "Tourist Helpline",
      "primaryNumber": "1363",
      "secondaryNumber": null,
      "category": "support",
      "icon": "travel_explore",
      "description": "Tourist assistance and emergency support",
      "availability": "24/7 Available",
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    // Start fade animation
    _fadeController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  void _toggleFavorite(String contactId) {
    setState(() {
      if (_favoriteContacts.contains(contactId)) {
        _favoriteContacts.remove(contactId);
      } else {
        _favoriteContacts.add(contactId);
      }
    });
  }

  List<Map<String, dynamic>> _getFilteredContacts() {
    if (_searchQuery.isEmpty) {
      return _emergencyContacts;
    }

    return _emergencyContacts.where((contact) {
      final name = (contact["name"] as String).toLowerCase();
      final number = (contact["primaryNumber"] as String).toLowerCase();
      final description =
          (contact["description"] as String? ?? "").toLowerCase();

      return name.contains(_searchQuery) ||
          number.contains(_searchQuery) ||
          description.contains(_searchQuery);
    }).toList();
  }

  List<Map<String, dynamic>> _getFavoriteContacts() {
    return _emergencyContacts
        .where((contact) => _favoriteContacts.contains(contact["id"]))
        .toList();
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentBottomNavIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredContacts = _getFilteredContacts();
    final favoriteContacts = _getFavoriteContacts();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const CustomEmergencyAppBar(
        title: 'Emergency Directory',
        showBackButton: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Search bar
            EmergencySearchBar(
              onSearchChanged: _onSearchChanged,
              controller: _searchController,
            ),

            // Find nearest hospital button
            const FindHospitalButton(),

            // Content area
            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Favorites section
                  if (favoriteContacts.isNotEmpty && _searchQuery.isEmpty) ...[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 1.h),
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'star',
                              color: const Color(0xFFFF9500),
                              size: 5.w,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              'Favorites',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final contact = favoriteContacts[index];
                          return EmergencyContactCard(
                            contact: contact,
                            isFavorite: true,
                            onFavoriteToggle: () =>
                                _toggleFavorite(contact["id"] as String),
                          );
                        },
                        childCount: favoriteContacts.length,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 2.h),
                        child: Divider(
                          color:
                              theme.colorScheme.outline.withValues(alpha: 0.3),
                          thickness: 1,
                        ),
                      ),
                    ),
                  ],

                  // All contacts section header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName:
                                _searchQuery.isEmpty ? 'emergency' : 'search',
                            color: theme.colorScheme.error,
                            size: 5.w,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            _searchQuery.isEmpty
                                ? 'All Emergency Services'
                                : 'Search Results (${filteredContacts.length})',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Emergency contacts list
                  if (filteredContacts.isNotEmpty)
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final contact = filteredContacts[index];
                          final contactId = contact["id"] as String;
                          return EmergencyContactCard(
                            contact: contact,
                            isFavorite: _favoriteContacts.contains(contactId),
                            onFavoriteToggle: () => _toggleFavorite(contactId),
                          );
                        },
                        childCount: filteredContacts.length,
                      ),
                    )
                  else
                    SliverToBoxAdapter(
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        child: Column(
                          children: [
                            CustomIconWidget(
                              iconName: 'search_off',
                              color: theme.colorScheme.onSurfaceVariant,
                              size: 15.w,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'No emergency services found',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'Try searching with different keywords',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Bottom spacing for FAB
                  SliverToBoxAdapter(
                    child: SizedBox(height: 10.h),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: const EmergencyFAB(),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomNavIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }
}
