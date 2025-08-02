import 'package:flutter/material.dart';

import '../data/services/states_lga_local.dart';

class LgaMultiSelect extends StatelessWidget {
  final String state;
  final List<String> selectedLgas;
  final ValueChanged<List<String>> onChanged;

  const LgaMultiSelect({
    super.key,
    required this.state,
    required this.selectedLgas,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final lgas = stateLgaMap[state] ?? [];
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select up to 3 LGAs',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: lgas.map((lga) {
            final isSelected = selectedLgas.contains(lga);
            return FilterChip(
              label: Text(
                lga,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : theme.textTheme.bodyLarge?.color,
                ),
              ),
              selected: isSelected,
              selectedColor: theme.colorScheme.primary,
              backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
              checkmarkColor: Colors.white,
              onSelected: (selected) {
                List<String> updated = List.from(selectedLgas);
                if (selected) {
                  if (updated.length < 3) updated.add(lga);
                } else {
                  updated.remove(lga);
                }
                onChanged(updated);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}