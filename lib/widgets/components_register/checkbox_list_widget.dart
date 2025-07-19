import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class CheckboxListWidget extends StatelessWidget {
  final List<String> options;
  final List<String> selected;
  final Function(bool?, String) onChanged;
  final String label;

  const CheckboxListWidget({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.textSecondary.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: options
                .map((option) => CheckboxListTile(
                      title: Text(option),
                      value: selected.contains(option),
                      activeColor: AppColors.primary,
                      checkColor: Colors.white,
                      onChanged: (value) => onChanged(value, option),
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 0),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}