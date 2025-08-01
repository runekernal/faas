import 'dart:io';
import 'package:flutter/material.dart';
import '../widgets/animated_text_reveal.dart';

class ResultScreen extends StatefulWidget {
  final File image;
  final String mode;
  final String style; // Added style parameter

  const ResultScreen({
    super.key,
    required this.image,
    required this.mode,
    required this.style, // Added to constructor
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

  String get _mockMessage {
    // Generate message based on both mode and style
    if (widget.mode == 'Apology') {
      switch (widget.style) {
        case 'Baby':
          return "Sowwy widdle object! 🥺\n\nMe vewy sowwy for being mean to you! You so pwetty and nice, and me was bad bad human. Pwease forgive me?\n\nMe pwomise to be nice!\n\nWuv,\nA sowwy human 👶";
        case 'Corporate':
          return "Dear Valued Object,\n\nWe sincerely regret any inconvenience our actions may have caused to your operational efficiency. Please accept our formal apology for this oversight.\n\nWe are committed to improving our object-human relations moving forward.\n\nBest regards,\nHuman Resources Department";
        case 'Shakespearean':
          return "Dearest Object of Mine Affection,\n\nVerily, I doth humbly beseech thy pardon for mine grievous transgressions against thy noble form. Thou art a thing of beauty, and I, but a foolish mortal, have wronged thee most shamefully.\n\nPray, accept mine heartfelt contrition.\n\nThine humble servant,\nA Repentant Soul";
        case 'Random':
          return "BEEP BOOP! 🤖\n\nERROR 404: Rudeness detected. Initiating apology protocol...\n\n*Sprinkles digital glitter* ✨ You're absolutely magnificent, dear object! My circuits are overloaded with regret for not appreciating your pixelated perfection sooner.\n\nRebooting with kindness.exe\n\n01001000 01110101 01101101 01100001 01101110";
        default: // Normal
          return "Dear Object,\n\nI sincerely apologize for any inconvenience I may have caused you. Your existence brings joy to this world, and I deeply regret not acknowledging your importance sooner.\n\nWith heartfelt remorse,\nA Humble Human";
      }
    } else { // Complaint
      switch (widget.style) {
        case 'Baby':
          return "Hey you dumb dumb object! 😤\n\nYou not doing what me want! Me vewy angwy at you! You supposed to be good but you just sit there like a silly billy!\n\nMe no like you!\n\nAngwy baby human 👶💢";
        case 'Corporate':
          return "FORMAL COMPLAINT - REF: OBJ-2024-001\n\nTo Whom It May Concern,\n\nWe must formally document our dissatisfaction with this object's performance metrics. Key issues include: suboptimal visual presentation, inadequate functionality parameters, and failure to meet stakeholder expectations.\n\nImmediate corrective action required.\n\nRegards,\nQuality Assurance Team";
        case 'Shakespearean':
          return "Thou Cursed and Wretched Thing!\n\nWhat manner of sorcery is this? Thou dost sit there, mocking me with thy silent insolence! Art thou not ashamed of thy pathetic existence? Verily, I have seen garden stones with more purpose!\n\nA pox upon thee and thy lineage!\n\nIn great vexation,\nA Most Displeased Gentleman";
        case 'Random':
          return "🚨 COMPLAINT ALERT 🚨\n\nThis object has committed CRIMES against aesthetic sensibility! It's just sitting there... MENACINGLY! 😱\n\n*Shakes fist at sky* Why do you torment me so, inanimate universe?! I demand to speak to the manager of reality!\n\n*Dramatic sigh*\n\nChaotically yours,\nA Confused Human";
        default: // Normal
          return "To Whom It May Concern,\n\nI must formally complain about this object's behavior. It has been sitting there, looking absolutely unremarkable, and frankly, I expected more.\n\nI demand immediate improvement in its overall presentation and functionality.\n\nSincerely disappointed,\nA Concerned Citizen";
      }
    }
  }

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
                text: _mockMessage,
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
