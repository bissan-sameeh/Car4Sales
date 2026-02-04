import 'package:flutter/material.dart';

class RateSection extends StatelessWidget {
  const RateSection({
    super.key,
    required this.rate,
    required this.color,
    this.size = 32,
    this.spacing = 6,
    this.inactiveColor = Colors.white30,
    this.onRateSelected,
  });

  final int rate;
  final Color color;
  final double size;
  final double spacing;
  final Color inactiveColor;
  final ValueChanged<int>? onRateSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final isSelected = rate >= index + 1;

        return GestureDetector(
          onTap: onRateSelected == null
              ? null
              : () => onRateSelected!(index + 1),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing / 2),
            child: AnimatedScale(
              scale: isSelected ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 150),
              child: Icon(
                isSelected ? Icons.star_rounded : Icons.star_border_rounded,
                size: size,
                color: isSelected ? color : inactiveColor,
              ),
            ),
          ),
        );
      }),
    );
  }
}