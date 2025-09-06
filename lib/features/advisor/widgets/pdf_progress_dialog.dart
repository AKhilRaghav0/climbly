import 'package:flutter/material.dart';

class PDFProgressDialog extends StatefulWidget {
  final String title;
  final String message;
  final Future<void> Function(Function(double) onProgress) task;
  final VoidCallback? onComplete;

  const PDFProgressDialog({
    super.key,
    required this.title,
    required this.message,
    required this.task,
    this.onComplete,
  });

  @override
  State<PDFProgressDialog> createState() => _PDFProgressDialogState();
}

class _PDFProgressDialogState extends State<PDFProgressDialog> {
  double _progress = 0.0;
  String _currentStep = 'Initializing...';
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _startTask();
  }

  Future<void> _startTask() async {
    try {
      await widget.task((progress) {
        if (mounted) {
          setState(() {
            _progress = progress;
            _currentStep = _getStepMessage(progress);
          });
        }
      });
      
      if (mounted) {
        setState(() {
          _isCompleted = true;
          _currentStep = 'Completed!';
        });
        
        // Wait a moment then close
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          Navigator.of(context).pop();
          widget.onComplete?.call();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _currentStep = 'Error: ${e.toString()}';
        });
        
        // Show error and close after delay
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    }
  }

  String _getStepMessage(double progress) {
    if (progress < 0.1) return 'Initializing PDF generation...';
    if (progress < 0.2) return 'Parsing content...';
    if (progress < 0.3) return 'Creating document structure...';
    if (progress < 0.5) return 'Generating pages...';
    if (progress < 0.7) return 'Formatting content...';
    if (progress < 0.9) return 'Finalizing document...';
    if (progress < 1.0) return 'Saving PDF...';
    return 'Opening PDF...';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    Icons.picture_as_pdf,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.message,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Progress indicator
            Container(
              width: double.infinity,
              height: 8,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: MediaQuery.of(context).size.width * 0.6 * _progress,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _isCompleted 
                          ? Colors.green 
                          : Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Progress text
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _currentStep,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  '${(_progress * 100).toInt()}%',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            
            if (_isCompleted) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'PDF generated successfully!',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
