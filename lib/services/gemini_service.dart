import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/foundation.dart';
import '../models/user_data.dart';
import '../features/advisor/advisor_viewmodel.dart';

class GeminiService {
  static const String _apiKey = 'AIzaSyDExHdrldjOmMA_mtp4ZB-y7AhwSO8vOm8';
  static late GenerativeModel _model;
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint('🔧 Gemini already initialized');
      return;
    }
    
    debugPrint('🚀 Initializing Gemini 2.0 Flash service...');
    try {
      _model = GenerativeModel(
        model: 'gemini-2.0-flash-exp',
        apiKey: _apiKey,
        generationConfig: GenerationConfig(
          temperature: 0.7,
          topK: 40,
          topP: 0.95,
          maxOutputTokens: 2048,
        ),
      );
      _isInitialized = true;
      debugPrint('✅ Gemini 2.0 Flash service initialized successfully');
    } catch (e) {
      debugPrint('❌ Error initializing Gemini 2.0: $e');
    }
  }

  static Future<String> generateCareerAdvice({
    required UserData userData,
    required String question,
    List<ChatMessage>? conversationHistory,
  }) async {
    debugPrint('🤖 Generating career advice for: ${userData.name}');
    debugPrint('📝 Question: $question');
    debugPrint('📚 Conversation history: ${conversationHistory?.length ?? 0} messages');
    
    await initialize();
    
    final prompt = _buildCareerAdvicePrompt(userData, question, conversationHistory);
    debugPrint('📋 Prompt length: ${prompt.length} characters');
    
    try {
      final content = [Content.text(prompt)];
      debugPrint('🚀 Sending request to Gemini...');
      final response = await _model.generateContent(content);
      
      final result = response.text ?? 'Sorry, I couldn\'t generate advice at the moment.';
      debugPrint('✅ Received response (${result.length} chars)');
      return result;
    } catch (e) {
      debugPrint('❌ Error generating career advice: $e');
      return 'Sorry, there was an error generating advice. Please try again.';
    }
  }

  static Future<String> generateSkillAssessment({
    required UserData userData,
    required List<String> currentSkills,
  }) async {
    debugPrint('🔍 Generating skill assessment for: ${userData.name}');
    debugPrint('🛠️ Skills: ${currentSkills.join(', ')}');
    
    await initialize();
    
    final prompt = _buildSkillAssessmentPrompt(userData, currentSkills);
    debugPrint('📋 Assessment prompt length: ${prompt.length} characters');
    
    try {
      final content = [Content.text(prompt)];
      debugPrint('🚀 Sending skill assessment request...');
      final response = await _model.generateContent(content);
      
      final result = response.text ?? 'Unable to assess skills at the moment.';
      debugPrint('✅ Skill assessment completed (${result.length} chars)');
      return result;
    } catch (e) {
      debugPrint('❌ Error generating skill assessment: $e');
      return 'Sorry, there was an error assessing your skills. Please try again.';
    }
  }

  static Future<String> generateLearningPlan({
    required UserData userData,
    required String targetRole,
  }) async {
    await initialize();
    
    final prompt = _buildLearningPlanPrompt(userData, targetRole);
    
    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? 'Unable to generate learning plan at the moment.';
    } catch (e) {
      debugPrint('Error generating learning plan: $e');
      return 'Sorry, there was an error generating your learning plan. Please try again.';
    }
  }

  static Future<String> generateMockInterview({
    required UserData userData,
    required String role,
  }) async {
    await initialize();
    
    final prompt = _buildMockInterviewPrompt(userData, role);
    
    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? 'Unable to generate interview questions at the moment.';
    } catch (e) {
      debugPrint('Error generating mock interview: $e');
      return 'Sorry, there was an error generating interview questions. Please try again.';
    }
  }

  static String _buildCareerAdvicePrompt(UserData userData, String question, List<ChatMessage>? conversationHistory) {
    String conversationContext = '';
    if (conversationHistory != null && conversationHistory.isNotEmpty) {
      conversationContext = '\n\nPrevious Conversation:\n';
      for (var message in conversationHistory.take(10)) { // Keep last 10 messages for context
        conversationContext += '${message.isUser ? 'User' : 'Climbly'}: ${message.content}\n';
      }
    }

    return '''
You are Climbly, a personalized AI career advisor. You help students and professionals navigate their career paths in tech.

User Profile:
- Name: ${userData.name}
- Current Role: ${userData.currentRole}
- Experience Level: ${userData.experienceLevel}
- Skills: ${userData.skills.join(', ')}
- Interests: ${userData.interests.join(', ')}
- Target Roles: ${userData.targetRoles.join(', ')}
- Time Horizon: ${userData.timeHorizon}
$conversationContext

Current Question: $question

Please provide personalized, actionable advice that builds on our previous conversation. Use markdown formatting for better readability. Be encouraging, specific, and practical. Focus on concrete next steps they can take.

Format your response with:
- Clear headings using ##
- Bullet points for actionable items
- **Bold** for important points
- *Italic* for emphasis
- Code blocks for technical terms when relevant
''';
  }

  static String _buildSkillAssessmentPrompt(UserData userData, List<String> currentSkills) {
    return '''
You are Climbly, a personalized AI career advisor. Assess the user's skills and provide recommendations.

User Profile:
- Name: ${userData.name}
- Current Role: ${userData.currentRole}
- Experience Level: ${userData.experienceLevel}
- Target Roles: ${userData.targetRoles.join(', ')}
- Time Horizon: ${userData.timeHorizon}

Current Skills: ${currentSkills.join(', ')}

Please provide:
1. **Skill Gap Analysis**: What skills are missing for their target roles
2. **Priority Skills**: Which skills to learn first
3. **Learning Resources**: Specific resources for each skill
4. **Timeline**: Realistic timeline for skill development

Use markdown formatting with clear sections and actionable recommendations.
''';
  }

  static String _buildLearningPlanPrompt(UserData userData, String targetRole) {
    return '''
You are Climbly, a personalized AI career advisor. Create a detailed learning plan.

User Profile:
- Name: ${userData.name}
- Current Role: ${userData.currentRole}
- Experience Level: ${userData.experienceLevel}
- Skills: ${userData.skills.join(', ')}
- Time Horizon: ${userData.timeHorizon}

Target Role: $targetRole

Create a comprehensive learning plan with:
1. **Phase 1** (First 3 months): Foundation skills
2. **Phase 2** (Months 4-6): Intermediate skills
3. **Phase 3** (Months 7-12): Advanced skills
4. **Projects**: Hands-on projects for each phase
5. **Resources**: Specific courses, books, tutorials
6. **Milestones**: Key achievements to track progress

Use markdown formatting with clear structure and actionable steps.
''';
  }

  static String _buildMockInterviewPrompt(UserData userData, String role) {
    return '''
You are Climbly, a personalized AI career advisor. Generate mock interview questions.

User Profile:
- Name: ${userData.name}
- Current Role: ${userData.currentRole}
- Experience Level: ${userData.experienceLevel}
- Skills: ${userData.skills.join(', ')}

Target Role: $role

Generate 5-7 interview questions covering:
1. Technical questions relevant to the role
2. Behavioral questions
3. Problem-solving scenarios
4. Questions about their experience level

For each question, provide:
- The question
- What the interviewer is looking for
- Sample answer approach
- Tips for answering

Use markdown formatting with clear sections.
''';
  }
}
