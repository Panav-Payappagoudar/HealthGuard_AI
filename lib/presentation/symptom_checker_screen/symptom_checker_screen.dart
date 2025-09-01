import 'dart:convert';
import 'dart:io' if (dart.library.io) 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:universal_html/html.dart' as html;

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/analysis_results_widget.dart';
import './widgets/body_diagram_widget.dart';
import './widgets/personal_info_widget.dart';
import './widgets/symptom_categories_widget.dart';
import './widgets/symptom_duration_widget.dart';
import './widgets/symptom_intensity_widget.dart';

class SymptomCheckerScreen extends StatefulWidget {
  const SymptomCheckerScreen({super.key});

  @override
  State<SymptomCheckerScreen> createState() => _SymptomCheckerScreenState();
}

class _SymptomCheckerScreenState extends State<SymptomCheckerScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _loadingController;
  late Animation<double> _loadingAnimation;

  int _currentStep = 0;
  int _currentBottomIndex = 4;
  bool _isAnalyzing = false;
  bool _showResults = false;

  // Form data
  String? _selectedBodyPart;
  double _symptomIntensity = 1.0;
  String _symptomDuration = '';
  List<String> _selectedSymptoms = [];
  Map<String, dynamic> _personalInfo = {
    'age': null,
    'gender': '',
    'medicalHistory': <String>[],
  };
  Map<String, dynamic> _analysisResults = {};

  final List<String> _stepTitles = [
    'Body Location',
    'Symptom Intensity',
    'Duration',
    'Symptoms',
    'Personal Info',
  ];

  // Mock AI analysis data
  final List<Map<String, dynamic>> _mockAnalysisResults = [
    {
      'riskLevel': 'Low',
      'summary':
          'Based on your symptoms, this appears to be a minor condition that may resolve on its own.',
      'recommendations': [
        'Rest and stay hydrated',
        'Monitor symptoms for 24-48 hours',
        'Consider over-the-counter pain relief if needed',
        'Contact a healthcare provider if symptoms worsen'
      ],
      'symptomCorrelation':
          'Your symptoms are commonly associated with minor viral infections or stress-related conditions. The mild intensity and recent onset suggest a self-limiting condition.',
      'possibleConditions': [
        'Common cold or viral infection',
        'Stress-related symptoms',
        'Minor muscular strain',
        'Dehydration'
      ]
    },
    {
      'riskLevel': 'Moderate',
      'summary':
          'Your symptoms warrant medical attention. Please consider consulting with a healthcare provider.',
      'recommendations': [
        'Schedule an appointment with your doctor within 1-2 days',
        'Keep a symptom diary',
        'Avoid strenuous activities',
        'Take prescribed medications as directed'
      ],
      'symptomCorrelation':
          'The combination and intensity of your symptoms suggest a condition that requires medical evaluation. Early intervention can prevent complications.',
      'possibleConditions': [
        'Bacterial infection requiring treatment',
        'Inflammatory condition',
        'Chronic condition flare-up',
        'Medication side effects'
      ]
    },
    {
      'riskLevel': 'High',
      'summary':
          'Your symptoms indicate a potentially serious condition. Seek immediate medical attention.',
      'recommendations': [
        'Contact emergency services (102/108) immediately',
        'Go to the nearest emergency room',
        'Do not drive yourself - call for help',
        'Bring a list of current medications'
      ],
      'symptomCorrelation':
          'The severity and combination of your symptoms require immediate medical evaluation. Prompt treatment is essential for the best outcomes.',
      'possibleConditions': [
        'Acute medical emergency',
        'Severe infection or sepsis',
        'Cardiovascular event',
        'Severe allergic reaction'
      ]
    }
  ];

  @override
  void initState() {
    super.initState();
    _loadingController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  bool _canProceedToNextStep() {
    switch (_currentStep) {
      case 0:
        return _selectedBodyPart != null;
      case 1:
        return true; // Intensity always has a default value
      case 2:
        return _symptomDuration.isNotEmpty;
      case 3:
        return _selectedSymptoms.isNotEmpty;
      case 4:
        return _personalInfo['age'] != null &&
            _personalInfo['gender']?.isNotEmpty == true;
      default:
        return false;
    }
  }

  void _nextStep() {
    if (_canProceedToNextStep() && _currentStep < _stepTitles.length - 1) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _analyzeSymptoms() async {
    setState(() {
      _isAnalyzing = true;
    });

    _loadingController.repeat();

    // Simulate AI analysis with realistic delay
    await Future.delayed(const Duration(seconds: 3));

    // Generate mock analysis based on input
    Map<String, dynamic> analysis = _generateMockAnalysis();

    setState(() {
      _isAnalyzing = false;
      _showResults = true;
      _analysisResults = analysis;
    });

    _loadingController.stop();
    _loadingController.reset();
  }

  Map<String, dynamic> _generateMockAnalysis() {
    // Determine risk level based on symptoms and intensity
    String riskLevel = 'Low';

    if (_symptomIntensity >= 2.5 || _selectedSymptoms.length >= 5) {
      riskLevel = 'High';
    } else if (_symptomIntensity >= 1.8 || _selectedSymptoms.length >= 3) {
      riskLevel = 'Moderate';
    }

    // Check for high-risk symptoms
    final highRiskSymptoms = [
      'Chest pain',
      'Shortness of breath',
      'Severe headache',
      'Confusion',
      'Seizures',
      'Severe abdominal pain'
    ];

    if (_selectedSymptoms
        .any((symptom) => highRiskSymptoms.contains(symptom))) {
      riskLevel = 'High';
    }

    // Get appropriate mock result
    Map<String, dynamic> baseResult = _mockAnalysisResults.firstWhere(
      (result) => result['riskLevel'] == riskLevel,
      orElse: () => _mockAnalysisResults[0],
    );

    // Customize based on user input
    Map<String, dynamic> customizedResult = Map.from(baseResult);
    customizedResult['analyzedSymptoms'] = _selectedSymptoms;
    customizedResult['bodyPart'] = _selectedBodyPart;
    customizedResult['intensity'] = _symptomIntensity;
    customizedResult['duration'] = _symptomDuration;
    customizedResult['timestamp'] = DateTime.now().toIso8601String();

    return customizedResult;
  }

  Future<void> _generateReport() async {
    try {
      final reportContent = _generateReportContent();
      final filename =
          'symptom_analysis_${DateTime.now().millisecondsSinceEpoch}.txt';

      if (kIsWeb) {
        final bytes = utf8.encode(reportContent);
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", filename)
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/$filename');
        await file.writeAsString(reportContent);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Report downloaded successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to download report'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _generateReportContent() {
    final buffer = StringBuffer();
    buffer.writeln('HEALTHGUARD AI - SYMPTOM ANALYSIS REPORT');
    buffer.writeln('=' * 50);
    buffer.writeln('Generated: ${DateTime.now().toString()}');
    buffer.writeln();

    buffer.writeln('PATIENT INFORMATION:');
    buffer.writeln('Age: ${_personalInfo['age'] ?? 'Not specified'}');
    buffer.writeln('Gender: ${_personalInfo['gender'] ?? 'Not specified'}');
    buffer.writeln(
        'Medical History: ${(_personalInfo['medicalHistory'] as List).isEmpty ? 'None' : (_personalInfo['medicalHistory'] as List).join(', ')}');
    buffer.writeln();

    buffer.writeln('SYMPTOM DETAILS:');
    buffer.writeln('Body Part: $_selectedBodyPart');
    buffer.writeln('Intensity: ${_symptomIntensity.toStringAsFixed(1)}/3.0');
    buffer.writeln('Duration: $_symptomDuration');
    buffer.writeln('Symptoms: ${_selectedSymptoms.join(', ')}');
    buffer.writeln();

    buffer.writeln('ANALYSIS RESULTS:');
    buffer.writeln('Risk Level: ${_analysisResults['riskLevel']}');
    buffer.writeln('Summary: ${_analysisResults['summary']}');
    buffer.writeln();

    buffer.writeln('RECOMMENDATIONS:');
    for (var recommendation in _analysisResults['recommendations']) {
      buffer.writeln('• $recommendation');
    }
    buffer.writeln();

    buffer.writeln('DISCLAIMER:');
    buffer.writeln(
        'This analysis is for informational purposes only and should not replace professional medical advice. Please consult with a healthcare provider for proper diagnosis and treatment.');

    return buffer.toString();
  }

  void _saveToChat() {
    // In a real app, this would save to chat history
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Analysis saved to chat history'),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate to AI Chat screen
    Navigator.pushNamed(context, '/ai-chat-screen');
  }

  void _resetForm() {
    setState(() {
      _currentStep = 0;
      _showResults = false;
      _selectedBodyPart = null;
      _symptomIntensity = 1.0;
      _symptomDuration = '';
      _selectedSymptoms = [];
      _personalInfo = {
        'age': null,
        'gender': '',
        'medicalHistory': <String>[],
      };
      _analysisResults = {};
    });

    _pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Symptom Checker',
        showBackButton: true,
        actions: [
          if (_showResults)
            IconButton(
              onPressed: _resetForm,
              icon: CustomIconWidget(
                iconName: 'refresh',
                color: theme.colorScheme.onSurface,
                size: 24,
              ),
              tooltip: 'Start Over',
            ),
        ],
      ),
      body: _isAnalyzing ? _buildLoadingView() : _buildMainContent(),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomIndex,
        onTap: (index) {
          setState(() {
            _currentBottomIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildLoadingView() {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _loadingAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _loadingAnimation.value * 2 * 3.14159,
                child: CustomIconWidget(
                  iconName: 'psychology',
                  color: theme.colorScheme.primary,
                  size: 64,
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Analyzing your symptoms...',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Our AI is processing your information',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 60.w,
            child: LinearProgressIndicator(
              backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.3),
              valueColor:
                  AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    if (_showResults) {
      return _buildResultsView();
    }

    return Column(
      children: [
        _buildProgressIndicator(),
        Expanded(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildBodyDiagramStep(),
              _buildIntensityStep(),
              _buildDurationStep(),
              _buildSymptomsStep(),
              _buildPersonalInfoStep(),
            ],
          ),
        ),
        _buildNavigationButtons(),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: List.generate(_stepTitles.length, (index) {
              final isActive = index == _currentStep;
              final isCompleted = index < _currentStep;

              return Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.only(
                      right: index < _stepTitles.length - 1 ? 8 : 0),
                  decoration: BoxDecoration(
                    color: isCompleted || isActive
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Text(
            'Step ${_currentStep + 1} of ${_stepTitles.length}: ${_stepTitles[_currentStep]}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyDiagramStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Where are you experiencing symptoms?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select the body part where you feel discomfort or pain.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 24),
          Center(
            child: BodyDiagramWidget(
              selectedBodyPart: _selectedBodyPart,
              onBodyPartSelected: (bodyPart) {
                setState(() {
                  _selectedBodyPart = bodyPart;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntensityStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How intense is your symptom?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Rate the intensity of your symptoms from mild to severe.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 24),
          SymptomIntensityWidget(
            intensity: _symptomIntensity,
            onIntensityChanged: (intensity) {
              setState(() {
                _symptomIntensity = intensity;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDurationStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Duration of symptoms',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'How long have you been experiencing these symptoms?',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 24),
          SymptomDurationWidget(
            duration: _symptomDuration,
            onDurationChanged: (duration) {
              setState(() {
                _symptomDuration = duration;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Describe your symptoms',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select all symptoms you are currently experiencing.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 24),
          SymptomCategoriesWidget(
            selectedSymptoms: _selectedSymptoms,
            onSymptomsChanged: (symptoms) {
              setState(() {
                _selectedSymptoms = symptoms;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal information',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'This information helps provide more accurate analysis.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 24),
          PersonalInfoWidget(
            personalInfo: _personalInfo,
            onInfoChanged: (info) {
              setState(() {
                _personalInfo = info;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildResultsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analysis Complete',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Based on your symptoms and information provided.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 24),
          AnalysisResultsWidget(
            analysisResults: _analysisResults,
            onGenerateReport: _generateReport,
            onSaveToChat: _saveToChat,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor,
            offset: const Offset(0, -2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: _previousStep,
                  child: const Text('Previous'),
                ),
              ),
            if (_currentStep > 0) const SizedBox(width: 16),
            Expanded(
              child: _currentStep < _stepTitles.length - 1
                  ? ElevatedButton(
                      onPressed: _canProceedToNextStep() ? _nextStep : null,
                      child: const Text('Next'),
                    )
                  : ElevatedButton(
                      onPressed:
                          _canProceedToNextStep() ? _analyzeSymptoms : null,
                      child: const Text('Analyze Symptoms'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
