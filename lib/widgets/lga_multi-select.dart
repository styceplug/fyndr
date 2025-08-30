import 'package:flutter/material.dart';
import 'package:fyndr/data/services/employment_data.dart';
import 'package:fyndr/utils/colors.dart';

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



class JobBenefitsMultiSelect extends StatefulWidget {
  final List<String> benefits;
  final List<String> selectedBenefits;
  final ValueChanged<List<String>> onChanged;

  const JobBenefitsMultiSelect({
    super.key,
    required this.benefits,
    required this.selectedBenefits,
    required this.onChanged,
  });

  @override
  State<JobBenefitsMultiSelect> createState() => _JobBenefitsMultiSelectState();
}

class _JobBenefitsMultiSelectState extends State<JobBenefitsMultiSelect> {
  int visibleCount = 6;

  @override
  Widget build(BuildContext context) {
    final List<String> benefits = widget.benefits;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final hasMore = visibleCount < benefits.length;
    final hasExpanded = visibleCount > 6;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select as many Benefits as corresponding',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: benefits.take(visibleCount).map((lga) {
            final isSelected = widget.selectedBenefits.contains(lga);
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
                List<String> updated = List.from(widget.selectedBenefits);
                if (selected) {
                  if (!updated.contains(lga)) updated.add(lga);
                } else {
                  updated.remove(lga);
                }
                widget.onChanged(updated);
              },
            );
          }).toList(),
        ),
        if (hasMore || hasExpanded)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (hasMore)
                TextButton(
                  onPressed: () {
                    setState(() {
                      visibleCount =
                          (visibleCount + 6).clamp(0, benefits.length);
                    });
                  },
                  child: const Text("Show More"),
                ),
              if (hasExpanded)
                TextButton(
                  onPressed: () {
                    setState(() {
                      visibleCount = 6; // collapse back
                    });
                  },
                  child: const Text("Show Less"),
                ),
            ],
          ),
      ],
    );
  }
}


class SkillsMultiSelect extends StatelessWidget {
  final List<String> selectedSkills;
  final ValueChanged<List<String>> onChanged;

  const SkillsMultiSelect({
    super.key,
    required this.selectedSkills,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final Color effectiveBgColor = isDark ? AppColors.green2 : Color(0xFF85CE5C);


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select all that apply',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: skillsMap.entries.map((entry) {
            final skillName = entry.key;
            final skillValue = entry.value;
            final isSelected = selectedSkills.contains(skillValue);

            return FilterChip(
              label: Text(
                skillName,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : theme.textTheme.bodyLarge?.color,
                ),
              ),
              selected: isSelected,
              selectedColor: effectiveBgColor,
              backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
              checkmarkColor: Colors.white,
              onSelected: (selected) {
                List<String> updated = List.from(selectedSkills);
                if (selected) {
                  if (!updated.contains(skillValue)) updated.add(skillValue);
                } else {
                  updated.remove(skillValue);
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


class LanguageMultiSelect extends StatelessWidget {
  final List<String> selectedLanguage;
  final ValueChanged<List<String>> onChanged;

  const LanguageMultiSelect({
    super.key,
    required this.selectedLanguage,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final Color effectiveBgColor = isDark ? AppColors.green2 : Color(0xFF85CE5C);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select all that apply',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: languagesMap.map((entry) {
            final skillName = entry;
            final skillValue = entry;
            final isSelected = selectedLanguage.contains(skillValue);

            return FilterChip(
              label: Text(
                skillName,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : theme.textTheme.bodyLarge?.color,
                ),
              ),
              selected: isSelected,
              selectedColor: effectiveBgColor,
              backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
              checkmarkColor: Colors.white,
              onSelected: (selected) {
                List<String> updated = List.from(selectedLanguage);
                if (selected) {
                  if (!updated.contains(skillValue)) updated.add(skillValue);
                } else {
                  updated.remove(skillValue);
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