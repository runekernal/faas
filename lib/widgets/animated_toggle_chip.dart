import 'package:flutter/material.dart';

class AnimatedToggleChip extends StatelessWidget {
  final List<String> options;
  final String selectedOption;
  final Function(String) onChanged;

  const AnimatedToggleChip({
    super.key,
    required this.options,
    required this.selectedOption,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selectedIndex = options.indexOf(selectedOption);

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(30),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;
          final spacing = 8.0; // total horizontal margin per chip (4 each side)
          final n = options.length;
          // Width per chip excluding margin
          final itemWidth = (totalWidth - (spacing * (n + 1))) / n;

          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOutCubic,
                top: 4,
                left: spacing + selectedIndex * (itemWidth + spacing),
                width: itemWidth,
                height: 52,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: options.map((option) {
                  final index = options.indexOf(option);
                  final isSelected = option == selectedOption;
                  return Container(
                    width: itemWidth,
                    margin: EdgeInsets.symmetric(horizontal: spacing / 2),
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => onChanged(option),
                      child: Container(
                        height: 60,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              transitionBuilder: (child, anim) {
                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, 1),
                                    end: Offset.zero,
                                  ).animate(anim),
                                  child: child,
                                );
                              },
                              child: Icon(
                                option == 'Apology'
                                    ? Icons.sentiment_satisfied_alt_rounded
                                    : Icons.sentiment_dissatisfied_rounded,
                                key: ValueKey('${option}_icon'),
                                color: isSelected
                                    ? Theme.of(context).colorScheme.onPrimary
                                    : Theme.of(context).colorScheme.onSurfaceVariant,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 8),
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              style: TextStyle(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.onPrimary
                                    : Theme.of(context).colorScheme.onSurfaceVariant,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              ),
                              child: Text(option),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}
