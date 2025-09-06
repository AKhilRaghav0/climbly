import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class TypewriterTextWidget extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final MarkdownStyleSheet? markdownStyleSheet;
  final bool isMarkdown;
  final Duration speed;
  final VoidCallback? onComplete;

  const TypewriterTextWidget({
    super.key,
    required this.text,
    this.style,
    this.markdownStyleSheet,
    this.isMarkdown = false,
    this.speed = const Duration(milliseconds: 15),
    this.onComplete,
  });

  @override
  State<TypewriterTextWidget> createState() => _TypewriterTextWidgetState();
}

class _TypewriterTextWidgetState extends State<TypewriterTextWidget>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  String _displayedText = '';
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startTypewriter();
  }

  @override
  void didUpdateWidget(TypewriterTextWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _startTypewriter();
    }
  }

  void _startTypewriter() {
    // Dispose existing controller if it exists
    _controller?.dispose();
    
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.text.length * widget.speed.inMilliseconds),
      vsync: this,
    );

    _controller!.addListener(() {
      final progress = _controller!.value;
      final newIndex = (progress * widget.text.length).round();
      
      if (newIndex != _currentIndex && newIndex <= widget.text.length) {
        setState(() {
          _currentIndex = newIndex;
          _displayedText = widget.text.substring(0, _currentIndex);
        });
      }
    });

    _controller!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });

    if (widget.text.isNotEmpty) {
      _controller!.forward();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator if text is empty and we're waiting
    if (_displayedText.isEmpty && widget.text.isNotEmpty) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              'AI is thinking...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }
    
    // Don't show anything if text is empty
    if (_displayedText.isEmpty) {
      return const SizedBox.shrink();
    }
    
    if (widget.isMarkdown && widget.markdownStyleSheet != null) {
      return MarkdownBody(
        data: _displayedText,
        styleSheet: widget.markdownStyleSheet!,
      );
    }
    
    return Text(
      _displayedText,
      style: widget.style,
    );
  }
}
