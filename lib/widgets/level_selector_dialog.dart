import 'package:flutter/material.dart';

/// A reusable popup for picking the puzzle grid size.
/// Pass in the sizes you want shown — easy to extend later
/// without touching game_screen.dart.
class LevelSelectorDialog extends StatelessWidget {
  final int currentSize;
  final List<int> availableSizes;
  final ValueChanged<int> onSelected;

  const LevelSelectorDialog({
    super.key,
    required this.currentSize,
    required this.onSelected,
    this.availableSizes = const [3, 4], // add 5, 6, 7, 8 later
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFD9A86C),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF6B4226), width: 3),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: const BoxDecoration(
                color: Color(0xFF4A2E18),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(13),
                  topRight: Radius.circular(13),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 24),
                  const Text(
                    "Select Level",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.close, size: 16, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),

            // Level buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  for (final size in availableSizes) ...[
                    _LevelButton(
                      label: "$size × $size",
                      selected: size == currentSize,
                      onTap: () {
                        Navigator.pop(context);
                        onSelected(size);
                      },
                    ),
                    const SizedBox(height: 12),
                  ],
                  const Text(
                    "Current game progress will be lost",
                    style: TextStyle(
                      color: Color(0xFF4A2E18),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LevelButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFF0C988), Color(0xFFD9A86C)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected ? const Color(0xFF4A2E18) : const Color(0xFF8B5E34),
            width: selected ? 3 : 2,
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A2E18),
          ),
        ),
      ),
    );
  }
}

/// Convenience function so callers don't need to know Dialog internals.
Future<void> showLevelSelector(
  BuildContext context, {
  required int currentSize,
  required ValueChanged<int> onSelected,
  List<int> availableSizes = const [3, 4],
}) {
  return showDialog(
    context: context,
    builder: (_) => LevelSelectorDialog(
      currentSize: currentSize,
      availableSizes: availableSizes,
      onSelected: onSelected,
    ),
  );
}