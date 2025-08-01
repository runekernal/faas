import 'package:flutter/material.dart';

class AnimatedTextReveal extends StatefulWidget {
  final String text;
  final AnimationController controller;

  const AnimatedTextReveal({
    super.key,
    required this.text,
    required this.controller,
  });

  @override
  State<AnimatedTextReveal> createState() => _AnimatedTextRevealState();
}

class _AnimatedTextRevealState extends State<AnimatedTextReveal>
    with SingleTickerProviderStateMixin {
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _fadeAnimation = CurvedAnimation(
      parent: widget.controller,
      curve: const Interval(0.0, 1.0, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: widget.controller,
      curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            widget.text,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              height: 1.6,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
