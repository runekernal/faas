import 'dart:io';
import 'package:flutter/material.dart';
import '../widgets/animated_text_reveal.dart';

class ResultScreen extends StatefulWidget {
  final File image;
  final String mode;
  final String style;
  final String message;

  const ResultScreen({
    super.key,
    required this.image,
    required this.mode,
    required this.style,
    required this.message,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with TickerProviderStateMixin {
  late AnimationController _imageController;
  late AnimationController _textController;
  late Animation<double> _imageAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _textFadeAnimation;

  @override
  void initState() {
    super.initState();

    _imageController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _imageAnimation = CurvedAnimation(
      parent: _imageController,
      curve: Curves.easeOutBack,
    );

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOut,
    ));

    _textFadeAnimation = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    );

    // Start animations with delay
    _imageController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        _textController.forward();
      }
    });
  }

  @override
  void dispose() {
    _imageController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          widget.mode == 'Apology' ? 'Generated Apology' : 'Generated Complaint',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Animated Image Container
              ScaleTransition(
                scale: _imageAnimation,
                child: Container(
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.file(
                      widget.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Mode indicator with icon
              SlideTransition(
                position: _textSlideAnimation,
                child: FadeTransition(
                  opacity: _textFadeAnimation,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: widget.mode == 'Apology'
                          ? Colors.green.withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: widget.mode == 'Apology'
                            ? Colors.green.withOpacity(0.3)
                            : Colors.orange.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          widget.mode == 'Apology'
                              ? Icons.sentiment_satisfied_alt_rounded
                              : Icons.sentiment_dissatisfied_rounded,
                          color: widget.mode == 'Apology'
                              ? Colors.green
                              : Colors.orange,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.mode,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: widget.mode == 'Apology'
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Style indicator
              SlideTransition(
                position: _textSlideAnimation,
                child: FadeTransition(
                  opacity: _textFadeAnimation,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'Style: "${widget.style}"',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Animated Text Message
              AnimatedTextReveal(
                text: widget.message,
                controller: _textController,
              ),

              const SizedBox(height: 32),

              // Action buttons
              SlideTransition(
                position: _textSlideAnimation,
                child: FadeTransition(
                  opacity: _textFadeAnimation,
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // TODO: Implement share functionality
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Share functionality coming soon!'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          icon: const Icon(Icons.share_rounded),
                          label: const Text('Share'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('Try Again'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Theme.of(context).colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
