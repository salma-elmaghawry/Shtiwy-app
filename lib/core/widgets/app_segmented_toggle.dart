import 'package:flutter/material.dart';

class AppSegmentedToggleItem<T> {
  final T value;
  final String label;
  final IconData? icon;

  const AppSegmentedToggleItem({
    required this.value,
    required this.label,
    this.icon,
  });
}

class AppSegmentedToggle<T> extends StatelessWidget {
  final List<AppSegmentedToggleItem<T>> items;
  final T selectedValue;
  final ValueChanged<T> onChanged;
  final double minSegmentWidth;

  const AppSegmentedToggle({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.minSegmentWidth = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: primaryColor, width: 1.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: items.map((item) {
          final isSelected = item.value == selectedValue;

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: isSelected ? null : () => onChanged(item.value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              constraints: BoxConstraints(minWidth: minSegmentWidth),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? primaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (item.icon != null) ...[
                    Icon(
                      item.icon,
                      size: 14,
                      color: isSelected ? Colors.white : primaryColor,
                    ),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    item.label,
                    style: TextStyle(
                      color: isSelected ? Colors.white : primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
