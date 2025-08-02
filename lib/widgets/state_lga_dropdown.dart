import 'package:flutter/material.dart';

import '../data/services/states_lga_local.dart';


class StateLgaDropdown extends StatelessWidget {
  final String? selectedState;
  final String? selectedLga;
  final Function(String?) onStateChanged;
  final Function(String?) onLgaChanged;

  const StateLgaDropdown({
    super.key,
    required this.selectedState,
    required this.selectedLga,
    required this.onStateChanged,
    required this.onLgaChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lgas = selectedState != null ? stateLgaMap[selectedState!] ?? [] : [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select State",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedState,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            filled: true,
            fillColor: isDark ? Colors.white12 : const Color(0xFFDBD0C8).withOpacity(0.1),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          items: stateLgaMap.keys.map((state) {
            return DropdownMenuItem(
              value: state,
              child: Text(state),
            );
          }).toList(),
          onChanged: (value) {
            onStateChanged(value);
            onLgaChanged(null); // Clear LGA on state change
          },
          hint: Text(
            "Choose a state",
            style: TextStyle(color: Theme.of(context).hintColor),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Select LGA",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedLga,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            filled: true,
            fillColor: isDark ? Colors.white12 : const Color(0xFFDBD0C8).withOpacity(0.1),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          items: lgas.map<DropdownMenuItem<String>>((lga) {
            return DropdownMenuItem<String>(
              value: lga,
              child: Text(lga),
            );
          }).toList(),
          onChanged: onLgaChanged,
          hint: Text(
            "Choose an LGA",
            style: TextStyle(color: Theme.of(context).hintColor),
          ),
        ),
      ],
    );
  }
}