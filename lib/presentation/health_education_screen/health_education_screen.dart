import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/disease_category_card_widget.dart';
import './widgets/disease_detail_modal_widget.dart';
import './widgets/interactive_body_diagram_widget.dart';
import './widgets/search_bar_widget.dart';
import 'widgets/disease_category_card_widget.dart';
import 'widgets/disease_detail_modal_widget.dart';
import 'widgets/interactive_body_diagram_widget.dart';
import 'widgets/search_bar_widget.dart';

class HealthEducationScreen extends StatefulWidget {
  const HealthEducationScreen({super.key});

  @override
  State<HealthEducationScreen> createState() => _HealthEducationScreenState();
}

class _HealthEducationScreenState extends State<HealthEducationScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 2; // Education tab active
  TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  List<String> _bookmarkedDiseases = [];
  bool _isVoiceSearchActive = false;
  TabController? _tabController;

  final List<String> _categories = [
    'All',
    'Communicable',
    'Non-Communicable',
    'Nutritional',
    'Genetic',
    'Mental Health',
  ];

  final Map<String, List<Map<String, dynamic>>> _diseasesData = {
    'Communicable': [
      {
        'name': 'Tuberculosis (TB)',
        'prevalence': 'High',
        'severity': 'high',
        'symptoms': [
          'persistent cough ± blood',
          'chest pain',
          'fever',
          'night sweats',
          'weight loss',
          'fatigue'
        ],
        'prevention': [
          'hygiene',
          'ventilation',
          'avoid close contact with active TB'
        ],
        'vaccine': 'BCG (infancy/childhood)',
        'affectedOrgans': ['lungs', 'chest'],
        'description':
            'Bacterial infection primarily affecting the lungs, highly contagious and prevalent in India.',
      },
      {
        'name': 'Malaria',
        'prevalence': 'High',
        'severity': 'high',
        'symptoms': ['fever', 'chills', 'headache', 'myalgia', 'fatigue'],
        'prevention': [
          'nets',
          'repellent',
          'eliminate stagnant water',
          'prophylaxis in high-risk areas'
        ],
        'vaccine': 'RTS,S/AS01 (availability evolving in India)',
        'affectedOrgans': ['blood', 'liver', 'spleen'],
        'description':
            'Mosquito-borne parasitic infection causing fever and flu-like symptoms.',
      },
      {
        'name': 'Dengue',
        'prevalence': 'High',
        'severity': 'medium',
        'symptoms': [
          'high fever',
          'retro-orbital pain',
          'joint/muscle pain',
          'rash',
          'mild bleeding'
        ],
        'prevention': [
          'avoid Aedes bites',
          'remove stagnant water',
          'repellent'
        ],
        'vaccine': 'Limited availability; not widely deployed in India',
        'affectedOrgans': ['blood', 'immune system'],
        'description':
            'Viral infection spread by Aedes mosquitoes, common during monsoon season.',
      },
    ],
    'Non-Communicable': [
      {
        'name': 'Cardiovascular Diseases',
        'prevalence': 'Very High',
        'severity': 'high',
        'symptoms': ['angina', 'dyspnea', 'limb numbness/weakness'],
        'prevention': [
          'diet',
          'exercise',
          'no tobacco/alcohol misuse',
          'stress control',
          'BP & lipid checks'
        ],
        'vaccine': null,
        'affectedOrgans': ['heart', 'blood vessels'],
        'description':
            'Leading cause of death in India, includes heart disease and stroke.',
      },
      {
        'name': 'Diabetes Mellitus (Type 2)',
        'prevalence': 'Very High',
        'severity': 'medium',
        'symptoms': [
          'polyuria',
          'polydipsia',
          'polyphagia',
          'weight loss',
          'fatigue',
          'blurred vision'
        ],
        'prevention': [
          'healthy weight',
          'physical activity',
          'dietary control'
        ],
        'vaccine': null,
        'affectedOrgans': ['pancreas', 'blood', 'eyes', 'kidneys'],
        'description':
            'Metabolic disorder with high blood sugar levels, rapidly increasing in India.',
      },
    ],
    'Mental Health': [
      {
        'name': 'Depression',
        'prevalence': 'High',
        'severity': 'medium',
        'symptoms': [
          'persistent low mood',
          'anhedonia',
          'hopelessness',
          'sleep/appetite change'
        ],
        'prevention': [
          'early help-seeking',
          'exercise',
          'stress management',
          'support systems'
        ],
        'vaccine': null,
        'affectedOrgans': ['brain', 'nervous system'],
        'description':
            'Common mental health condition affecting mood and daily functioning.',
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _loadBookmarkedDiseases();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController?.dispose();
    super.dispose();
  }

  void _loadBookmarkedDiseases() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _bookmarkedDiseases = prefs.getStringList('bookmarked_diseases') ?? [];
    });
  }

  void _saveBookmarkedDiseases() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('bookmarked_diseases', _bookmarkedDiseases);
  }

  void _toggleBookmark(String diseaseName) {
    setState(() {
      if (_bookmarkedDiseases.contains(diseaseName)) {
        _bookmarkedDiseases.remove(diseaseName);
      } else {
        _bookmarkedDiseases.add(diseaseName);
      }
    });
    _saveBookmarkedDiseases();
  }

  List<Map<String, dynamic>> _getFilteredDiseases() {
    List<Map<String, dynamic>> allDiseases = [];

    if (_selectedCategory == 'All') {
      _diseasesData.values.forEach((diseases) {
        allDiseases.addAll(diseases);
      });
    } else {
      allDiseases = _diseasesData[_selectedCategory] ?? [];
    }

    if (_searchController.text.isNotEmpty) {
      final searchTerm = _searchController.text.toLowerCase();
      allDiseases = allDiseases.where((disease) {
        return disease['name'].toString().toLowerCase().contains(searchTerm) ||
            disease['symptoms'].any((symptom) =>
                symptom.toString().toLowerCase().contains(searchTerm));
      }).toList();
    }

    return allDiseases;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Health Education',
        actions: [
          IconButton(
            icon: Icon(
              Icons.bookmark_border,
              color: theme.colorScheme.onSurface,
            ),
            onPressed: () => _showBookmarkedDiseases(),
          ),
          IconButton(
            icon: Icon(
              Icons.accessibility_new,
              color: theme.colorScheme.onSurface,
            ),
            onPressed: () => _showBodyDiagram(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: EdgeInsets.all(16.w),
            child: SearchBarWidget(
              controller: _searchController,
              onChanged: (value) => setState(() {}),
              onVoiceSearch: () => _toggleVoiceSearch(),
              isVoiceActive: _isVoiceSearchActive,
            ),
          ),

          // Category Tabs
          Container(
            height: 50,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: theme.colorScheme.primary,
              labelColor: theme.colorScheme.primary,
              unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
              tabs: _categories.map((category) => Tab(text: category)).toList(),
              onTap: (index) {
                setState(() {
                  _selectedCategory = _categories[index];
                });
              },
            ),
          ),

          // Disease List
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(Duration(milliseconds: 500));
                setState(() {});
              },
              child: ListView.builder(
                padding: EdgeInsets.all(16.w),
                itemCount: _getFilteredDiseases().length,
                itemBuilder: (context, index) {
                  final disease = _getFilteredDiseases()[index];
                  return DiseaseCategoryCardWidget(
                    disease: disease,
                    isBookmarked: _bookmarkedDiseases.contains(disease['name']),
                    onBookmarkTap: () => _toggleBookmark(disease['name']),
                    onTap: () => _showDiseaseDetail(disease),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }

  void _toggleVoiceSearch() {
    setState(() {
      _isVoiceSearchActive = !_isVoiceSearchActive;
    });

    if (_isVoiceSearchActive) {
      // Simulate voice search functionality
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _isVoiceSearchActive = false;
          _searchController.text = 'diabetes'; // Example voice input
        });
      });
    }
  }

  void _showDiseaseDetail(Map<String, dynamic> disease) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DiseaseDetailModalWidget(
        disease: disease,
        isBookmarked: _bookmarkedDiseases.contains(disease['name']),
        onBookmarkToggle: () => _toggleBookmark(disease['name']),
      ),
    );
  }

  void _showBookmarkedDiseases() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bookmarked Diseases',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 16.h),
            if (_bookmarkedDiseases.isEmpty)
              Center(
                child: Text(
                  'No bookmarked diseases yet',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              )
            else
              ...(_bookmarkedDiseases.map((disease) => ListTile(
                    title: Text(disease),
                    leading: Icon(Icons.bookmark),
                    onTap: () {
                      Navigator.pop(context);
                      // Find and show disease detail
                      final diseaseData = _getFilteredDiseases().firstWhere(
                        (d) => d['name'] == disease,
                        orElse: () => {},
                      );
                      if (diseaseData.isNotEmpty) {
                        _showDiseaseDetail(diseaseData);
                      }
                    },
                  ))),
          ],
        ),
      ),
    );
  }

  void _showBodyDiagram() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: InteractiveBodyDiagramWidget(
          onOrganTap: (organ) {
            Navigator.pop(context);
            // Filter diseases by affected organs
            setState(() {
              _selectedCategory = 'All';
              _searchController.text = organ;
            });
          },
        ),
      ),
    );
  }
}