import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/foundation.dart';

class ResumeService {
  static const String _apiKey = 'AIzaSyDExHdrldjOmMA_mtp4ZB-y7AhwSO8vOm8';
  static late GenerativeModel _model;
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    debugPrint('📄 Initializing Resume Service...');
    try {
      _model = GenerativeModel(
        model: 'gemini-2.0-flash-exp',
        apiKey: _apiKey,
      );
      _isInitialized = true;
      debugPrint('✅ Resume Service initialized successfully');
    } catch (e) {
      debugPrint('❌ Error initializing Resume Service: $e');
    }
  }

  static Future<File?> pickResumeFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        debugPrint('📄 Resume file selected: ${result.files.single.name}');
        return File(result.files.single.path!);
      }
      return null;
    } catch (e) {
      debugPrint('❌ Error picking resume file: $e');
      return null;
    }
  }

  static Future<File?> pickResumeImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        debugPrint('📸 Resume image selected: ${image.name}');
        return File(image.path);
      }
      return null;
    } catch (e) {
      debugPrint('❌ Error picking resume image: $e');
      return null;
    }
  }

  static Future<String> analyzeResume(File resumeFile) async {
    await initialize();
    
    debugPrint('🔍 Analyzing resume: ${resumeFile.path}');
    
    try {
      final bytes = await resumeFile.readAsBytes();
      final imageBytes = base64Encode(bytes);
      
      final content = [
        Content.multi([
          TextPart('''
            Analyze this resume and provide:
            1. **Key Skills** - List the main technical and soft skills
            2. **Experience Level** - Assess the professional experience level
            3. **Strengths** - Highlight the strongest aspects
            4. **Areas for Improvement** - Suggest specific improvements
            5. **Career Recommendations** - Suggest suitable career paths
            6. **Learning Suggestions** - Recommend skills to develop
            
            Format the response in a clear, actionable way with bullet points and specific recommendations.
          '''),
          DataPart('image/jpeg', Uint8List.fromList(bytes)),
        ])
      ];

      final response = await _model.generateContent(content);
      final result = response.text ?? 'Unable to analyze resume at this time.';
      
      debugPrint('✅ Resume analysis completed (${result.length} chars)');
      return result;
    } catch (e) {
      debugPrint('❌ Error analyzing resume: $e');
      return 'Sorry, there was an error analyzing your resume. Please try again.';
    }
  }

  static Future<String> generateResumeFeedback(String resumeText) async {
    await initialize();
    
    debugPrint('📝 Generating resume feedback...');
    
    try {
      final content = [
        Content.text('''
          Analyze this resume text and provide comprehensive feedback:
          
          Resume Content:
          $resumeText
          
          Please provide:
          1. **Overall Assessment** - General impression and quality
          2. **Key Strengths** - What stands out positively
          3. **Areas for Improvement** - Specific suggestions for enhancement
          4. **Formatting Tips** - Layout and structure recommendations
          5. **Content Suggestions** - What to add, remove, or modify
          6. **ATS Optimization** - Tips for Applicant Tracking Systems
          7. **Industry-Specific Advice** - Tailored recommendations
          
          Format with clear headings and actionable bullet points.
        ''')
      ];

      final response = await _model.generateContent(content);
      final result = response.text ?? 'Unable to analyze resume at this time.';
      
      debugPrint('✅ Resume feedback generated (${result.length} chars)');
      return result;
    } catch (e) {
      debugPrint('❌ Error generating resume feedback: $e');
      return 'Sorry, there was an error analyzing your resume. Please try again.';
    }
  }
}
