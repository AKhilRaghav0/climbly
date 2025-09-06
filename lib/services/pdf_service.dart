import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:skillforge/services/gemini_service.dart';
import 'package:markdown/markdown.dart' as md;

class PDFService {
  // Simple markdown parser for PDF - handles basic formatting
  static List<pw.Widget> _parseMarkdownToPDF(String markdownText) {
    List<pw.Widget> widgets = [];
    
    // Split by lines and process each
    List<String> lines = markdownText.split('\n');
    
    for (int i = 0; i < lines.length; i++) {
      String line = lines[i].trim();
      
      if (line.isEmpty) {
        widgets.add(pw.SizedBox(height: 8));
        continue;
      }
      
      // Headers
      if (line.startsWith('### ')) {
        widgets.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 8, top: 4),
            child: pw.Text(
              line.substring(4),
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.grey600,
              ),
            ),
          ),
        );
      } else if (line.startsWith('## ')) {
        widgets.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 12, top: 6),
            child: pw.Text(
              line.substring(3),
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.grey700,
              ),
            ),
          ),
        );
      } else if (line.startsWith('# ')) {
        widgets.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 16, top: 8),
            child: pw.Text(
              line.substring(2),
              style: pw.TextStyle(
                fontSize: 20,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.grey800,
              ),
            ),
          ),
        );
      }
      // Lists
      else if (line.startsWith('- ') || line.startsWith('* ')) {
        widgets.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 4, left: 16),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  '• ',
                  style: pw.TextStyle(
                    fontSize: 12,
                    color: PdfColors.grey600,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Expanded(
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: _parseInlineFormatting(line.substring(2)),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      // Numbered lists
      else if (RegExp(r'^\d+\. ').hasMatch(line)) {
        String number = RegExp(r'^\d+').firstMatch(line)?.group(0) ?? '1';
        widgets.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 4, left: 16),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  '$number. ',
                  style: pw.TextStyle(
                    fontSize: 12,
                    color: PdfColors.grey600,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Expanded(
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: _parseInlineFormatting(line.substring(number.length + 2)),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      // Tables
      else if (line.contains('|') && !line.startsWith('|---')) {
        List<List<String>> tableData = [];
        List<String> headers = line.split('|').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
        tableData.add(headers);
        
        // Skip separator line
        if (i + 1 < lines.length && lines[i + 1].contains('|---')) {
          i++;
        }
        
        // Collect table rows
        i++;
        while (i < lines.length && lines[i].contains('|')) {
          List<String> row = lines[i].split('|').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
          if (row.isNotEmpty) {
            tableData.add(row);
          }
          i++;
        }
        i--; // Adjust for the loop increment
        
        if (tableData.length > 1) {
          widgets.add(
            pw.Container(
              margin: const pw.EdgeInsets.symmetric(vertical: 12),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey400, width: 1),
                borderRadius: pw.BorderRadius.circular(8),
                boxShadow: [
                  pw.BoxShadow(
                    color: PdfColors.grey200,
                    blurRadius: 4,
                  ),
                ],
              ),
              child: pw.Table(
                border: pw.TableBorder(
                  horizontalInside: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
                  verticalInside: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
                  left: pw.BorderSide(color: PdfColors.grey400, width: 1),
                  right: pw.BorderSide(color: PdfColors.grey400, width: 1),
                  top: pw.BorderSide(color: PdfColors.grey400, width: 1),
                  bottom: pw.BorderSide(color: PdfColors.grey400, width: 1),
                ),
                children: tableData.asMap().entries.map((entry) {
                  int index = entry.key;
                  List<String> row = entry.value;
                  
                  return pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: index == 0 ? PdfColors.grey200 : PdfColors.white,
                    ),
                    children: row.map((cell) => pw.Padding(
                      padding: const pw.EdgeInsets.all(12),
                      child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: _parseInlineFormatting(cell),
                      ),
                    )).toList(),
                  );
                }).toList(),
              ),
            ),
          );
        }
      }
      // Code blocks
      else if (line.startsWith('```')) {
        List<String> codeLines = [];
        i++; // Skip the opening ```
        while (i < lines.length && !lines[i].trim().startsWith('```')) {
          codeLines.add(lines[i]);
          i++;
        }
        
        widgets.add(
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            margin: const pw.EdgeInsets.symmetric(vertical: 8),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey100,
              borderRadius: pw.BorderRadius.circular(6),
              border: pw.Border.all(color: PdfColors.grey300),
            ),
            child: pw.Text(
              codeLines.join('\n'),
              style: pw.TextStyle(
                fontSize: 11,
                color: PdfColors.grey800,
              ),
            ),
          ),
        );
      }
      // Regular paragraphs
      else {
        widgets.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 8),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: _parseInlineFormatting(line),
            ),
          ),
        );
      }
    }
    
    return widgets;
  }
  
  // Enhanced inline formatting parser that returns widgets
  static List<pw.Widget> _parseInlineFormatting(String text) {
    List<pw.Widget> widgets = [];
    
    // Split text by bold markers
    List<String> parts = text.split(RegExp(r'(\*\*.*?\*\*)'));
    
    for (String part in parts) {
      if (part.startsWith('**') && part.endsWith('**')) {
        // Bold text
        String boldText = part.substring(2, part.length - 2);
        widgets.add(
          pw.Text(
            boldText,
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.black,
            ),
          ),
        );
      } else if (part.startsWith('*') && part.endsWith('*') && !part.startsWith('**')) {
        // Italic text
        String italicText = part.substring(1, part.length - 1);
        widgets.add(
          pw.Text(
            italicText,
            style: pw.TextStyle(
              fontSize: 12,
              fontStyle: pw.FontStyle.italic,
              color: PdfColors.black,
            ),
          ),
        );
      } else if (part.startsWith('`') && part.endsWith('`')) {
        // Code text
        String codeText = part.substring(1, part.length - 1);
        widgets.add(
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey100,
              borderRadius: pw.BorderRadius.circular(3),
            ),
            child: pw.Text(
              codeText,
              style: pw.TextStyle(
                fontSize: 11,
                color: PdfColors.grey800,
              ),
            ),
          ),
        );
      } else if (part.trim().isNotEmpty) {
        // Regular text
        widgets.add(
          pw.Text(
            part,
            style: pw.TextStyle(
              fontSize: 12,
              color: PdfColors.black,
            ),
          ),
        );
      }
    }
    
    return widgets;
  }
  static Future<void> generateCareerAdvicePDF({
    required String content,
    required String userName,
    required Function(double) onProgress,
  }) async {
    try {
      debugPrint('📄 Starting enhanced PDF generation for: $userName');
      
      // Step 1: Initialize document
      onProgress(0.05);
      final pdf = pw.Document();
      
      // Step 2: Generate enhanced content with Gemini
      onProgress(0.1);
      final enhancedContent = await _generateEnhancedCareerContent(content, userName);
      
      // Step 3: Parse and structure content
      onProgress(0.2);
      final sections = _parseEnhancedContent(enhancedContent);
      
      // Step 4: Generate cover page
      onProgress(0.3);
      _generateCoverPage(pdf, userName, 'Career Guidance Report');
      
      // Step 5: Generate table of contents
      onProgress(0.4);
      _generateTableOfContents(pdf, sections);
      
      // Step 6: Generate main content pages
      onProgress(0.5);
      await _generateEnhancedPDFPages(pdf, sections, userName, onProgress);
      
      // Step 7: Generate footer and branding
      onProgress(0.8);
      _addFooterBranding(pdf);
      
      // Step 8: Save PDF
      onProgress(0.9);
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/climbly_career_advice_${DateTime.now().millisecondsSinceEpoch}.pdf');
      await file.writeAsBytes(await pdf.save());
      
      onProgress(1.0);
      debugPrint('✅ Enhanced PDF generated successfully: ${file.path}');
      
      // Step 9: Open PDF
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => file.readAsBytes(),
      );
      
    } catch (e) {
      debugPrint('❌ Error generating enhanced PDF: $e');
      rethrow;
    }
  }

  static Future<void> generateRoadmapPDF({
    required String roadmapContent,
    required String userName,
    required Function(double) onProgress,
  }) async {
    try {
      debugPrint('🗺️ Starting enhanced roadmap PDF generation for: $userName');
      
      // Step 1: Initialize document
      onProgress(0.05);
      final pdf = pw.Document();
      
      // Step 2: Generate enhanced roadmap content with Gemini
      onProgress(0.1);
      final enhancedContent = await _generateEnhancedRoadmapContent(roadmapContent, userName);
      
      // Step 3: Parse and structure content
      onProgress(0.2);
      final sections = _parseEnhancedContent(enhancedContent);
      
      // Step 4: Generate cover page
      onProgress(0.3);
      _generateCoverPage(pdf, userName, 'Learning Roadmap');
      
      // Step 5: Generate table of contents
      onProgress(0.4);
      _generateTableOfContents(pdf, sections);
      
      // Step 6: Generate main content pages
      onProgress(0.5);
      await _generateEnhancedPDFPages(pdf, sections, userName, onProgress);
      
      // Step 7: Generate footer and branding
      onProgress(0.8);
      _addFooterBranding(pdf);
      
      // Step 8: Save PDF
      onProgress(0.9);
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/climbly_roadmap_${DateTime.now().millisecondsSinceEpoch}.pdf');
      await file.writeAsBytes(await pdf.save());
      
      onProgress(1.0);
      debugPrint('✅ Enhanced roadmap PDF generated successfully: ${file.path}');
      
      // Step 9: Open PDF
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => file.readAsBytes(),
      );
      
    } catch (e) {
      debugPrint('❌ Error generating enhanced roadmap PDF: $e');
      rethrow;
    }
  }

  static Future<String> _generateEnhancedCareerContent(String originalContent, String userName) async {
    try {
      debugPrint('🤖 Generating enhanced content with Gemini...');
      
      final prompt = '''
You are Climbly AI, a professional career advisor. Transform this career advice into a comprehensive, structured PDF document.

Original Content:
$originalContent

User: $userName

Please create a detailed, professional career guidance report with the following structure:

# EXECUTIVE SUMMARY
[2-3 paragraph summary of key recommendations]

# CURRENT SITUATION ANALYSIS
[Analysis of user's current position and skills]

# SKILL GAPS IDENTIFIED
[Specific skills that need development with priority levels]

# RECOMMENDED LEARNING PATH
[Structured learning recommendations with timelines]

# CAREER OPPORTUNITIES
[Specific career paths and opportunities]

# ACTION PLAN
[Step-by-step actionable items with deadlines]

# RESOURCE RECOMMENDATIONS
[Specific resources, courses, and tools]

# NEXT STEPS
[Immediate next actions to take]

# INDUSTRY INSIGHTS
[Relevant industry trends and insights]

Make it professional, detailed, and actionable. Use bullet points, numbered lists, and clear headings. Include specific timelines and priorities.
''';

      final model = GenerativeModel(
        model: 'gemini-2.0-flash-exp',
        apiKey: 'AIzaSyDExHdrldjOmMA_mtp4ZB-y7AhwSO8vOm8',
      );

      final response = await model.generateContent([
        Content.text(prompt),
      ]);

      return response.text ?? originalContent;
    } catch (e) {
      debugPrint('❌ Error generating enhanced content: $e');
      return originalContent;
    }
  }

  static Future<String> _generateEnhancedRoadmapContent(String originalContent, String userName) async {
    try {
      debugPrint('🗺️ Generating enhanced roadmap content with Gemini...');
      
      final prompt = '''
You are Climbly AI, a professional career advisor. Transform this roadmap into a comprehensive, visual learning path document.

Original Content:
$originalContent

User: $userName

Please create a detailed, professional learning roadmap with the following structure:

# LEARNING OBJECTIVES
[Clear, measurable learning goals]

# PHASE 1: FOUNDATION (Months 1-2)
[Foundation skills and knowledge]

# PHASE 2: INTERMEDIATE (Months 3-4)
[Intermediate skills and projects]

# PHASE 3: ADVANCED (Months 5-6)
[Advanced skills and specialization]

# PHASE 4: MASTERY (Months 7-8)
[Expert-level skills and portfolio]

# MILESTONE TIMELINE
[Key milestones with dates and deliverables]

# SKILL PROGRESSION CHART
[Visual representation of skill development]

# PROJECT ROADMAP
[Hands-on projects for each phase]

# ASSESSMENT CHECKPOINTS
[How to measure progress at each stage]

# RESOURCE LIBRARY
[Specific resources for each phase]

# CAREER ADVANCEMENT PATH
[How this roadmap leads to career growth]

Make it visual, timeline-focused, and practical. Include specific projects, deadlines, and success metrics.
''';

      final model = GenerativeModel(
        model: 'gemini-2.0-flash-exp',
        apiKey: 'AIzaSyDExHdrldjOmMA_mtp4ZB-y7AhwSO8vOm8',
      );

      final response = await model.generateContent([
        Content.text(prompt),
      ]);

      return response.text ?? originalContent;
    } catch (e) {
      debugPrint('❌ Error generating enhanced roadmap content: $e');
      return originalContent;
    }
  }

  static List<Map<String, dynamic>> _parseEnhancedContent(String content) {
    final sections = <Map<String, dynamic>>[];
    
    // Split content by headers (## or ###)
    final lines = content.split('\n');
    String currentSection = '';
    String currentContent = '';
    
    for (String line in lines) {
      if (line.startsWith('##') || line.startsWith('###')) {
        if (currentSection.isNotEmpty) {
          sections.add({
            'title': currentSection,
            'content': currentContent.trim(),
            'type': _getSectionType(currentSection),
            'priority': _getSectionPriority(currentSection),
          });
        }
        currentSection = line.replaceAll('#', '').trim();
        currentContent = '';
      } else {
        currentContent += line + '\n';
      }
    }
    
    // Add the last section
    if (currentSection.isNotEmpty) {
      sections.add({
        'title': currentSection,
        'content': currentContent.trim(),
        'type': _getSectionType(currentSection),
        'priority': _getSectionPriority(currentSection),
      });
    }
    
    return sections;
  }

  static String _getSectionType(String title) {
    final lowerTitle = title.toLowerCase();
    if (lowerTitle.contains('executive') || lowerTitle.contains('summary')) return 'summary';
    if (lowerTitle.contains('action') || lowerTitle.contains('plan')) return 'action';
    if (lowerTitle.contains('roadmap') || lowerTitle.contains('timeline')) return 'roadmap';
    if (lowerTitle.contains('resource') || lowerTitle.contains('recommendation')) return 'resource';
    if (lowerTitle.contains('skill') || lowerTitle.contains('gap')) return 'skill';
    return 'content';
  }

  static int _getSectionPriority(String title) {
    final lowerTitle = title.toLowerCase();
    if (lowerTitle.contains('executive') || lowerTitle.contains('summary')) return 1;
    if (lowerTitle.contains('action') || lowerTitle.contains('plan')) return 2;
    if (lowerTitle.contains('skill') || lowerTitle.contains('gap')) return 3;
    if (lowerTitle.contains('roadmap') || lowerTitle.contains('timeline')) return 4;
    if (lowerTitle.contains('resource') || lowerTitle.contains('recommendation')) return 5;
    return 6;
  }

  static List<Map<String, dynamic>> _parseContentToSections(String content) {
    final sections = <Map<String, dynamic>>[];
    
    // Split content by headers (## or ###)
    final lines = content.split('\n');
    String currentSection = '';
    String currentContent = '';
    
    for (String line in lines) {
      if (line.startsWith('##') || line.startsWith('###')) {
        if (currentSection.isNotEmpty) {
          sections.add({
            'title': currentSection,
            'content': currentContent.trim(),
            'type': currentSection.toLowerCase().contains('roadmap') ? 'roadmap' : 'advice'
          });
        }
        currentSection = line.replaceAll('#', '').trim();
        currentContent = '';
      } else {
        currentContent += line + '\n';
      }
    }
    
    // Add the last section
    if (currentSection.isNotEmpty) {
      sections.add({
        'title': currentSection,
        'content': currentContent.trim(),
        'type': currentSection.toLowerCase().contains('roadmap') ? 'roadmap' : 'advice'
      });
    }
    
    return sections;
  }

  static List<Map<String, dynamic>> _parseRoadmapContent(String content) {
    // Parse roadmap-specific content
    return _parseContentToSections(content);
  }

  static void _generateCoverPage(pw.Document pdf, String userName, String reportType) {
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            width: double.infinity,
            height: double.infinity,
            decoration: pw.BoxDecoration(
              gradient: pw.LinearGradient(
                begin: pw.Alignment.topLeft,
                end: pw.Alignment.bottomRight,
                colors: [
                  PdfColors.blue50,
                  PdfColors.blue100,
                ],
              ),
            ),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                // Climbly AI Logo (using text as icon placeholder)
                pw.Container(
                  width: 120,
                  height: 120,
                  decoration: pw.BoxDecoration(
                    color: PdfColors.blue800,
                    borderRadius: pw.BorderRadius.circular(60),
                  ),
                  child: pw.Center(
                    child: pw.Text(
                      'CA',
                      style: pw.TextStyle(
                        fontSize: 48,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                      ),
                    ),
                  ),
                ),
                
                pw.SizedBox(height: 40),
                
                // Report Title
                pw.Text(
                  reportType,
                  style: pw.TextStyle(
                    fontSize: 32,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue900,
                  ),
                ),
                
                pw.SizedBox(height: 20),
                
                // Subtitle
                pw.Text(
                  'Powered by Climbly AI',
                  style: pw.TextStyle(
                    fontSize: 18,
                    color: PdfColors.blue700,
                    fontStyle: pw.FontStyle.italic,
                  ),
                ),
                
                pw.SizedBox(height: 40),
                
                // User Info
                pw.Container(
                  padding: const pw.EdgeInsets.all(30),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.white,
                    borderRadius: pw.BorderRadius.circular(15),
                    boxShadow: [
                      pw.BoxShadow(
                        color: PdfColors.grey300,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: pw.Column(
                    children: [
                      pw.Text(
                        'Generated for',
                        style: pw.TextStyle(
                          fontSize: 16,
                          color: PdfColors.grey600,
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        userName,
                        style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.blue800,
                        ),
                      ),
                      pw.SizedBox(height: 20),
                      pw.Text(
                        'Generated on: ${DateTime.now().toString().split(' ')[0]}',
                        style: pw.TextStyle(
                          fontSize: 14,
                          color: PdfColors.grey500,
                        ),
                      ),
                    ],
                  ),
                ),
                
                pw.SizedBox(height: 60),
                
                // Footer
                pw.Text(
                  'Your AI-Powered Career Companion',
                  style: pw.TextStyle(
                    fontSize: 14,
                    color: PdfColors.blue600,
                    fontStyle: pw.FontStyle.italic,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static void _generateTableOfContents(pw.Document pdf, List<Map<String, dynamic>> sections) {
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
                pw.Text(
                  'Table of Contents',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey800,
                  ),
                ),
              
              pw.SizedBox(height: 30),
              
              ...sections.asMap().entries.map((entry) {
                final index = entry.key + 1;
                final section = entry.value;
                final pageNumber = index + 2; // +2 for cover and TOC pages
                
                return pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 15),
                  child: pw.Row(
                    children: [
                      pw.Container(
                        width: 30,
                        height: 30,
                        decoration: pw.BoxDecoration(
                          color: PdfColors.grey400,
                          borderRadius: pw.BorderRadius.circular(15),
                        ),
                        child: pw.Center(
                          child: pw.Text(
                            '$index',
                            style: pw.TextStyle(
                              fontSize: 12,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.white,
                            ),
                          ),
                        ),
                      ),
                      pw.SizedBox(width: 15),
                      pw.Expanded(
                        child: pw.Text(
                          section['title'],
                          style: pw.TextStyle(
                            fontSize: 14,
                            color: PdfColors.blue800,
                          ),
                        ),
                      ),
                      pw.Text(
                        '$pageNumber',
                        style: pw.TextStyle(
                          fontSize: 12,
                          color: PdfColors.grey600,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }

  static PdfColor _getSectionColor(String type) {
    switch (type) {
      case 'summary': return PdfColors.grey800; // Dark gray for headers
      case 'action': return PdfColors.grey700; // Medium dark gray
      case 'roadmap': return PdfColors.grey600; // Medium gray
      case 'resource': return PdfColors.grey500; // Lighter gray
      case 'skill': return PdfColors.grey400; // Light gray
      default: return PdfColors.grey600; // Default medium gray
    }
  }

  static Future<void> _generateEnhancedPDFPages(
    pw.Document pdf,
    List<Map<String, dynamic>> sections,
    String userName,
    Function(double) onProgress,
  ) async {
    double progress = 0.5;
    final progressStep = 0.3 / sections.length;
    
    // Generate content pages
    for (var section in sections) {
      progress += progressStep;
      onProgress(progress);
      
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (pw.Context context) {
            return pw.Stack(
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Section header with icon
                pw.Container(
                  padding: const pw.EdgeInsets.all(20),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey200,
                    borderRadius: pw.BorderRadius.circular(10),
                    border: pw.Border.all(
                      color: PdfColors.grey300,
                      width: 2,
                    ),
                  ),
                  child: pw.Row(
                    children: [
                      pw.Container(
                        width: 40,
                        height: 40,
                        decoration: pw.BoxDecoration(
                          color: PdfColors.grey600,
                          borderRadius: pw.BorderRadius.circular(20),
                        ),
                        child: pw.Center(
                          child: pw.Text(
                            _getSectionIcon(section['type']),
                            style: pw.TextStyle(
                              fontSize: 20,
                              color: PdfColors.white,
                            ),
                          ),
                        ),
                      ),
                      pw.SizedBox(width: 15),
                      pw.Expanded(
                        child: pw.Text(
                          section['title'],
                          style: pw.TextStyle(
                            fontSize: 20,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.grey800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                pw.SizedBox(height: 25),
                
                // Section content with markdown support
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: _parseMarkdownToPDF(section['content']),
                ),
                
                pw.SizedBox(height: 20),
                
                ],
                ),
                // Footer positioned at bottom
                pw.Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(15),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.grey100,
                      borderRadius: pw.BorderRadius.circular(8),
                    ),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Climbly AI • Your Career Companion',
                          style: pw.TextStyle(
                            fontSize: 10,
                            color: PdfColors.grey600,
                            fontStyle: pw.FontStyle.italic,
                          ),
                        ),
                        pw.Text(
                          'Page ${context.pageNumber}',
                          style: pw.TextStyle(
                            fontSize: 10,
                            color: PdfColors.grey600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
    }
  }

  static String _getSectionIcon(String type) {
    switch (type) {
      case 'summary': return '📊';
      case 'action': return '✅';
      case 'roadmap': return '🗺️';
      case 'resource': return '📚';
      case 'skill': return '🎯';
      default: return '📄';
    }
  }

  static void _addFooterBranding(pw.Document pdf) {
    // This method is called after all pages are generated
    // The footer branding is already added to each page in _generateEnhancedPDFPages
    debugPrint('🏷️ Footer branding added to all pages');
  }

  static Future<void> _generatePDFPages(
    pw.Document pdf,
    List<Map<String, dynamic>> sections,
    String userName,
    Function(double) onProgress,
  ) async {
    double progress = 0.3;
    final progressStep = 0.5 / sections.length;
    
    // Cover page
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(40),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Column(
                  children: [
                    pw.Text(
                      'Climbly AI Career Advisor',
                      style: pw.TextStyle(
                        fontSize: 28,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.grey800,
                      ),
                    ),
                    pw.SizedBox(height: 20),
                    pw.Text(
                      'Personalized Career Guidance Report',
                      style: pw.TextStyle(
                        fontSize: 18,
                        color: PdfColors.grey600,
                      ),
                    ),
                    pw.SizedBox(height: 30),
                    pw.Text(
                      'Generated for: $userName',
                      style: pw.TextStyle(
                        fontSize: 16,
                        color: PdfColors.grey500,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      'Generated on: ${DateTime.now().toString().split(' ')[0]}',
                      style: pw.TextStyle(
                        fontSize: 14,
                        color: PdfColors.grey400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
    
    // Content pages
    for (var section in sections) {
      progress += progressStep;
      onProgress(progress);
      
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  section['title'],
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue800,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  section['content'],
                  style: pw.TextStyle(
                    fontSize: 12,
                    lineSpacing: 1.5,
                    color: PdfColors.black,
                  ),
                ),
              ],
            );
          },
        ),
      );
    }
  }

  static Future<void> _generateRoadmapPages(
    pw.Document pdf,
    List<Map<String, dynamic>> roadmapSections,
    String userName,
    Function(double) onProgress,
  ) async {
    double progress = 0.3;
    final progressStep = 0.5 / roadmapSections.length;
    
    // Roadmap cover page
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(40),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Column(
                  children: [
                    pw.Text(
                      'Career Roadmap',
                      style: pw.TextStyle(
                        fontSize: 32,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.grey800,
                      ),
                    ),
                    pw.SizedBox(height: 20),
                    pw.Text(
                      'Your Personalized Learning Path',
                      style: pw.TextStyle(
                        fontSize: 18,
                        color: PdfColors.grey600,
                      ),
                    ),
                    pw.SizedBox(height: 30),
                    pw.Text(
                      'Created for: $userName',
                      style: pw.TextStyle(
                        fontSize: 16,
                        color: PdfColors.blue600,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      'Generated on: ${DateTime.now().toString().split(' ')[0]}',
                      style: pw.TextStyle(
                        fontSize: 14,
                        color: PdfColors.blue500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
    
    // Roadmap content pages
    for (var section in roadmapSections) {
      progress += progressStep;
      onProgress(progress);
      
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  section['title'],
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue800,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  section['content'],
                  style: pw.TextStyle(
                    fontSize: 12,
                    lineSpacing: 1.5,
                    color: PdfColors.black,
                  ),
                ),
              ],
            );
          },
        ),
      );
    }
  }
}
