import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/case_reporting_modal_widget.dart';
import './widgets/health_zone_popup_widget.dart';
import './widgets/map_bottom_sheet_widget.dart';
import './widgets/map_controls_widget.dart';
import './widgets/map_search_widget.dart';

class LiveMapScreen extends StatefulWidget {
  const LiveMapScreen({super.key});

  @override
  State<LiveMapScreen> createState() => _LiveMapScreenState();
}

class _LiveMapScreenState extends State<LiveMapScreen>
    with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  int _currentBottomBarIndex = 1; // Live Map tab active
  bool _isLayerToggled = true;
  bool _isBottomSheetExpanded = false;
  bool _isLoading = true;
  bool _isOfflineMode = false;

  LatLng _currentLocation = const LatLng(20.5937, 78.9629); // Center of India
  String _currentLocationStatus = 'medium';
  Map<String, dynamic>? _selectedZone;

  // Mock health zones data
  final List<Map<String, dynamic>> _healthZones = [
    {
      'id': 1,
      'zoneName': 'Mumbai Metropolitan',
      'center': const LatLng(19.0760, 72.8777),
      'radius': 50000.0,
      'riskLevel': 'high',
      'activeCases': 2847,
      'population': 12442373,
      'trend': 'increasing',
      'trendPercentage': 12,
      'lastUpdated': '2 hours ago',
    },
    {
      'id': 2,
      'zoneName': 'Delhi NCR',
      'center': const LatLng(28.7041, 77.1025),
      'radius': 45000.0,
      'riskLevel': 'medium',
      'activeCases': 1523,
      'population': 32900000,
      'trend': 'decreasing',
      'trendPercentage': 8,
      'lastUpdated': '1 hour ago',
    },
    {
      'id': 3,
      'zoneName': 'Bangalore Urban',
      'center': const LatLng(12.9716, 77.5946),
      'radius': 35000.0,
      'riskLevel': 'low',
      'activeCases': 456,
      'population': 13193035,
      'trend': 'stable',
      'trendPercentage': 2,
      'lastUpdated': '30 minutes ago',
    },
    {
      'id': 4,
      'zoneName': 'Chennai Metro',
      'center': const LatLng(13.0827, 80.2707),
      'radius': 40000.0,
      'riskLevel': 'medium',
      'activeCases': 892,
      'population': 10971108,
      'trend': 'increasing',
      'trendPercentage': 5,
      'lastUpdated': '45 minutes ago',
    },
    {
      'id': 5,
      'zoneName': 'Kolkata Metro',
      'center': const LatLng(22.5726, 88.3639),
      'radius': 38000.0,
      'riskLevel': 'high',
      'activeCases': 1876,
      'population': 14850066,
      'trend': 'increasing',
      'trendPercentage': 15,
      'lastUpdated': '1.5 hours ago',
    },
    {
      'id': 6,
      'zoneName': 'Hyderabad Metro',
      'center': const LatLng(17.3850, 78.4867),
      'radius': 42000.0,
      'riskLevel': 'low',
      'activeCases': 234,
      'population': 10004000,
      'trend': 'decreasing',
      'trendPercentage': 18,
      'lastUpdated': '20 minutes ago',
    },
    {
      'id': 7,
      'zoneName': 'Pune Metro',
      'center': const LatLng(18.5204, 73.8567),
      'radius': 32000.0,
      'riskLevel': 'medium',
      'activeCases': 678,
      'population': 7541946,
      'trend': 'stable',
      'trendPercentage': 1,
      'lastUpdated': '1 hour ago',
    },
    {
      'id': 8,
      'zoneName': 'Ahmedabad Metro',
      'center': const LatLng(23.0225, 72.5714),
      'radius': 30000.0,
      'riskLevel': 'low',
      'activeCases': 123,
      'population': 8450000,
      'trend': 'decreasing',
      'trendPercentage': 22,
      'lastUpdated': '40 minutes ago',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeMap();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    _pulseController.repeat(reverse: true);
  }

  void _initializeMap() async {
    await _requestLocationPermission();
    await _getCurrentLocation();
    await Future.delayed(const Duration(seconds: 2)); // Simulate loading
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    if (!status.isGranted) {
      setState(() {
        _isOfflineMode = true;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _currentLocationStatus =
            _determineLocationRiskStatus(position.latitude, position.longitude);
      });
    } catch (e) {
      setState(() {
        _isOfflineMode = true;
      });
    }
  }

  String _determineLocationRiskStatus(double lat, double lng) {
    final userLocation = LatLng(lat, lng);

    for (final zone in _healthZones) {
      final zoneCenter = zone['center'] as LatLng;
      final distance = Geolocator.distanceBetween(
        userLocation.latitude,
        userLocation.longitude,
        zoneCenter.latitude,
        zoneCenter.longitude,
      );

      if (distance <= (zone['radius'] as double)) {
        return zone['riskLevel'] as String;
      }
    }

    return 'low'; // Default to low risk if not in any zone
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // Map
          _isLoading ? _buildLoadingState() : _buildMap(),

          // Offline indicator
          if (_isOfflineMode)
            Positioned(
              top: 8.h,
              left: 4.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.warningLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'wifi_off',
                      color: Colors.white,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'Offline Mode',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Search widget
          if (!_isLoading)
            MapSearchWidget(
              onSearchChanged: _onSearchChanged,
              onLocationSelected: _onLocationSelected,
            ),

          // Map controls
          if (!_isLoading)
            MapControlsWidget(
              onLocationPressed: _centerOnCurrentLocation,
              onLayerTogglePressed: _toggleLayers,
              isLayerToggled: _isLayerToggled,
            ),

          // Selected zone popup
          if (_selectedZone != null)
            Positioned(
              top: 25.h,
              left: 0,
              right: 0,
              child: HealthZonePopupWidget(
                zoneData: _selectedZone!,
                onClose: () => setState(() => _selectedZone = null),
              ),
            ),

          // Bottom sheet
          if (!_isLoading)
            MapBottomSheetWidget(
              currentLocationStatus: _currentLocationStatus,
              onReportCase: _showCaseReportingModal,
              isExpanded: _isBottomSheetExpanded,
              onToggleExpanded: () => setState(
                  () => _isBottomSheetExpanded = !_isBottomSheetExpanded),
            ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomBarIndex,
        onTap: (index) => setState(() => _currentBottomBarIndex = index),
      ),
    );
  }

  Widget _buildLoadingState() {
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.surface,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 15.w,
              height: 7.5.h,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.primary,
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Loading Health Zones...',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Fetching real-time health data',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _currentLocation,
        initialZoom: 6.0,
        minZoom: 4.0,
        maxZoom: 18.0,
        onTap: (tapPosition, point) => _onMapTap(point),
        onLongPress: (tapPosition, point) => _onMapLongPress(point),
      ),
      children: [
        // Base map layer
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.healthguard.app',
          maxZoom: 18,
        ),

        // Health zones layer
        if (_isLayerToggled) ..._buildHealthZoneLayers(),

        // Current location marker
        MarkerLayer(
          markers: [
            Marker(
              point: _currentLocation,
              width: 8.w,
              height: 4.h,
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.3),
                            blurRadius: 10,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: 'person',
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildHealthZoneLayers() {
    return [
      // Zone circles
      CircleLayer(
        circles: _healthZones.map((zone) {
          final Color zoneColor = _getZoneColor(zone['riskLevel'] as String);
          return CircleMarker(
            point: zone['center'] as LatLng,
            radius:
                (zone['radius'] as double) / 1000, // Convert to km for display
            color: zoneColor.withValues(alpha: 0.2),
            borderColor: zoneColor,
            borderStrokeWidth: 2,
          );
        }).toList(),
      ),

      // Zone markers
      MarkerLayer(
        markers: _healthZones.map((zone) {
          return Marker(
            point: zone['center'] as LatLng,
            width: 10.w,
            height: 5.h,
            child: GestureDetector(
              onTap: () => _onZoneSelected(zone),
              child: Container(
                decoration: BoxDecoration(
                  color: _getZoneColor(zone['riskLevel'] as String),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    zone['activeCases'].toString(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    ];
  }

  Color _getZoneColor(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'high':
        return Theme.of(context).colorScheme.error;
      case 'medium':
        return AppTheme.warningLight;
      case 'low':
        return AppTheme.successLight;
      default:
        return Theme.of(context).colorScheme.onSurfaceVariant;
    }
  }

  void _onMapTap(LatLng point) {
    setState(() {
      _selectedZone = null;
    });
  }

  void _onMapLongPress(LatLng point) {
    _showCaseReportingModal(
        latitude: point.latitude, longitude: point.longitude);
  }

  void _onZoneSelected(Map<String, dynamic> zone) {
    setState(() {
      _selectedZone = zone;
    });
  }

  void _onSearchChanged(String query) {
    // Handle search query changes
  }

  void _onLocationSelected(Map<String, dynamic> location) {
    final lat = location['latitude'] as double;
    final lng = location['longitude'] as double;
    final newLocation = LatLng(lat, lng);

    _mapController.move(newLocation, 10.0);

    // Check if location is in a health zone
    final zone = _healthZones.firstWhere(
      (zone) {
        final zoneCenter = zone['center'] as LatLng;
        final distance = Geolocator.distanceBetween(
          lat,
          lng,
          zoneCenter.latitude,
          zoneCenter.longitude,
        );
        return distance <= (zone['radius'] as double);
      },
      orElse: () => <String, dynamic>{},
    );

    if (zone.isNotEmpty) {
      setState(() {
        _selectedZone = zone;
      });
    }
  }

  void _centerOnCurrentLocation() async {
    await _getCurrentLocation();
    _mapController.move(_currentLocation, 12.0);
  }

  void _toggleLayers() {
    setState(() {
      _isLayerToggled = !_isLayerToggled;
    });
  }

  void _showCaseReportingModal({double? latitude, double? longitude}) {
    final lat = latitude ?? _currentLocation.latitude;
    final lng = longitude ?? _currentLocation.longitude;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CaseReportingModalWidget(
        latitude: lat,
        longitude: lng,
        onClose: () => Navigator.of(context).pop(),
        onSubmit: _onCaseReportSubmitted,
      ),
    );
  }

  void _onCaseReportSubmitted(Map<String, dynamic> reportData) {
    // Handle case report submission
    // In a real app, this would send data to a backend service
    print('Case report submitted: $reportData');
  }
}
